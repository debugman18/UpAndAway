BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

    Asset( "ATLAS", "images/inventoryimages/greenbean.xml" ),
    Asset( "IMAGE", "images/inventoryimages/greenbean.tex" ),
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/greenbean.xml"
	
	--Is a good source of food.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 30
    inst.components.edible.hungervalue = 30
    inst.components.edible.sanityvalue = -20	

	return inst
end

return Prefab ("common/inventory/greenbean", fn, assets) 
