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
    
    if not inst then return end

    TheMod:DebugSay("Bean Pod growing...")

    -- Grow the bean pod some.
    if not inst.scale then 
        inst.scale = 1
    end

    local upscale = inst.scale * 1.2

    inst.Transform:SetScale(upscale, upscale, upscale)
    inst.scale = upscale

    -- Shake the screen.
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/distress")

    local player = ThePlayer
    local distToPlayer = inst:GetPosition():Dist(player:GetPosition())
    local power = Lerp(3, 1, distToPlayer/180)
    player.components.playercontroller:ShakeCamera(player, "VERTICAL", 0.5, 0.03, power, 40) 

    -- Upgrade and release all current children.
    if inst and inst.components.childspawner then
        inst.components.childspawner:SetMaxChildren(CFG.BEAN_GIANT.MAX_CHILDREN + 2)
        inst.components.childspawner:ReleaseAllChildren(ThePlayer)
        inst.components.childspawner:AddChildrenInside(CFG.BEAN_GIANT.MAX_CHILDREN)
    end
end

-- Run this every time the pod or bean giant is attacked.
local function attacked_fn(inst)

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/hit_response")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/distress")

    if inst and inst:HasTag("pod") then
        -- Do pod shaking here.
        if not inst.giant then
            inst.AnimState:PlayAnimation("pod_shake")
            inst.AnimState:PushAnimation("pod_loop")
        end
    else
        -- Do giant stuff here, because it clearly isn't a pod.
    end

end

-- This will turn the pod into a functional bean giant.
local function giant_fn(inst)

    if not inst then return end

    TheMod:DebugSay("Bean Giant transforming from Bean Pod.")

    inst.components.growable:StopGrowing()

    -- Remove the pod identifier.
    inst:RemoveTag("pod")

    -- Make sure we don't add the "pod" tag again later.
    inst.giant = true

    inst.Transform:SetScale(3,3,3)

    -- We need this anim!
    --inst.AnimState:PushAnimation("pod_transform")
    inst.AnimState:PlayAnimation("idle_loop", true)

    -- We don't want the player doing too much damage during transformation.
    inst:DoTaskInTime(CFG.BEAN_GIANT.TRANSFORM_BUFFER, function()
    inst.components.health:SetInvincible(false) end)

    -- It can walk now!
    inst.components.locomotor.walkspeed = CFG.BEAN_GIANT.WALKSPEED
    inst.components.locomotor.runspeed = CFG.BEAN_GIANT.RUNSPEED

    -- It can heal during static now!
    inst.components.staticchargeable:SetChargedFn(pod_chargefn)
    inst.components.staticchargeable:SetUnchargedFn(pod_unchargefn)  

end

local function sanityaura_fn(inst, observer)

    if inst.components.combat and inst.components.combat.target then
        return CFG.BEAN_GIANT.HOSTILE_SANITY_AURA
    else
        return CFG.BEAN_GIANT.CALM_SANITY_AURA
    end

    return 0
end

-- Tag the player.
local function OnDeath(data)
    ThePlayer:AddTag("BeanGiantSlayer")
end

-- Stages of growth.
local growth_stages =
{
    {name="BeanPod1", time = function(inst) return CFG.BEAN_GIANT.GROWTIME end, fn = function(inst) growth_fn(inst) end, growfn = function(inst) growth_fn(inst) end},
    {name="BeanPod2", time = function(inst) return CFG.BEAN_GIANT.GROWTIME end, fn = function(inst) growth_fn(inst) end, growfn = function(inst) growth_fn(inst) end},
    {name="BeanPod3", time = function(inst) return CFG.BEAN_GIANT.GROWTIME end, fn = function(inst) growth_fn(inst) end, growfn = function(inst) growth_fn(inst) end},
    {name="BeanGiant", time = function(inst) return CFG.BEAN_GIANT.GROWTIME end, fn = function(inst) giant_fn(inst) end, growfn = function(inst) giant_fn(inst) end},
}

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

    local scale = 1
    inst.Transform:SetScale(scale,scale,scale)
    inst.Transform:SetFourFaced()

    if not inst.giant then
        inst.AnimState:PlayAnimation("pod_loop", true)
    end

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
    inst.components.childspawner:SetRareChild(CFG.BEAN_GIANT.RARECHILD, CFG.BEAN_GIANT.RARECHILD_CHANCE)
    inst.components.childspawner:SetMaxChildren(CFG.BEAN_GIANT.MAX_CHILDREN)
    inst.components.childspawner:SetSpawnPeriod(CFG.BEAN_GIANT.SPAWN_PERIOD)
    inst.components.childspawner.spawnoffscreen = true

    -- The pod cannot be killed, so make it invincible.
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEAN_GIANT.HEALTH)
    inst.components.health:SetInvincible(true)

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(0)
    inst.components.growable.loopstages = false
    inst.components.growable:StartGrowing(CFG.BEAN_GIANT.GROWTIME)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("bean_giant")

    inst:AddComponent("inspectable")
    if not inst.giant then
        inst:AddComponent("named")
        inst.components.named:SetName("Giant Pod")
    end

    inst:AddComponent("knownlocations")
   
    inst:AddComponent("staticchargeable")

    inst:AddComponent("combat")

    inst:ListenForEvent("attacked", attacked_fn)

    inst:ListenForEvent("death", function(inst, data) OnDeath(data) end, inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    if not inst.giant then
        inst.components.locomotor:Stop()
    end

    return inst
end

return {
    Prefab("common/bean_giant", pod_fn, assets, prefabs),
} 
