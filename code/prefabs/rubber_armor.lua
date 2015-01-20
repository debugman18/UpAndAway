-- TODO: Balance stats and add custom assets.

BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/beanlet_armor.zip"),

    Asset( "ATLAS", inventoryimage_atlas("beanlet_armor") ),
    Asset( "IMAGE", inventoryimage_texture("beanlet_armor") ),
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

    inst.AnimState:SetBank("armor_wood")
    inst.AnimState:SetBuild("beanlet_armor")
    inst.AnimState:PlayAnimation("anim")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.foleysound = "dontstarve/creatures/spiderqueen/givebirth_foley"
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("beanlet_armor")
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(CFG.BEANLET_ARMOR.ARMOR_HEALTH, CFG.BEANLET_ARMOR.AROMR_ABSORB)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.walkspeedmult = CFG.BEANLET_ARMOR.WALKMULTIPLIER
    
    inst:AddComponent("staticconductor")
    inst.components.staticconductor:SetResistance(20)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --This is not left to configuration, because it is tuned to look appropriate on a character.
    inst.Transform:SetScale(1.1,1.2,1.1)

    return inst
end

return Prefab( "common/inventory/rubber_armor", fn, assets) 
