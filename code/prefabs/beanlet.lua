--[[
-- The bean hate logic is now handled by the BeanHated component.
--]]

BindGlobal()

local CFG = TheMod:GetConfig()

local BeanletCombat = pkgrequire "common.beanlet_combat"

local assets =
{
    Asset("ANIM", "anim/beanlet.zip"),  -- same name as the .scml
    Asset("SOUND", "sound/rabbit.fsb"),
    Asset("SOUND", "sound/slurtle.fsb"),
}

local prefabs = CFG.BEANLET.PREFABS

SetSharedLootTable("beanlet", CFG.BEANLET.LOOT)

local function OnIgnite(inst)
    DefaultBurnFn(inst)
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
    local sound = inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()

    inst.Transform:SetScale(CFG.BEANLET.SCALE, CFG.BEANLET.SCALE, CFG.BEANLET.SCALE)

    MakeCharacterPhysics(inst, 50, .5)  

    inst.AnimState:SetBank("beanlet") -- name of the animation root
    inst.AnimState:SetBuild("beanlet")  -- name of the file
    inst.AnimState:PlayAnimation("idle", true) -- name of the animation

    inst:AddTag("animal")
    inst:AddTag("smallcreature")
    inst:AddTag("beanlet")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = CFG.BEANLET.WALKSPEED
    inst.components.locomotor.runspeed = CFG.BEANLET.RUNSPEED

    inst.data = {}

    inst:AddComponent("combat")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEANLET.HEALTH)

    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("beanlet")

    inst:SetStateGraph("SGbeanlet")

    local brain = require "brains/beanletbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", BeanletCombat.OnBeanletAttacked)

    return inst
end

return Prefab("common/beanlet", fn, assets, prefabs) 
