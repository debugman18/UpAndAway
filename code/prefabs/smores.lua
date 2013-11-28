BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	
	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "CANDY"
    inst.components.edible.healthvalue = -15
    inst.components.edible.hungervalue = 5
    inst.components.edible.sanityvalue = 20	

	return inst
end

return Prefab ("common/inventory/smores", fn, assets) 
