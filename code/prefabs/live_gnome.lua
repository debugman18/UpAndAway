BindGlobal()

local assets =
{
    Asset("ANIM", "anim/livegnome.zip"),   
    Asset("ANIM", "anim/trinkets.zip"), 

    Asset( "ATLAS", "images/inventoryimages/live_gnome.xml" ),
    Asset( "IMAGE", "images/inventoryimages/live_gnome.tex" ),  
}

local prefabs =
{
}

local loot = 
{
}

local function RemoveBeard(inst)
    inst:Remove()
end

local function SetBeard(inst)
    if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local beard = CreateEntity()
        beard.entity:AddTransform()
        beard:AddComponent("weapon")
        beard:AddTag("sharp")
        beard.components.weapon:SetDamage(inst.components.combat.defaultdamage)
        beard.components.weapon:SetRange(inst.components.combat.attackrange)
        beard.components.weapon:SetProjectile("blowdart_walrus")
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
    local health = inst.components.health:GetPercent()
    print(health)
    if health <= 0.5 then
        inst.components.health:SetInvincible(true)
        print(1)
        MakeInventoryPhysics(inst)
        print(2)
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/live_gnome.xml"
        inst.components.inventoryitem:SetOnPickupFn(onpickup)
        print(3)
        inst.AnimState:SetBank("trinkets")
        inst.AnimState:SetBuild("trinkets")
        inst.Transform:SetScale(1.2, 1.2, 1.2)
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
    inst.components.locomotor.runspeed = 1
    inst.components.locomotor.walkspeed = 3

    local brain = require "brains/livegnomebrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGlivegnome")

    inst:AddTag("gnome")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "rubber"

    inst.Transform:SetScale(3.8, 3.8, 3.8)

	inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetAttackPeriod(3)   
    inst.components.combat:SetRange(TUNING.WALRUS_ATTACK_DIST) 

    inst:AddComponent("inventory")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    inst:ListenForEvent("attacked", DropToy)

    --inst:DoPeriodicTask(0, function(inst) inst.AnimState:PlayAnimation("idle") end)

    inst:DoTaskInTime(1, SetBeard)

	return inst
end

return Prefab ("common/inventory/live_gnome", fn, assets, prefabs) 
--As opposed to a dead gnome.
