BindGlobal()

local assets=
{
	Asset("ANIM", "anim/beanlet_armor.zip"),

    Asset( "ATLAS", "images/inventoryimages/beanlet_armor.xml" ),
    Asset( "IMAGE", "images/inventoryimages/beanlet_armor.tex" ),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_metal")
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "beanlet_armor", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    --inst.AnimState:SetBank("beanlet_armor")
    inst.AnimState:SetBank("armor_wood")
    inst.AnimState:SetBuild("beanlet_armor")
    inst.AnimState:PlayAnimation("anim")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/creatures/spiderqueen/givebirth_foley"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/beanlet_armor.xml"
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(200, .5)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.walkspeedmult = 1.4
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.Transform:SetScale(1.1,1.2,1.1)

    return inst
end

return Prefab( "common/inventory/beanlet_armor", fn, assets) 
