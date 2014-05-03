BindGlobal()

local assets =
{
	Asset("ANIM", "anim/tree_thunder.zip"),
}

local prefabs =
{
    "cloud_lightning",
    "cumulostone",
    "ball_lightning",
}

local short_loot = 
{
    "thunder_log",  
}

local normal_loot = 
{
    "thunder_log",
    "thunder_log",  
}

local tall_loot = 
{
    "thunder_log",
    "thunder_log",
    "thunder_log",      
}

local function StartSpawning(inst)
    if inst.components.childspawner and GetSeasonManager() and GetSeasonManager():IsWinter() and not GetWorld().components.staticgenerator.charged then
        inst.components.childspawner:StartSpawning()
        --print("Tree spawning.")
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
        --print("Tree no longer spawning.")
    end
end

local function SetShort(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end 
    inst.components.lootdropper:SetLoot(short_loot)
    inst.Transform:SetScale(0.7, 0.7, 0.7)
    if inst.components.staticchargeable then
        inst:RemoveComponent("staticchargeable")
    end    
end

local function GrowShort(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")          
end

local function SetNormal(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_NORMAL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end     
    inst.components.lootdropper:SetLoot(normal_loot)
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    if inst.components.staticchargeable then
        inst:RemoveComponent("staticchargeable")
    end 
end

local function GrowNormal(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local function SetTall(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_TALL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end     
    inst.components.lootdropper:SetLoot(tall_loot)
    inst.Transform:SetScale(1, 1, 1)   
    inst.components.lootdropper:AddChanceLoot("cumulostone", 1)
    if not inst.components.staticchargeable then
        inst:AddComponent("staticchargeable")
        inst.components.staticchargeable:SetChargedFn(function(inst)
            StopSpawning(inst)
        end)
        inst.components.staticchargeable:SetUnchargedFn(function(inst)
            StartSpawning(inst)
        end)
    end    
end

local function GrowTall(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local growth_stages =
{
    {name="short", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end , leifscale=.7 },
    {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, TUNING.EVERGREEN_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end, leifscale=1 },
    {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, TUNING.EVERGREEN_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end, leifscale=1.25 },
}

local function sway(inst)
    inst.AnimState:PushAnimation("sway"..math.random(4).."_loop", true)
end

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")         
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
    local lightning = SpawnPrefab("lightning")
    if not GetWorld().components.staticgenerator.charged then
	   lightning.Transform:SetPosition(child.Transform:GetWorldPosition())
    end   
end

local function fn(Sim, stage)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter()

    if stage == nil then
        stage = math.random(1,3)
    end

    local l_stage = stage
    if l_stage == 0 then
        l_stage = math.random(1,3)
    end 

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(l_stage)
    inst.components.growable.loopstages = true
    inst.components.growable:StartGrowing()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "marshtree.png" )
	minimap:SetPriority(-1)

    MakeObstaclePhysics(inst, .25)   
    inst:AddTag("tree")
    
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end 

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "cloud_lightning"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*10)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner.spawnoffscreen = false
    inst.components.childspawner:SetRareChild("ball_lightning", 0.2)
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 17)
    inst.components.playerprox:SetOnPlayerFar(StopSpawning)
    inst.components.playerprox:SetOnPlayerNear(StartSpawning)

    anim:SetBuild("tree_thunder")
    anim:SetBank("marsh_tree")
    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)
    sway(inst)
    anim:SetTime(math.random()*2)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
 
    local scale = math.random(0.8,1.4)
    inst.Transform:SetScale(scale, scale, scale)

    inst:AddComponent("inspectable")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("thunder_tree.tex") 

    inst.OnSave = onsave
    inst.OnLoad = onload
    return inst
end

return Prefab("cloudrealm/objects/thunder_tree", fn, assets, prefabs) 
