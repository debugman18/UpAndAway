BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local function onfinishedfn(inst)
    inst:Remove()
end

local function onequipfn(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_wind_axe", "swap_axe")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequipfn(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marble")
    inst.AnimState:SetBuild("void_placeholder")
    inst.AnimState:PlayAnimation("anim")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("wind_axe")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequipfn)
    inst.components.equippable:SetOnUnequip(onunequipfn)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    --inst.components.weapon:SetOnAttack(onattackfn)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(onfinishedfn)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)

    return inst
end

return Prefab ("common/inventory/crystal_axe", fn, assets) 
