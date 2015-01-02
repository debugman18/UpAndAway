BindGlobal()

local assets =
{
    Asset("ANIM", "anim/thunderboards.zip"),

    Asset( "ATLAS", inventoryimage_atlas("thunderboards") ),
    Asset( "IMAGE", inventoryimage_texture("thunderboards") ),	
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("boards")
    inst.AnimState:SetBuild("thunderboards")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("thunderboards")

    return inst
end

return Prefab ("common/inventory/thunderboards", fn, assets) 
