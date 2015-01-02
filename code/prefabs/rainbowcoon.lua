BindGlobal()

local assets = 
{
    Asset("ANIM", "anim/kiki_basic.zip"),
    Asset("ANIM", "anim/kiki_build.zip"),
    Asset("ANIM", "anim/kiki_nightmare_skin.zip"),
    Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs = 
{
}

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

    anim:SetBank("kiki")
    anim:SetBuild("kiki_basic")
    
    anim:PlayAnimation("idle_loop", true)

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    MakeMediumBurnableCharacter(inst)

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
    --inst.components.combat:SetRetargetFunction(1, retargetfn)

    --inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    --inst.components.combat:SetDefaultDamage(2)	--This doesn't matter, monkey uses weapon damage

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MONKEY_HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"smallmeat", "cave_banana"})
    inst.components.lootdropper:AddChanceLoot("nightmarefuel", 0.5)
    inst.components.lootdropper.droppingchanceloot = false

    inst:AddComponent("eater")
    --inst.components.eater:SetVegetarian()
    --inst.components.eater:SetOnEatFn(oneat)


    --local brain = require "brains/monkeybrain"
    --inst:SetBrain(brain)
    --inst:SetStateGraph("SGmonkey")

    --inst.FindTargetOfInterestTask = inst:DoPeriodicTask(10, FindTargetOfInterest)	--Find something to be interested in!
    
    --inst.HasAmmo = hasammo
    inst.curious = true

    inst:AddComponent("knownlocations")    

    --inst:ListenForEvent("onpickup", onpickup)
    --inst:ListenForEvent("attacked", OnAttacked)

    inst.harassplayer = false

    --inst.OnSave = OnSave
    --inst.OnLoad = OnLoad

    return inst
end

return Prefab("cloudrealm/monsters/rainbowcoon", fn, assets, prefabs)
