BindGlobal()

local Configurable = wickerrequire "adjectives.configurable"
local cfg = Configurable "BEVERAGE"

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
    inst.components.stackable.maxsize = 20

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 5
    inst.components.edible.hungervalue = 5

    inst:AddComponent("temperature")
    do
        local temperature = inst.components.temperature
        temperature.mintemp = 100
        temperature.maxtemp = 100
        temperature.inherentinsulation = cfg:GetConfig("INHERENT_INSULATION") or 0
    end

    inst:AddComponent("heatededible")
    do
        local heatededible = inst.components.heatededible
        heatededible:SetHeatCapacity(0.15)
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

return Prefab ("common/inventory/dragonblood_sap", fn, assets) 
