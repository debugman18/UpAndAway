BindGlobal()

local assets =
{
    Asset("ANIM", "anim/pineapple.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pineapple")
    inst.AnimState:SetBuild("pineapple")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("pineapple")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 15
    inst.components.edible.hungervalue = 60
    inst.components.edible.sanityvalue = 15

    return inst
end

return Prefab ("common/inventory/pineapple", fn, assets) 
