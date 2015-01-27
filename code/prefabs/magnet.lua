BindGlobal()

local assets =
{
    Asset("ANIM", "anim/magnet.zip"),
    Asset("ANIM", "anim/swap_magnet.zip"),
    Asset("ANIM", "anim/swap_ham_bat.zip"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_magnet", "swap_ham_bat")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    inst:AddTag("active_magnet")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    inst:RemoveTag("active_magnet")
end

local function on_charged(inst)
    inst.components.insulator.insulation = TUNING.INSULATION_SMALL
end

local function on_uncharged(inst)
    inst.components.insulator.insulation = 0
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("magnet")
    inst.AnimState:SetBuild("magnet")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(3,3,3)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargedFn(on_charged)
    inst.components.staticchargeable:SetOnUnchargedFn(on_uncharged)
    inst.components.staticchargeable:SetOnChargedDelay(math.random())
    inst.components.staticchargeable:SetOnUnchargedDelay(0.5*math.random())

    inst:AddComponent("inspectable")

    inst:AddComponent("insulator")
    inst.components.insulator.insulation = TUNING.INSULATION_SMALL

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("magnet")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip) 
    
    return inst
end

return Prefab ("common/inventory/magnet", fn, assets) 
