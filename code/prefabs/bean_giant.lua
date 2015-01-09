BindGlobal()

local CFG = TheMod:GetConfig()

local brain = require "brains/beangiantbrain"

local assets =
{
    Asset("ANIM", "anim/bean_giant.zip"),

    Asset("ANIM", "anim/deerclops_basic.zip"),
    Asset("ANIM", "anim/deerclops_actions.zip"),
    Asset("ANIM", "anim/deerclops_build.zip"),

    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs = CFG.BEAN_GIANT.PREFABS

SetSharedLootTable("bean_giant", CFG.BEAN_GIANT.LOOT)

local function onunchargedfn(inst)
    inst:RemoveComponent("childspawner")
end

local function onchargedfn(inst)
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = CFG.BEAN_GIANT.CHILD
    inst.components.childspawner:SetRareChild(CFG.BEAN_GIANT.RARECHILD, CFG.BEAN_GIANT.RARECHILD_CHANCE)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*CFG.BEAN_GIANT.REGEN_MODIFIER)
    inst.components.childspawner:SetSpawnPeriod(CFG.BEAN_GIANT.SPAWN_PERIOD)
    inst.components.childspawner:SetMaxChildren(CFG.BEAN_GIANT.MAX_CHILDREN)
    inst.components.childspawner:StartSpawning()
end

local function CalcSanityAura(inst, observer)
    
    if inst.components.combat.target then
        return CFG.BEAN_GIANT.HOSTILE_SANITY_AURA
    else
        return CFG.BEAN_GIANT.CALM_SANITY_AURA
    end
    
    return 0
end

local function RetargetFn(inst)
    return FindEntity(inst, CFG.BEAN_GIANT.TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
               and not guy:HasTag("beanmonster")
               and (inst.components.knownlocations:GetLocation("targetbase") == nil or guy.components.combat.target == inst)
    end)
end


local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function AfterWorking(inst, data)
    if data.target then
        local recipe = GetRecipe(data.target.prefab)
        if recipe then
            inst.structuresDestroyed = inst.structuresDestroyed + 1
            if inst.structuresDestroyed >= 2 then
                inst.components.knownlocations:ForgetLocation("targetbase")
            end
        end
    end
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function OnEntitySleep(inst)
    if inst.shouldGoAway then
        inst:Remove()
    end
    inst.structuresDestroyed = 0
end

local function OnSave(inst, data)
    data.structuresDestroyed = inst.structuresDestroyed
    data.shouldGoAway = inst.shouldGoAway
end
        
local function OnLoad(inst, data)
    if data and data.structuresDestroyed and data.shouldGoAway then
        inst.structuresDestroyed = data.structuresDestroyed
        inst.shouldGoAway = data.shouldGoAway
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = GetPseudoSeasonManager():GetSeason() ~= SEASONS.WINTER
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function oncollide(inst, other)
    if not other:HasTag("tree") then return end
    
    local v1 = Vector3(inst.Physics:GetVelocity())
    if v1:LengthSq() < 1 then return end

    inst:DoTaskInTime(2*FRAMES, function()
        if other and other.components.workable and other.components.workable.workleft > 0 then
            SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
            other.components.workable:Destroy(inst)
        end
    end)

end

