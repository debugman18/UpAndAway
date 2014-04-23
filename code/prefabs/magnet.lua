BindGlobal()

local assets =
{
	Asset("ANIM", "anim/magnet.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("magnet")
	inst.AnimState:SetBuild("magnet")
	inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(3,3,3)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/magnet.xml"
	
	return inst
end

return Prefab ("common/inventory/magnet", fn, assets) 
