BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cumulostone.zip"),

    Asset( "ATLAS", inventoryimage_atlas("cumulostone") ),
    Asset( "IMAGE", inventoryimage_texture("cumulostone") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nitre")
    inst.AnimState:SetBuild("cumulostone")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("cumulostone")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CUMULOSTONE.STACK_SIZE

    return inst
end

return Prefab ("common/inventory/cumulostone", fn, assets) 