local function fn(Sim)
    
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3.5 )
    inst.Transform:SetFourFaced()

    inst.Transform:SetScale(CFG.BEAN_GIANT.SCALE, CFG.BEAN_GIANT.SCALE, CFG.BEAN_GIANT.SCALE)
    
    inst.structuresDestroyed = 0
    inst.shouldGoAway = false
    
    MakeCharacterPhysics(inst, 1000, .5)
    inst.Physics:SetCollisionCallback(oncollide)


    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("deerclops")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")

    inst:AddTag("beanmonster")

    anim:SetBank("deerclops")
    anim:SetBuild("deerclops_build")
    anim:SetMultColour(0,50,0,1)

    --anim:SetBank("bean_giant")
    --anim:SetBuild("bean_giant")    

    anim:PlayAnimation("idle_loop", true)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = CFG.BEAN_GIANT.WALKSPEED 
    inst.components.locomotor.runspeed = CFG.BEAN_GIANT.RUNSPEED
    
    ------------------------------------------
    inst:SetStateGraph("SGbeangiant")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    MakeLargeBurnableCharacter(inst)

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEAN_GIANT.HEALTH)

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(CFG.BEAN_GIANT.DAMAGE)
    inst.components.combat.playerdamagepercent = CFG.BEAN_GIANT.PLAYER_DAMAGE_PERCENT
    inst.components.combat:SetRange(CFG.BEAN_GIANT.RANGE)
    inst.components.combat:SetAreaDamage(CFG.BEAN_GIANT.AREA_RANGE, CFG.BEAN_GIANT.AREA_DAMAGE)
    inst.components.combat.hiteffectsymbol = "deerclops_body"
    inst.components.combat:SetAttackPeriod(CFG.BEAN_GIANT.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    
    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("bean_giant")
    
    ------------------------------------------

    inst:AddComponent("inspectable")

    ------------------------------------------
    inst:AddComponent("knownlocations")
    inst:SetBrain(brain)
    
    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetChargedFn(onchargedfn)
    inst.components.staticchargeable:SetUnchargedFn(onunchargedfn)

    inst:ListenForEvent("working", AfterWorking)
    inst:ListenForEvent("attacked", OnAttacked)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

-------------------------------------------------------------------------------------

-- Everything above that line is the old beangiant code. It will be erased once the new code is finished.

--[[
local CFG = TheMod:GetConfig()

local brain = require "brains/beangiantbrain"

local assets =
{
    Asset("ANIM", "anim/bean_giant.zip"),

    Asset("ANIM", "anim/deerclops_basic.zip"),
    Asset("ANIM", "anim/deerclops_actions.zip"),
    Asset("ANIM", "anim/deerclops_build.zip"),

    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs = CFG.BEAN_GIANT.PREFABS

SetSharedLootTable("bean_giant", CFG.BEAN_GIANT.LOOT)

]]--

-- The function run upon world charge.
local function pod_chargefn(inst)
end

-- The function run upon world uncharge.
local function pod_unchargefn(inst)
end

-- Run this every time the pod or bean giant grows.
local function on_growth(inst) 
    -- Shake the screen and spawn children.
end

-- Run this every time the pod or bean giant is attacked.
local function attacked_fn(inst)
    if inst and inst:HasTag("pod") then
        -- Do pod shaking here.
    else
        -- Do giant stuff here, because it clearly isn't a pod.
    end
end

-- This will turn the pod into a functional bean giant.
local function giant_fn(inst)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.BEAN_GIANT.HEALTH)

    inst:AddComponent("combat")

end

--local function OnLoad(inst, data)
--end

--local function OnSave(inst, data)
--end

-- This will create the pod which will turn into the bean giant.
local function pod_fn(inst)
    
    local inst = CreateEntity()

    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()

    -- This adds basic tags (non-local uses) efficiently.
    for i,tag in ipairs(CFG.BEAN_GIANT.TAGS) do
        inst:AddTag(tag)
    end

    -- This runs after entity creation and before components.
    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    -- The pod will not walk, so we'll set this to zero for now.
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 0
    inst.components.locomotor.runspeed = 0

    -- This runs after locomotor and before the brain.
    ------------------------------------------
    inst:SetStateGraph("SGbeangiant")
    ------------------------------------------

    inst:SetBrain(brain)

    inst:AddComponent("growable")

    inst:AddComponent("childspawner")

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetChargedFn(pod_chargefn)
    inst.components.staticchargeable:SetUnchargedFn(pod_unchargefn)  

    inst:ListenForEvent("attacked", attacked_fn)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return {
    Prefab("common/bean_giant", fn, assets, prefabs),
    --Prefab("common/bean_giant", pod_fn, assets, prefabs),
} 
