BindGlobal()

local assets =
{
	Asset("ANIM", "anim/manta_leather.zip"),

    Asset( "ATLAS", "images/inventoryimages/manta_leather.xml" ),
    Asset( "IMAGE", "images/inventoryimages/manta_leather.tex" ),
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/manta_leather.xml"

	return inst
end

return Prefab ("common/inventory/manta_leather", fn, assets) 
