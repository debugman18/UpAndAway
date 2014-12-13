--[[
-- The bean hate logic is now handled by the BeanHated component.
--]]

BindGlobal()

local BeanletCombat = pkgrequire "common.beanlet_combat"

local assets =
{
	Asset("ANIM", "anim/beanlet.zip"),  -- same name as the .scml
    Asset("SOUND", "sound/pengull.fsb"),
}

local prefabs =
{
   "greenbean",
   "beanlet_shell",
}

SetSharedLootTable( 'beanlet',
{
    {'greenbean',       1.00},
    {'greenbean',       0.90},
    {'greenbean',       0.80},
    {'greenbean',       0.70},
    {'beanlet_shell',   0.33},
})

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

    local scale = 1
    inst.Transform:SetScale(scale, scale, scale)

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
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 6

	inst.data = {}

    inst:AddComponent("combat")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(80)

    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('beanlet')

    inst:SetStateGraph("SGbeanlet")

    local brain = require "brains/beanletbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", BeanletCombat.OnBeanletAttacked)

    return inst
end

return Prefab("common/beanlet", fn, assets, prefabs) 
