BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cumulostone.zip"),

    Asset( "ATLAS", "images/inventoryimages/cumulostone.xml" ),
    Asset( "IMAGE", "images/inventoryimages/cumulostone.tex" ),
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cumulostone.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	return inst
end

return Prefab ("common/inventory/cumulostone", fn, assets) 
