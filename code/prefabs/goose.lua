BindGlobal()

local Pred = wickerrequire "lib.predicates"

local CFG = TheMod:GetConfig()


local assets=
{
    Asset("ANIM", "anim/goose.zip"),

    Asset("ANIM", "anim/perd_basic.zip"),
    Asset("SOUND", "sound/perd.fsb"),
}

local prefabs = CFG.GOOSE.PREFABS

SetSharedLootTable("goose", CFG.GOOSE.LOOT)

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
                    local egg = SpawnPrefab(CFG.GOOSE.EGG)
                    egg.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    --TheMod:DebugSay("[", inst, "] laid [", egg, "]!")
                    lastlay = GetTime()
                else
                    --TheMod:DebugSay("No egg laid this time.")	
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
    inst.Transform:SetScale(CFG.GOOSE.SCALEX, CFG.GOOSE.SCALEY, CFG.GOOSE.SCALEZ)
    
    MakeCharacterPhysics(inst, 50, .5)    
     
    anim:SetBank("perd")
    anim:SetBuild("goose")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = CFG.GOOSE.RUNSPEED
    inst.components.locomotor.walkspeed = CFG.GOOSE.WALKSPEED
    
    inst:SetStateGraph("SGgoose")

    inst:AddTag("character")
    inst:AddTag("cloudneutral")

    local brain = require "brains/goosebrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
   
       -- Goose don't need no sleep.
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(CFG.GOOSE.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.GOOSE.ATTACK_PERIOD)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.GOOSE.HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("goose")
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")
    
    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(NewEggDropper(CFG.GOOSE.LAY_PERIOD, CFG.GOOSE.LAY_DELAY))

    return inst
end

return Prefab("forest/animals/goose", fn, assets, prefabs) 
