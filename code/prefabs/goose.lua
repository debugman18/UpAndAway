BindGlobal()


local Pred = wickerrequire 'lib.predicates'

local Configurable = wickerrequire 'adjectives.configurable'


local cfg = Configurable "GOOSE"


local assets=
{
	Asset("ANIM", "anim/goose.zip"),

	Asset("ANIM", "anim/perd_basic.zip"),
	Asset("SOUND", "sound/perd.fsb"),
}

local prefabs =
{
    "drumstick",
}

local loot = 
{
    "drumstick",
    "smallmeat",
	"smallmeat",
}
 

--[[
-- Actually, the "ConditionalTasker" protocomponent I wrote (within wicker)
-- would suit this perfectly. It's meant precisely for this kind of use.
--
-- But since it's overkill atm, I'll hold off on using it.
--
-- period is the minimum span of time between lays*.
-- delay is how long after static started the egg will be laid. It can be a function.
--
-- *The actual period will be this value plus the delay.
--]]
local function NewEggDropper(period, delay)
	local lastlay = GetTime() - period

	local task = nil

	local function getdelay()
		return math.max(1, Pred.IsCallable(delay) and delay() or delay)
	end

	local function task_callback(inst)
		task = nil

		if GetStaticGenerator():IsCharged() then
			if inst:IsAsleep() then
				if math.random(1,4) == 4 then
					local egg = SpawnPrefab("golden_egg")
					egg.Transform:SetPosition(inst.Transform:GetWorldPosition())
					TheMod:DebugSay("[", inst, "] laid [", egg, "]!")
					lastlay = GetTime()
				else
					TheMod:DebugSay("No egg laid this time.")	
				end
			else
				task = inst:DoTaskInTime(getdelay(), task_callback)
			end
		end
	end

	return function(inst)
		if task then
			task:Cancel()
			task = nil
		end

		if inst:GetTimeAlive() < 5 then return end

		if GetTime() >= lastlay + period then
			task = inst:DoTaskInTime(getdelay(), task_callback)
		end
	end
end

 
local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1.3, 1.4, 1.1)
	
    MakeCharacterPhysics(inst, 50, .5)    
     
    anim:SetBank("perd")
    anim:SetBuild("goose")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor.walkspeed = 8
    
	inst:SetStateGraph("SGgoose")
    --inst:SetStateGraph("SGperd")
    --anim:Hide("hat")

    inst:AddTag("character")
	inst:AddTag("cloudneutral")

    --inst:AddComponent("homeseeker")
    local brain = require "brains/goosebrain"
	--local brain = require "brains/perdbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)    --always wake up if we're asleep

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(40)
    inst.components.combat:SetDefaultDamage(TUNING.PERD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PERD_ATTACK_PERIOD)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")
	
 	inst:AddComponent("staticchargeable")
 	inst.components.staticchargeable:SetOnChargeFn( NewEggDropper( cfg:GetConfig("LAY_PERIOD"), cfg:GetConfig("LAY_DELAY")) )

    return inst
end

return Prefab("forest/animals/goose", fn, assets, prefabs) 
