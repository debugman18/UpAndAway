BindGlobal()

-- This is going to need a rewrite. It's currently based off of Walrus, which is silly.

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

local function RemoveBeard(inst)
    inst:Remove()
end

local function SetBeard(inst)
    if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local beard = CreateEntity()
        beard.entity:AddTransform()
        beard:AddComponent("weapon")
        beard:AddTag("sharp")
        beard.components.weapon:SetDamage(CFG.LIVE_GNOME.DAMAGE)
        beard.components.weapon:SetRange(CFG.LIVE_GNOME.RANGE)
        beard.components.weapon:SetProjectile(CFG.LIVE_GNOME.PROJECTILE)
        beard:AddComponent("inventoryitem")
        beard.persists = false
        beard.components.inventoryitem:SetOnDroppedFn(RemoveBeard)
        beard:AddComponent("equippable")
        
        inst.components.inventory:Equip(beard)
    end
end

local function onpickup(inst)
end    

local function DropToy(inst)

-- This function turns the creature into an inventory item.

    local health = inst.components.health:GetPercent()
    print(health)
    if health <= 0.5 then
        inst.components.health:SetInvincible(true)
        MakeInventoryPhysics(inst)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = inventoryimage_atlas("live_gnome")
        inst.components.inventoryitem:SetOnPickupFn(onpickup)
        inst.AnimState:SetBank("trinkets")
        inst.AnimState:SetBuild("trinkets")
        inst.Transform:SetScale(CFG.LIVE_GNOME.ITEM_SCALE, CFG.LIVE_GNOME.ITEM_SCALE, CFG.LIVE_GNOME.ITEM_SCALE)
        inst:DoPeriodicTask(0, function() inst.AnimState:PlayAnimation("4") end)
        inst:ClearStateGraph()
        inst:StopBrain()
        inst.Physics:Stop()
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

    inst:ListenForEvent("attacked", DropToy)

    --inst:DoPeriodicTask(0, function(inst) inst.AnimState:PlayAnimation("idle") end)

    inst:DoTaskInTime(1, SetBeard)

    return inst
end

-------------------------------------------------------------------------------------

-- Everything above that line is the old gnome code. It will be erased once the new code is finished.

return Prefab ("common/inventory/live_gnome", fn, assets, prefabs) 
--As opposed to a dead gnome.
