BindGlobal()

local assets =
{
    Asset("ANIM", "anim/rubber.zip"),


    Asset( "ATLAS", inventoryimage_atlas("rubber") ),
    Asset( "IMAGE", inventoryimage_texture("rubber") ),
}

--This thing is made of gnome rubber, and will be used to catch skyflies, etcetera.
local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rubber")
    inst.AnimState:SetBuild("rubber")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(3,3,3)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("rubber")

    return inst
end

return Prefab ("common/inventory/rubber", fn, assets)
