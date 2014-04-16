BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_coral_fragment.zip"),

	Asset( "ATLAS", "images/inventoryimages/cloud_coral_fragment.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cloud_coral_fragment.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("cloud_coral_fragment")
	inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_coral_fragment.xml"

	inst:AddTag("coral")

	inst:AddComponent("tradable")

	return inst
end

return Prefab ("common/inventory/cloud_coral_fragment", fn, assets) 
