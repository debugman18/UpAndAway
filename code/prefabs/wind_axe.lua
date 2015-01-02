BindGlobal()

local cfg = Configurable "WIND_AXE"

local assets = {
    Asset("ANIM", "anim/axe.zip"),
    Asset("ANIM", "anim/wind_axe.zip"),
    Asset("ANIM", "anim/swap_axe.zip"),
    Asset("ANIM", "anim/swap_wind_axe.zip"),	

    Asset( "ATLAS", inventoryimage_atlas("wind_axe") ),
    Asset( "IMAGE", inventoryimage_texture("wind_axe") ),
}

local prefabs = {
    "whirlwind",
    "lightning",
}

local TARG_STRIKE_CHANCE = cfg:GetConfig "TARGET_LIGHTNING_CHANCE"
local OWNER_STRIKE_CHANCE = cfg:GetConfig "OWNER_LIGHTNING_CHANCE"
local WHIRL_CHANCE = cfg:GetConfig "WHIRLWIND_CHANCE"

local function onattackfn(inst, owner, target)
    local p = math.random()

    local target_pt = target:GetPosition()
    local owner_pt = owner:GetPosition()
    if p < TARG_STRIKE_CHANCE then
        local lightning = SpawnPrefab("lightning")
        lightning.Transform:SetPosition(target_pt.x, target_pt.y, target_pt.z)
    elseif p < TARG_STRIKE_CHANCE + OWNER_STRIKE_CHANCE then
        local lightning = SpawnPrefab("lightning")
        lightning.Transform:SetPosition(owner_pt.x, owner_pt.y, owner_pt.z)

        local damaged = false
        if IsDLCEnabled(REIGN_OF_GIANTS) and owner.components.inventory then
            local headinsulator = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            local bodyinsulator = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            local insulator = headinsulator or bodyinsulator
            if insulator and insulator.components.insulator then
                owner.components.health:DoDelta(-10)
                damaged = true
            end
        end

        if not damaged then
            owner.components.health:DoDelta(-30)
        end
    elseif p < TARG_STRIKE_CHANCE + OWNER_STRIKE_CHANCE + WHIRL_CHANCE then
        local whirlwind = SpawnPrefab("whirlwind")
        whirlwind.components.entityflinger:RequestDeathIn(15)
        whirlwind.Transform:SetPosition(target_pt.x, target_pt.y, target_pt.z)
    end
end

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

local WEAPON_USES = cfg:GetConfig "WEAPON_USES"
local TOOL_USES = cfg:GetConfig "TOOL_USES"

-- Total use consumption per use as a tool.
local TOOL_CONSUMPTION = WEAPON_USES/TOOL_USES

local function fn(inst)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
  
    anim:SetBank("axe")
    anim:SetBuild("wind_axe")
    anim:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(60)
    inst.components.weapon:SetOnAttack(onattackfn)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("wind_axe")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(WEAPON_USES)
    inst.components.finiteuses:SetUses(WEAPON_USES)
    inst.components.finiteuses:SetOnFinished(onfinishedfn)
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, TOOL_CONSUMPTION)
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequipfn)
    
    inst.components.equippable:SetOnUnequip(onunequipfn)

    return inst
end

return Prefab("cloudrealm/inventory/wind_axe", fn, assets, prefabs)
