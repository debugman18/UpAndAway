BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset("ANIM", "anim/cloud_fruit.zip"),

	Asset( "ATLAS", inventoryimage_atlas("cloud_fruit") ),
	Asset( "IMAGE", inventoryimage_texture("cloud_fruit") ),	

	Asset( "ATLAS", inventoryimage_atlas("cloud_fruit_cooked") ),
	Asset( "IMAGE", inventoryimage_texture("cloud_fruit_cooked") ),
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
	inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_fruit")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = CFG.CLOUD_FRUIT.STACK_SIZE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CLOUD_FRUIT.FOODTYPE
    inst.components.edible.healthvalue = CFG.CLOUD_FRUIT.UNCOOKED_HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.CLOUD_FRUIT.UNCOOKED_HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CLOUD_FRUIT.UNCOOKED_SANITY_VALUE

    inst:AddComponent("cookable")
    inst.components.cookable.product = CFG.CLOUD_FRUIT.COOKED_PRODUCT   

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(CFG.CLOUD_FRUIT.UNCOOKED_PERISH_TIME)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = CFG.CLOUD_FRUIT.PERISH_ITEM

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
	inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_fruit_cooked")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = CFG.CLOUD_FRUIT.STACK_SIZE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CLOUD_FRUIT.FOODTYPE
    inst.components.edible.healthvalue = CFG.CLOUD_FRUIT.COOKED_HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.CLOUD_FRUIT.COOKED_HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CLOUD_FRUIT.COOKED_SANITY_VALUE

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(CFG.CLOUD_FRUIT.COOKED_PERISH_TIME)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = CFG.CLOUD_FRUIT.PERISH_ITEM

    return inst 
end	
return {
	Prefab ("common/inventory/cloud_fruit", fn, assets, prefabs),
	Prefab ("common/inventory/cloud_fruit_cooked", cookedfn, assets, prefabs)
}
