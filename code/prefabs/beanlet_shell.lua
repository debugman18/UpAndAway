BindGlobal()

local assets =
{
    Asset("ANIM", "anim/beanlet_shell.zip"),

    Asset( "ATLAS", inventoryimage_atlas("beanlet_shell") ),
    Asset( "IMAGE", inventoryimage_texture("beanlet_shell") ),	
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("beanlet_shell")
    inst.AnimState:PlayAnimation("closed")
    inst.Transform:SetScale(1.2,1.2,1.2)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("beanlet_shell")

    return inst
end

return Prefab ("common/inventory/beanlet_shell", fn, assets) 
