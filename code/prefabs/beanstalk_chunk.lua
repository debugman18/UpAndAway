BindGlobal()

local assets =
{
	Asset("ANIM", "anim/beanstalk_chunk.zip"),

    Asset( "ATLAS", "images/inventoryimages/beanstalk_chunk.xml" ),
    Asset( "IMAGE", "images/inventoryimages/beanstalk_chunk.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("beanstalk_chunk")
	inst.AnimState:PlayAnimation("anim")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beanstalk_chunk.xml"

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
