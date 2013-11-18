--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs = 
{
	"owl",
	"crystal_fragment_relic",
}

local CFG = TheMod:GetConfig()

local loot = 
{
    "crystal_fragment_relic",
	"crystal_fragment_relic",
	"crystal_fragment_relic",
}
        
local function onMined(inst, worker)
    inst:RemoveComponent("childspawner")
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function OnActivate(inst)
	inst.components.resurrector.active = true
	inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_activate")
end

local function doresurrect(inst, dude)
	inst:AddTag("busy")	
	inst.MiniMapEntity:SetEnabled(false)
    if inst.Physics then
		MakeInventoryPhysics(inst) -- collides with world, but not character
    end

	GetClock():MakeNextDay()
    dude.Transform:SetPosition(inst.Transform:GetWorldPosition())
    dude:Hide()
    TheCamera:SetDistance(12)

    scheduler:ExecuteInTime(3, function()
        dude:Show()
        --inst:Hide()

        GetSeasonManager():DoLightningStrike(Vector3(inst.Transform:GetWorldPosition()))


		inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_break")
        --inst.components.lootdropper:DropLoot()
        inst:Remove()
        
        if dude.components.hunger then
            dude.components.hunger:SetPercent(.5)
        end

        if dude.components.health then
            dude.components.health:Respawn(.5)
        end
        
        if dude.components.sanity then
			dude.components.sanity:SetPercent(.5)
        end
        
        dude.sg:GoToState("wakeup")
        
        dude:DoTaskInTime(3, function(inst) 
		            if dude.HUD then
		                dude.HUD:Show()
		            end
		            TheCamera:SetDefault()
		            inst:RemoveTag("busy")

			--SaveGameIndex:SaveCurrent(function()
			--	end)            
        end)
        
    end)
end

local function makeactive(inst)
	--inst.AnimState:PlayAnimation("idle_activate", true)
	inst.components.activatable.inactive = false
end

local function makeused(inst)
	--inst.AnimState:PlayAnimation("idle_broken", true)
end

local function onhit(inst, worker)
	--inst.AnimState:PlayAnimation("hit_rundown")
	--inst.AnimState:PushAnimation("rundown")

	inst.thief = worker
	inst.components.childspawner.noregen = true
	if inst.components.childspawner and worker then
		for k,v in pairs(inst.components.childspawner.childrenoutside) do
			if v.components.combat then
				v.components.combat:SuggestTarget(worker)
			end
		end
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

local function OnSpawned(inst, child)
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	if GetClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 3 and not child.components.combat.target then
        StopSpawning(inst)
    end
end

local function OnGoHome(inst, child) 
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	if inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() < 3 then
        StartSpawning(inst)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mermhouse.png")
    
    MakeObstaclePhysics(inst, 1)

	anim:SetBank("crystal")
	anim:SetBuild("crystal")
    anim:PlayAnimation("crystal_relic")
    MakeObstaclePhysics(inst, 1.)

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnFinishCallback(onMined)
	inst.components.workable:SetOnWorkCallback(onhit)	
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "owl"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*7)
	inst.components.childspawner:SetSpawnPeriod(10)
	inst.components.childspawner:SetMaxChildren(5)

	inst:AddComponent("resurrector")
	inst.components.resurrector.makeactivefn = makeactive
	inst.components.resurrector.makeusedfn = makeused
	inst.components.resurrector.doresurrect = doresurrect

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "Sacred Crystal"
	
	--MakeSnowCovered(inst, .01)
    return inst
end

return Prefab("cloudrealm/objects/crystal_relic", fn, assets, prefabs )  
