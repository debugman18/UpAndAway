--[[
-- The bean hate logic is now handled by the BeanHated component.
--]]

BindGlobal()

local BeanletCombat = pkgrequire "common.beanlet_combat"

local assets =
{
    Asset("ANIM", "anim/beanlet_zealot.zip"),  -- same name as the .scml
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

    inst.Transform:SetScale(1.4, 1.4, 1.4)

    MakeCharacterPhysics(inst, 50, .5)  

    inst.AnimState:SetBank("beanlet_zealot") -- name of the animation root
    inst.AnimState:SetBuild("beanlet_zealot")  -- name of the file
    inst.AnimState:PlayAnimation("idle", true) -- name of the animation

    inst:AddTag("animal")
    inst:AddTag("smallcreature")
    inst:AddTag("beanlet")
    inst:AddTag("zealot")

    inst:AddComponent("knownlocations")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 5

    inst.data = {}  

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(35)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_GUARD_ATTACK_PERIOD)
    inst.components.combat:SetOnHit(OnHit)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(150)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('beanlet')

    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", BeanletCombat.OnBeanletAttacked) 
    inst.components.combat:SetRetargetFunction(2, RetargetFn)  

    inst:SetStateGraph("SGbeanlet")

    local brain = require "brains/beanletzealotbrain"
    inst:SetBrain(brain)

    return inst
end

return Prefab("common/beanlet_zealot", fn, assets, prefabs) 
