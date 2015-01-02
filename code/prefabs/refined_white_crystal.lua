BindGlobal()

local assets =
{
    Asset("ANIM", "anim/refined_white_crystal.zip"),

    Asset( "ATLAS", inventoryimage_atlas("refined_white_crystal") ),
    Asset( "IMAGE", inventoryimage_texture("refined_white_crystal") ),		
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("refined_white_crystal")
    inst.AnimState:PlayAnimation("closed")

    inst.Transform:SetScale(1.2,1.2,1.2)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("refined_white_crystal")		

    return inst
end

return Prefab ("common/inventory/refined_white_crystal", fn, assets) 
