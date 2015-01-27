BindGlobal()

local CFG = TheMod:GetConfig()

local brain = require "brains/beangiantbrain"

local assets =
{
    Asset("ANIM", "anim/bean_giant.zip"),
    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs = CFG.BEAN_GIANT.PREFABS

SetSharedLootTable("bean_giant", CFG.BEAN_GIANT.LOOT)

-- The function run upon static charge.
local function pod_chargefn(inst)

    -- Heal the bean giant by a percent of its health every minute that static is active.
    if inst then
        inst.component.health:StartRegen((CFG.BEAN_GIANT.HEALTH * CFG.BEAN_GIANT.HEAL_PERCENT), CFG.BEAN_GIANT.HEAL_PERIOD)
    end
end

-- The function run upon static uncharge.
local function pod_unchargefn(inst)

    -- The bean giant will stop healing when static ceases.
    if inst then
        inst.components.health:StopRegen()
    end
end

-- Run this every time the pod or bean giant grows.
local function growth_fn(inst) 
    
    -- Grow the bean pod some.
    if not inst.scale then 
        inst.scale = 1 
    end

    local upscale = (inst.scale) + (inst.scale / 4)

    inst.Transform:SetScale(upscale, upscale, upscale)
    inst.scale = upscale

    -- Shake the screen.
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/distress")
    for i, v in ipairs(AllPlayers) do
        v:ShakeCamera(CAMERASHAKE.VERTICAL, .2, .03, 2, inst, CFG.BEAN_GIANT.SHAKE_DIST)
    end    

    -- Upgrade and release all current children.
    if inst and inst.components.childspawner then
        inst.components.childspawner:SetMaxChildren(CFG.BEAN_GIANT.MAX_CHILDREN + 2)
        inst.components.childspawner:ReleaseAllChildren()
        inst.components.childspawner:AddChildrenInside(CFG.BEAN_GIANT.MAX_CHILDREN)
    end
end

-- Run this every time the pod or bean giant is attacked.
local function attacked_fn(inst)

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/hit_response")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/distress")

    if inst and inst:HasTag("pod") then
        -- Do pod shaking here.
        inst.AnimState:PushAnimation("pod_shake")
        inst.AnimState:PushAnimation("pod_idle")
    else
        -- Do giant stuff here, because it clearly isn't a pod.
    end

end

-- This will turn the pod into a functional bean giant.
local function giant_fn(inst)

    -- Remove the pod identifier.
    inst:RemoveTag("pod")

    -- Make sure we don't add the "pod" tag again later.
    inst.giant = true

    inst.AnimState:PushAnimation("pod_transform")
    inst.AnimState:PushAnimation("bean_giant_idle")

    -- We don't want the player doing too much damage during transformation.
    inst:DoTasKInTime(CFG.BEAN_GIANT.TRANSFORM_BUFFER, function()
    inst.components.health:SetInvincible(false) end)

    -- It can fight back now!
    inst:AddComponent("combat")

    -- It can walk now!
    inst.components.locomotor.walkspeed = CFG.BEAN_GIANT.WALKSPEED
    inst.components.locomotor.runspeed = CFG.BEAN_GIANT.RUNSPEED

    -- It can heal during static now!
    inst.components.staticchargeable:SetChargedFn(pod_chargefn)
    inst.components.staticchargeable:SetUnchargedFn(pod_unchargefn)  

end

local function sanityaura_fn(inst, observer)

    if inst.components.combat.target then
        return CFG.BEAN_GIANT.HOSTILE_SANITY_AURA
    else
        return CFG.BEAN_GIANT.CALM_SANITY_AURA
    end

    return 0
end

-- Load the scale and tags.
local function OnLoad(inst, data)

    if inst and data and data.scale then
        inst.scale = data.scale
        inst.Transform:SetScale(inst.scale, inst.scale, inst.scale)
    end

    if inst and data and data.giant then
        inst.giant = data.giant
    end
end

-- Load the scale and tags.
local function OnSave(inst, data)

    if inst and inst.scale then
        data.scale = inst.scale  
    end

    if inst and inst.giant then
        data.giant = inst.giant
    end
end

-- This will create the pod which will turn into the bean giant.
local function pod_fn(inst)
    
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    MakeCharacterPhysics(inst, 1000, .5)

    inst.AnimState:SetBank("bean_giant")
    inst.AnimState:SetBuild("bean_giant")
    
    inst.AnimState:PlayAnimation("pod_idle", true)

    -- This runs after entity creation and before components.
    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    -- This adds basic tags (non-local uses) efficiently.
    for i,tag in ipairs(CFG.BEAN_GIANT.TAGS) do
        inst:AddTag(tag)
    end

    -- The "pod" tag is not meant to last.
    if not inst.giant then
        inst:AddTag("pod")
    end

    -- The pod will not walk, so we'll set this to zero for now.
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 0
    inst.components.locomotor.runspeed = 0

    -- This runs after locomotor and before the brain.
    ------------------------------------------
    inst:SetStateGraph("SGbeangiant")
    ------------------------------------------

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = sanityaura_fn

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = CFG.BEAN_GIANT.CHILD
    inst.components.childspawner:SetMaxChildren(CFG.BEAN_GIANT.MAX_CHILDREN)

    -- The pod cannot be killed, so make it invincible.
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEAN_GIANT.HEALTH)
    inst.components.health:SetInvincible(true)

    inst:AddComponent("growable")
    inst.components.growable:SetOnGrowthFn(growth_fn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("bean_giant")

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")
   
    inst:AddComponent("staticchargeable")

    inst:ListenForEvent("attacked", attacked_fn)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return {
    Prefab("common/bean_giant", pod_fn, assets, prefabs),
} 
