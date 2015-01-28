BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/livegnome.zip"),   
    Asset("ANIM", "anim/trinkets.zip"), 

    Asset( "ATLAS", inventoryimage_atlas("live_gnome") ),
    Asset( "IMAGE", inventoryimage_texture("live_gnome") ),  
}

local prefabs = CFG.LIVE_GNOME.PREFABS

local loot = CFG.LIVE_GNOME.LOOT
   
-- The gnome becomes an item on 'death'.
local function toy_fn(inst)

    -- The player has been bad to gnomes.
    TheWorld.components.reputation:LowerReputation("gnomes", 8, true)

    -- The player has been good to owls.
    TheWorld.components.reputation:IncreaseReputation("strix", 4, false)

    local health = inst.components.health:GetPercent()

    if health and heath <= 0.1 then
        inst.components.health:SetInvincible(true)

        -- Now it can be picked up.
        MakeInventoryPhysics(inst)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = inventoryimage_atlas("live_gnome")
        inst.components.inventoryitem:SetOnPickupFn(function() --[[dummy]] end)

        -- For now, it's a regular gnome toy.
        inst.AnimState:SetBank("trinkets")
        inst.AnimState:SetBuild("trinkets")
        inst.Transform:SetScale(CFG.LIVE_GNOME.ITEM_SCALE, CFG.LIVE_GNOME.ITEM_SCALE, CFG.LIVE_GNOME.ITEM_SCALE)

        -- Stop nearly everything.
        --inst:RemoveComponent("combat")
        inst:ClearStateGraph()
        inst:StopBrain()
        inst.Physics:Stop()

        -- Do this after the stategraph is cleared.
        inst.AnimState:PlayAnimation("4")
    end   
end    

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("livegnome")
    inst.AnimState:SetBuild("livegnome")
    inst.AnimState:PlayAnimation("idle_loop")

    MakeCharacterPhysics(inst, 50, 1)
    inst:AddTag("character")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = CFG.LIVE_GNOME.RUNSPEED
    inst.components.locomotor.walkspeed = CFG.LIVE_GNOME.WALKSPEED

    local brain = require "brains/livegnomebrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGlivegnome")

    inst:AddTag("gnome")

    inst:AddComponent("cookable")
    inst.components.cookable.product = CFG.LIVE_GNOME.COOKED_PRODUCT

    inst.Transform:SetScale(3.8, 3.8, 3.8)

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(CFG.LIVE_GNOME.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.ATTACK_PERIOD)   
    inst.components.combat:SetRange(CFG.LIVE_GNOME.RANGE) 

    inst:AddComponent("inventory")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.LIVE_GNOME.HEALTH)

    inst:ListenForEvent("attacked", toy_fn)

    return inst
end

return Prefab ("common/inventory/live_gnome", fn, assets, prefabs) 
--As opposed to a dead gnome.
