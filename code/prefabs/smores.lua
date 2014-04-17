BindGlobal()

local assets =
{
	Asset("ANIM", "anim/smores.zip"),

    Asset( "ATLAS", "images/inventoryimages/smores.xml" ),
    Asset( "IMAGE", "images/inventoryimages/smores.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("smores")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/smores.xml"
	
	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -20
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = 20	

	return inst
end

return Prefab ("common/inventory/smores", fn, assets) 
