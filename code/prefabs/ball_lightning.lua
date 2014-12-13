BindGlobal()

local cfg = Configurable("BALL_LIGHTNING")

local prefabs =
{
	"ball_lightning_fx",
}

local assets =
{
	Asset("ANIM", "anim/ball_lightning.zip"),
}

local fx_prefabs =
{
	"lightning_rod_fx",
}

local fx_assets = {
}

local loot = {}

local function charge(inst)
	inst:AddTag("ball_lightning_charged")
end

local function uncharge(inst)
	inst:RemoveTag("ball_lightning_charged")
end

local function IsAttractingPlayer(player)
	local inv = player.components.inventory
	local held_item = inv and inv:GetEquippedItem(EQUIPSLOTS.HANDS)
	return held_item and held_item:HasTag("active_magnet")
end

local ATTRACTION_RADIUS = TheMod:GetConfig("MAGNET", "ATTRACTION_RADIUS")

local function FindMagnet(inst)
	local player = Game.FindClosestPlayerInRange(inst, ATTRACTION_RADIUS, IsAttractingPlayer)
	if player then
		inst.components.follower:SetLeader(player)
	else 
		inst.components.follower:SetLeader() 
	end	
end	

local function GraphicalUpdateTick(inst)
	local roll = math.random(1,3)
	if roll == 1 then
		inst.AnimState:SetMultColour(250,250,0,0)
	elseif roll == 2 then	
		inst.AnimState:SetMultColour(150,150,0,0)
	else
		inst.AnimState:SetMultColour(60,60,0,0)
	end	
end

local function UpdateTick(inst)
	local lightning = SpawnPrefab("ball_lightning_fx")
	lightning.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	if not IsDedicated() then
		GraphicalUpdateTick(inst)
	end

	if IsHost() then
		FindMagnet(inst)
	end
end

local function StopUpdating(inst)
	if inst.updatetask then
		inst.updatetask:Cancel()
		inst.updatetask = nil
	end
end

local function StartUpdating(inst)
	StopUpdating(inst)
	inst.updatetask = inst:DoPeriodicTask(0.5, IsHost() and UpdateTick or GraphicalUpdateTick)
end

local function fn()
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
	inst.AnimState:PlayAnimation("idle", true) 

	inst.Transform:SetScale(1.5,1.5,1.5)

	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------

	StartUpdating(inst)

	inst:ListenForEvent("entitysleep", StopUpdating)
	inst:ListenForEvent("entitywake", StartUpdating)

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

	StartUpdating(inst)

	return inst
end

local function fx_fn()
	local inst = SpawnPrefab("lightning_rod_fx")

	inst.Transform:SetScale(.8,.3,.3)
	inst.AnimState:SetMultColour(150,150,0,.1)
	inst:DoTaskInTime(0.2, function(inst)
		inst:Remove()
	end)

	return inst
end

return {
	Prefab("common/inventory/ball_lightning", fn, assets, prefabs),
	Prefab("common/ball_lightning_fx", fx_fn, fx_assets, fx_prefabs),
}
