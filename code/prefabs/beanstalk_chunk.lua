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
	inst.AnimState:SetBuild("marble")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "beanstalk"
	inst.components.repairer.healthrepairvalue = 5

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 40

	inst:AddTag("beanstalk_chunk")

	inst:AddComponent("tradable")	

	return inst
end

return Prefab ("common/inventory/beanstalk_chunk", fn, assets) 
