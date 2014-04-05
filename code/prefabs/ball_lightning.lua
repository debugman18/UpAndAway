BindGlobal()

local cfg = wickerrequire('adjectives.configurable')("BALL_LIGHTNING")

local prefabs =
{
	"cloud_lightning",
}

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
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
	local magnetholder = GetPlayer().components.inventory:FindItem(function(item) return item.prefab == "magnet" end )
	if magnetholder then
		print("Magnet found.")
		inst.components.follower:SetLeader(GetPlayer())
	else inst.components.follower:SetLeader() end	
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)

	local sound = inst.entity:AddSoundEmitter()	
    inst.soundtype = ""	

	inst:AddTag("ball_lightning")

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst:DoPeriodicTask(0.5, function() inst.AnimState:PlayAnimation("anim") end)

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

	inst:DoPeriodicTask(0, FindMagnet)

	inst:AddComponent("heater")	  
	inst.components.heater.heat = 80

	return inst
end

return Prefab ("common/inventory/ball_lightning", fn, assets) 
