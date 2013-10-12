--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/tree_marsh.zip"),
}

local prefabs =
{
	"crystal_fragment",
    "cloud_lightning",
    "marble",
}

local loot = 
{
	"crystal_fragment",
	"marble",
	"cloud_lightning",
}

local function sway(inst)
    inst.AnimState:PushAnimation("sway"..math.random(4).."_loop", true)
end

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
    inst.AnimState:PlayAnimation("chop")
    sway(inst)
end

local function set_stump(inst)
    inst:RemoveComponent("workable")
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    RemovePhysicsColliders(inst)
    inst:AddTag("stump")
end

local function dig_up_stump(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("cloud_lightning")
end


local function chop_down_tree(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    inst.AnimState:PlayAnimation("fall")
    inst.AnimState:PushAnimation("stump", false)
    set_stump(inst)
    inst.components.lootdropper:DropLoot()
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)
end

local function onsave(inst, data)
    if inst:HasTag("stump") then
        data.stump = true
    end
end
        
local function onload(inst, data)
    if data then
        if data.stump then
            inst:RemoveComponent("workable")
            inst:RemoveComponent("burnable")
            inst:RemoveComponent("propagator")
            inst:RemoveComponent("growable")
            RemovePhysicsColliders(inst)
            inst.AnimState:PlayAnimation("stump", false)
            inst:AddTag("stump")
            
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetOnFinishCallback(dig_up_stump)
            inst.components.workable:SetWorkLeft(1)
        end
    end
end   

local function OnSpawned(inst, child)
	GetSeasonManager():DoLightningStrike(Vector3(inst.Transform:GetWorldPosition()))
	if GetClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 2 then
        StopSpawning(inst)
    end
end

local function StartSpawning(inst)
	if inst.components.childspawner and GetSeasonManager() and GetSeasonManager():IsWinter() then
		inst.components.childspawner:StartSpawning()
	end
end

local function StopSpawning(inst)
	if inst.components.childspawner then
		inst.components.childspawner:StopSpawning()
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "marshtree.png" )
	minimap:SetPriority(-1)

    MakeObstaclePhysics(inst, .25)   
    inst:AddTag("tree")

    MakeLargeBurnable(inst)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("lootdropper") 
    inst.components.lootdropper:SetLoot(loot)
    inst.components.lootdropper:AddChanceLoot("cloud_lightning", 1)
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    anim:SetBuild("tree_marsh")
    anim:SetBank("marsh_tree")
    local color = 0.2 + math.random() * 0.2
    anim:SetMultColour(color, color, color, 1)
    sway(inst)
    anim:SetTime(math.random()*2)
    
    inst:AddComponent("inspectable")

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "cloud_lightning"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*10)
	inst.components.childspawner:SetSpawnPeriod(10)
	inst.components.childspawner:SetMaxChildren(3)
    
    inst.OnSave = onsave
    inst.OnLoad = onload
    return inst
end

return Prefab("cloudrealm/objects/thunder_tree", fn, assets) 
