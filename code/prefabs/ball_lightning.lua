BindGlobal()

local prefabs =
{
	"cloud_lightning",
}

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local CFG = TheMod:GetConfig()

local SLEEP_DIST_FROMHOME = 10
local SLEEP_DIST_FROMTHREAT = 0
local MAX_CHASEAWAY_DIST = 0
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function hasammo(inst)
	if inst.components.inventory then
		local thunder = inst.components.inventory:FindItem(function(item) return item.prefab == "cloud_lightning" end )
		return thunder ~= nil
	end
end

local function oneat(inst)
	print "Ate your food. Not really."
end

local function charge(inst)
	inst:AddTag("ball_lightning_charged")
end

local function uncharge(inst)
	inst:RemoveTag("ball_lightning_charged")
end	

local function FindTargetOfInterest(inst)

	if not inst.harassplayer and not inst.components.combat.target then
		local m_pt = inst:GetPosition()
	    local target = GetPlayer()
		if target and target.components.inventory and distsq(m_pt, target:GetPosition()) < 5*5 then			
			local interest_chance = 0
			local item = target.components.inventory:FindItem(function(item) return item.prefab == "magnet" end )

			if item then
				-- Follow the player because he has a magnet.
				interest_chance = 1 
			end
			if math.random() < interest_chance then

				inst.harassplayer = true
				inst:DoTaskInTime(120, function() inst.harassplayer = false end)
			end			
		end
	end
end

local function retargetfn(inst)
	if inst:HasTag("ball_lightning_charged") then
	    local newtarget = FindEntity(inst, 20, function(guy)
	            return (guy:HasTag("character") or guy:HasTag("monster") )
	                   and inst.components.combat:CanTarget(guy)
	    end)
	    return newtarget
	end
end

local function shouldKeepTarget(inst, target)
	if inst:HasTag("ball_lightning") then
		return true
	end

	return true
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
	
    local brain = require "brains/monkeybrain"
    inst:SetBrain(brain)

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.MONKEY_MOVE_SPEED
	inst.components.locomotor.directdrive = true    

	local brain = require "brains/monkeybrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGmonkey")

	inst:AddComponent("eater")
	inst.components.eater:SetOnEatFn(oneat)

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.MONKEY_ATTACK_PERIOD)
    inst.components.combat:SetRange(10)
    inst.components.combat:SetRetargetFunction(1, retargetfn)

    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetDefaultDamage(2)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    inst.HasAmmo = hasammo

    inst:AddComponent("knownlocations")  

	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetOnChargeFn(charge)
	inst.components.staticchargeable:SetOnUnchargeFn(uncharge)
	inst.components.staticchargeable:SetOnChargeDelay(CFG.SHEEP.CHARGE_DELAY)
	inst.components.staticchargeable:SetOnUnchargeDelay(CFG.SHEEP.UNCHARGE_DELAY)


	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 80
	inst.components.temperature.mintemp = 80
	inst.components.temperature.current = 80
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED  

	inst:AddComponent("heater")	  

	return inst
end

return Prefab ("common/inventory/ball_lightning", fn, assets) 
