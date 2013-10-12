local assets = 
{
	Asset("ANIM", "anim/kiki_basic.zip"),
	Asset("ANIM", "anim/kiki_build.zip"),
	Asset("ANIM", "anim/kiki_nightmare_skin.zip"),
	Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs = 
{
	"poop",
	"monkeyprojectile",
	"smallmeat",
	"cave_banana",
}

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 80
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function OnAttacked(inst, data)

	inst.components.combat:SetTarget(data.attacker)
	inst.harassplayer = false
	if inst.task then
		inst.task:Cancel()
		inst.task = nil
	end
	inst.task = inst:DoTaskInTime(math.random(55, 65), function() inst.components.combat:SetTarget(nil) end)	--Forget about target after a minute

	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, {"raccoon"})	
	for k,v in pairs(ents) do
		if v ~= inst then
			v.components.combat:SuggestTarget(data.attacker)
			v.harassplayer = false

			if v.task then
				v.task:Cancel()
				v.task = nil
			end
			v.task = v:DoTaskInTime(math.random(55, 65), function() v.components.combat:SetTarget(nil) end)	--Forget about target after a minute
		end
	end
end

local function FindTargetOfInterest(inst)

	if not inst.curious then
		return 
	end

	if not inst.harassplayer and not inst.components.combat.target then
		local m_pt = inst:GetPosition()
	    local target = GetPlayer()
		if target and target.components.inventory and distsq(m_pt, target:GetPosition()) < 10*25 then			
			local interest_chance = 0.20
			local item = target.components.inventory:FindItem(function(item) return item.components.edible end )

			if item then
				-- He has food! Maybe we should start following...
				interest_chance = 0.3 
			end
			if math.random() < interest_chance then

				inst.harassplayer = true
				inst:DoTaskInTime(120, function() inst.harassplayer = false end)
			end			
		end
	end
end

local function retargetfn(inst)
	if inst:HasTag("nightmare") then
	    local newtarget = FindEntity(inst, 20, function(guy)
	            return (guy:HasTag("character") or guy:HasTag("monster") )
	                   and inst.components.combat:CanTarget(guy)
	    end)
	    return newtarget
	end
end

local function shouldKeepTarget(inst, target)
	if inst:HasTag("nightmare") then
		return true
	end

	return true
end

local function IsInCharacterList(name)
	local characters = JoinArrays(CHARACTERLIST, MODCHARACTERLIST)

	for k,v in pairs(characters) do
		if name == v then
			return true
		end
	end
end

local function OnMonkeyDeath(inst, data)
	if data.inst:HasTag("raccoon") then	--A raccoon was killed.
		if IsInCharacterList(data.cause) then	--The player did it! Take his stuff!
			inst:DoTaskInTime(math.random(), function() 
				if inst.components.inventory then
					inst.components.inventory:DropEverything(false, true)
				end

				if inst.components.homeseeker and inst.components.homeseeker.home then
					inst.components.homeseeker.home:PushEvent("monkeydanger")
				end
			end)
		end
	end
end

local function onpickup(inst, data)
	if data.item then
		if data.item.components.equippable and
		data.item.components.equippable.equipslot == EQUIPSLOTS.HEAD and not 
		inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) then
			--Ugly special case for how the PICKUP action works.
			--Need to wait until PICKUP has called "GiveItem" before equipping item.
			inst:DoTaskInTime(0.1, function() inst.components.inventory:Equip(data.item) end)		
		end
	end
end

local function OnSave(inst, data)
	data.harassplayer = inst.harassplayer
end

local function OnLoad(inst, data)
	if data and data.harassplayer then
		inst.harassplayer = data.harassplayer
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()	
    inst.soundtype = ""
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2, 1.25 )
	
	inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 10, 0.25)
    MakeMediumBurnableCharacter(inst)

    anim:SetBank("kiki")
	anim:SetBuild("kiki_basic")
	
	anim:PlayAnimation("idle_loop", true)

	inst:AddTag("racoon")

	inst:AddComponent("inventory")

	inst:AddComponent("inspectable")

	inst:AddComponent("thief")

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = 7

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.MONKEY_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.MONKEY_MELEE_RANGE)
    inst.components.combat:SetRetargetFunction(1, retargetfn)

    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetDefaultDamage(0)	--This doesn't matter, monkey uses weapon damage

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MONKEY_HEALTH)
    
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(200,400)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(15)
    inst.components.periodicspawner:Start()

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"smallmeat", "cave_banana"})
    inst.components.lootdropper:AddChanceLoot("nightmarefuel", 0.5)
    inst.components.lootdropper.droppingchanceloot = false

	inst:AddComponent("eater")
	--inst.components.eater:SetVegetarian()
	inst.components.eater:SetOnEatFn(oneat)


	local brain = require "brains/monkeybrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGmonkey")

	inst.FindTargetOfInterestTask = inst:DoPeriodicTask(10, FindTargetOfInterest)	--Find something to be interested in!
	
	inst.HasAmmo = hasammo
	inst.curious = true

    inst:AddComponent("knownlocations")    

    inst.listenfn = function(listento, data) OnMonkeyDeath(inst, data) end

	inst:ListenForEvent("onpickup", onpickup)
    inst:ListenForEvent("attacked", OnAttacked)

    inst.harassplayer = false

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	return inst
end

return Prefab("cloudrealm/monsters/rainbowcoon", fn, assets, prefabs)