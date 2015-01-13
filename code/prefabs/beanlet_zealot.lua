--[[
-- The bean hate logic is now handled by the BeanHated component.
--]]

BindGlobal()

local BeanletCombat = pkgrequire "common.beanlet_combat"

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/beanlet_zealot.zip"),  -- same name as the .scml
    Asset("SOUND", "sound/rabbit.fsb"),
    Asset("SOUND", "sound/slurtle.fsb"),
}

local prefabs = CFG.BEANLET.PREFABS

SetSharedLootTable( "beanletzealot", CFG.BEANLET_ZEALOT.LOOT)

local function RetargetFn(inst)
    return FindEntity(inst, 8, function(guy)
        return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("beanlet")
               and not guy:HasTag("beanmonster")
    end)
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
    local sound = inst.entity:AddSoundEmitter()
    --inst.Transform:SetTwoFaced()

    inst.Transform:SetScale(CFG.BEANLET_ZEALOT.SCALE, CFG.BEANLET_ZEALOT.SCALE, CFG.BEANLET_ZEALOT.SCALE)

    MakeCharacterPhysics(inst, 50, .5)  

    inst.AnimState:SetBank("beanlet_zealot") -- name of the animation root
    inst.AnimState:SetBuild("beanlet_zealot")  -- name of the file
    inst.AnimState:PlayAnimation("idle", true) -- name of the animation

    inst:AddTag("animal")
    inst:AddTag("smallcreature")
    inst:AddTag("beanlet")
    inst:AddTag("zealot")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = CFG.BEANLET_ZEALOT.WALKSPEED
    inst.components.locomotor.runspeed = CFG.BEANLET_ZEALOT.RUNSPEED

    inst.data = {}  

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(CFG.BEANLET_ZEALOT.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.BEANLET_ZEALOT.ATTACK_PERIOD)
    inst.components.combat:SetOnHit(OnHit)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEANLET_ZEALOT.HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("beanlet")

    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", BeanletCombat.OnBeanletAttacked) 
    inst.components.combat:SetRetargetFunction(2, RetargetFn)  

    inst:SetStateGraph("SGbeanlet")

    local brain = require "brains/beanletzealotbrain"
    inst:SetBrain(brain)

    return inst
end

return Prefab("common/beanlet_zealot", fn, assets, prefabs) 
