BindGlobal()

local Configurable = wickerrequire "adjectives.configurable"
local config = Configurable "BEVERAGE"

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/dragonblood_sap.zip"),

    Asset( "ATLAS", inventoryimage_atlas("dragonblood_sap") ),
    Asset( "IMAGE", inventoryimage_texture("dragonblood_sap") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("dragonblood_sap")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("dragonblood_sap")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.DRAGONBLOOD_SAP.STACK_SIZE

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = CFG.DRAGONBLOOD_SAP.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.DRAGONBLOOD_SAP.HUNGER_VALUEs
    inst.components.edible.sanityvalue = CFG.DRAGONBLOOD_SAP.SANITY_VALUE

    inst:AddComponent("temperature")
    do
        local temperature = inst.components.temperature
        temperature.mintemp = 100
        temperature.maxtemp = 100
        temperature.inherentinsulation = config:GetConfig("INHERENT_INSULATION") or 0
    end

    inst:AddComponent("heatededible")
    do
        local heatededible = inst.components.heatededible
        heatededible:SetHeatCapacity(CFG.DRAGONBLOOD_SAP.HEAT_CAPACITY)
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.DRAGONBLOOD_SAP.PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.DRAGONBLOOD_SAP.PERISH_ITEM

    return inst
end

return Prefab ("common/inventory/dragonblood_sap", fn, assets) 
