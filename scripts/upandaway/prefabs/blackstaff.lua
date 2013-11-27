--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/staffs.zip"),
	Asset("ANIM", "anim/swap_staffs.zip"), 
}

local prefabs = 
{
    "staffcastfx",
	"stafflight",
}

local function cancharge(staff, caster, target)
    if target then
        return target.components.staticchargeable
    else return false end
end

local function black_activate(staff, caster, target)
    if target then
        target.components.staticchargeable:Charge()
        staff.components.finiteuses:Use(1)
        GetPlayer().SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")  
        print(target)
        print(target.components.staticchargeable.charged)
    end    
end

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local onequip = function(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "greenstaff")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local onunequip = function(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function fn(inst)

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("staffs")
    anim:SetBuild("staffs")
    anim:PlayAnimation("greenstaff")

    inst:AddTag("nopunch")

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(cancharge)
    inst.components.spellcaster:SetSpellFn(black_activate)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(black_activate)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(TUNING.GREENSTAFF_USES)
    inst.components.finiteuses:SetUses(TUNING.GREENSTAFF_USES)      

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
    return inst
end

return Prefab( "common/inventory/blackstaff", fn, assets, prefabs)
