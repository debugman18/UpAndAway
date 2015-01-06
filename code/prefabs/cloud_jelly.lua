BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloud_jelly.zip"),

    Asset( "ATLAS", inventoryimage_atlas("cloud_jelly") ),
    Asset( "IMAGE", inventoryimage_texture("cloud_jelly") ),
}

local function FuelTaken(inst, taker)
    local cloud = SpawnPrefab(CFG.CLOUD_JELLY.FUEL_CLOUD)
    if cloud then
        cloud.AnimState:SetMultColour(130,10,10,.5)
        cloud.Transform:SetPosition(taker.Transform:GetWorldPosition() )
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("cloud_jelly")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CLOUD_JELLY.STACK_SIZE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CLOUD_JELLY.FOODTYPE
    inst.components.edible.healthvalue = CFG.CLOUD_JELLY.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.CLOUD_JELLY.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CLOUD_JELLY.SANITY_VALUE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.CLOUD_JELLY.PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.CLOUD_JELLY.PERISH_ITEM    

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.CLOUD_JELLY.FUEL_VALUE
    inst.components.fuel:SetOnTakenFn(FuelTaken)

    inst:AddTag("alchemy")

    inst:AddTag("jelly")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_jelly")

    return inst
end

return Prefab ("common/inventory/cloud_jelly", fn, assets) 
