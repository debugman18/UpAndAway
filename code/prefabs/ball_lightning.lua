BindGlobal()

local cfg = wickerrequire('adjectives.configurable')("BALL_LIGHTNING")

local prefabs =
{
	"cloud_lightning",
}

local assets =
{
	Asset("ANIM", "anim/ball_lightning.zip"),
}

local SLEEP_DIST_FROMHOME = 10
local SLEEP_DIST_FROMTHREAT = 0
local MAX_CHASEAWAY_DIST = 0
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local loot = {}

local function charge(inst)
	inst:AddTag("ball_lightning_charged")
end

local function uncharge(inst)
	inst:RemoveTag("ball_lightning_charged")
end	

local function FindMagnet(inst)
	local magnetholder = GetPlayer().components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if magnetholder and magnetholder:HasTag("ball_lightning") then	
		inst.components.follower:SetLeader(GetPlayer())
	else 
		inst.components.follower:SetLeader() 
	end	
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)

	local sound = inst.entity:AddSoundEmitter()	
    inst.soundtype = ""	

	inst:AddTag("ball_lightning")

	inst.AnimState:SetBank("ball_lightning")
	inst.AnimState:SetBuild("ball_lightning")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	--inst:DoPeriodicTask(4, function() 
		inst.AnimState:PlayAnimation("idle", true) 
	--end)
	inst:DoPeriodicTask(.5, function()
		local lighting = SpawnPrefab("lightning_rod_fx")
		lighting.Transform:SetScale(.8,.3,.3)
		lighting.AnimState:SetMultColour(150,150,0,.1)
		lighting.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:DoTaskInTime(0.2, function(inst)
			lighting:Remove()
		end)
		local roll = math.random(1,3)
		if roll == 1 then
			inst.AnimState:SetMultColour(250,250,0,0)
		elseif roll == 2 then	
			inst.AnimState:SetMultColour(150,150,0,0)
		elseif roll == 3 then
			inst.AnimState:SetMultColour(60,60,0,0)
		end	
		FindMagnet(inst)
	end)
	inst.Transform:SetScale(1.5,1.5,1.5)

	inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = cfg:GetConfig("WALKSPEED")
	inst.components.locomotor.directdrive = cfg:GetConfig("RUNSPEED")

	local brain = require "brains/lightningballbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGlightningball")

	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetOnChargeFn(charge)
	inst.components.staticchargeable:SetOnUnchargeFn(uncharge)
	inst.components.staticchargeable:SetOnChargeDelay(cfg:GetConfig("CHARGE_DELAY"))
	inst.components.staticchargeable:SetOnUnchargeDelay(cfg:GetConfig("UNCHARGE_DELAY"))

	inst:AddComponent("follower")
	inst:AddComponent("knownlocations")

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 80
	inst.components.temperature.mintemp = 80
	inst.components.temperature.current = 80
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED  

	inst:AddComponent("heater")	  
	inst.components.heater.heat = 80

	return inst
end

return Prefab ("common/inventory/ball_lightning", fn, assets) 
