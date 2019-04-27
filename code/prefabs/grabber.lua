BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local CFG = TheMod:GetConfig()

local bonus = CFG.GRABBER.BONUS

local function onequip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_hand", "grabber", "swap_hand")
    _G.ACTIONS.PICKUP.crosseswaterboundary = true
    _G.ACTIONS.PICKUP.distance = bonus    
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    _G.ACTIONS.PICKUP.crosseswaterboundary = false
    _G.ACTIONS.PICKUP.distance = 0    
end

--This thing is made of gnome rubber, and will be used to catch skyflies, etcetera.
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

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    return inst
end

return Prefab ("common/inventory/grabber", fn, assets)
