BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    --Asset("ANIM", "anim/winston_tool.zip"),

    --Asset( "ATLAS", inventoryimage_atlas("winston_tool") ),
    --Asset( "IMAGE", inventoryimage_texture("winston_tool") ),	
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    --inst.AnimState:SetBank("winston_tool")
    --inst.AnimState:SetBuild("winston_tool")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    --inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.atlasname = inventoryimage_atlas("winston_tool")

    return inst
end

return Prefab ("common/inventory/winston_tool", fn, assets) 
