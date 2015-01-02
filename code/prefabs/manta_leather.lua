BindGlobal()

local assets =
{
    Asset("ANIM", "anim/manta_leather.zip"),

    Asset( "ATLAS", inventoryimage_atlas("manta_leather") ),
    Asset( "IMAGE", inventoryimage_texture("manta_leather") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("manta_leather")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("manta_leather")

    return inst
end

return Prefab ("common/inventory/manta_leather", fn, assets) 
