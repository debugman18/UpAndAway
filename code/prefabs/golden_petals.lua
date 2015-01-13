BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/golden_petals.zip"),

    Asset( "ATLAS", inventoryimage_atlas("golden_petals") ),
    Asset( "IMAGE", inventoryimage_texture("golden_petals") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("golden_petals")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.GOLD_PETALS.FUEL_VALUE

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.GOLD_PETALS.STACK_SIZE
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("golden_petals")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.GOLD_PETALS.FOODTYPE
    inst.components.edible.healthvalue = CFG.GOLD_PETALS.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.GOLD_PETALS.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.GOLD_PETALS.SANITY_VALUE

    return inst
end

return Prefab ("common/inventory/golden_petals", fn, assets) 
