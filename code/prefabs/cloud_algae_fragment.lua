BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloud_algae_fragment.zip"),

    Asset( "ATLAS", inventoryimage_atlas("cloud_algae_fragment") ),
    Asset( "IMAGE", inventoryimage_texture("cloud_algae_fragment") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("cloud_algae_fragment")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CLOUD_ALGAE_FRAGMENT.STACK_SIZE

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.CLOUD_ALGAE_FRAGMENT.FUEL_VALUE

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_algae_fragment")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CLOUD_ALGAE_FRAGMENT.FOODTYPE
    inst.components.edible.hungervalue = CFG.CLOUD_ALGAE_FRAGMENT.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CLOUD_ALGAE_FRAGMENT.SANITY_VALUE
    inst.components.edible.healthvalue = CFG.CLOUD_ALGAE_FRAGMENT.HEALTH_VALUE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.CLOUD_ALGAE_FRAGMENT.PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.CLOUD_ALGAE_FRAGMENT.PERISH_ITEM

    inst:AddTag("algae")

    inst:AddComponent("tradable")

    return inst
end

return Prefab ("common/inventory/cloud_algae_fragment", fn, assets) 
