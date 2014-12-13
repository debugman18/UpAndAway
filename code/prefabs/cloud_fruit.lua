BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_fruit.zip"),

	Asset( "ATLAS", "images/inventoryimages/cloud_fruit.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cloud_fruit.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("dragonfruit")
	inst.AnimState:SetBuild("cloud_fruit")
	inst.AnimState:PlayAnimation("idle")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_fruit.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 15
    inst.components.edible.sanityvalue = 5

    inst:AddComponent("cookable")
    inst.components.cookable.product = "cloud_fruit_cooked"   

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(300)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"     

	return inst
end

local function cookedfn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("dragonfruit")
	inst.AnimState:SetBuild("cloud_fruit")
	inst.AnimState:PlayAnimation("cooked")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_fruit_cooked.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -20
    inst.components.edible.hungervalue = 40
    inst.components.edible.sanityvalue = -30

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(100)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst 
end	
return {
	Prefab ("common/inventory/cloud_fruit", fn, assets, prefabs),
	Prefab ("common/inventory/cloud_fruit_cooked", cookedfn, assets, prefabs)
}
