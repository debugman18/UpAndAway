BindGlobal()

local assets = {
	Asset("ANIM", "anim/axe.zip"),
	Asset("ANIM", "anim/wind_axe.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_wind_axe.zip"),	
}

local prefabs = {}

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

local function fn(inst)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
  
    anim:SetBank("axe")
    anim:SetBuild("wind_axe")
    anim:PlayAnimation("idle")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.AXE_USES)
    inst.components.finiteuses:SetUses(TUNING.AXE_USES)
    inst.components.finiteuses:SetOnFinished(onfinishedfn)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1)
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequipfn)
    
    inst.components.equippable:SetOnUnequip(onunequipfn)

	return inst
end

return Prefab("cloudrealm/inventory/wind_axe", fn, assets, prefabs)