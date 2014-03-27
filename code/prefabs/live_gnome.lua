BindGlobal()

local assets =
{
    Asset("ANIM", "anim/trinkets.zip"),    
}

local prefabs =
{
   --"beak",
   --"feather",
}

local loot = 
{
    --"beak",
    --"feather",
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

local function DropToy(inst)
    local health = inst.components.health:GetPercent()
    print(health)
    if health <= 0.5 then
        inst.components.health:SetInvincible(true)
        print(1)
        MakeInventoryPhysics(inst)
        print(2)
        inst:AddComponent("inventoryitem")
        print(3)
    end    
end    

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("trinkets")
    inst.AnimState:SetBuild("trinkets")
    inst.AnimState:PlayAnimation("4")

    MakeCharacterPhysics(inst, 50, 1)
    inst:AddTag("character")

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 3
    inst.components.locomotor.walkspeed = 3

    local brain = require "brains/livegnomebrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGlivegnome")

    inst:AddTag("gnome")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "rubber"

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

    inst:DoPeriodicTask(0, function(inst) inst.AnimState:PlayAnimation("4") end)

    inst:DoTaskInTime(1, SetBeard)

	return inst
end

return Prefab ("common/inventory/live_gnome", fn, assets, prefabs) 
--As opposed to a dead gnome.
