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

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_fruit.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 15
    inst.components.edible.sanityvalue = 5

	return inst
end

return Prefab ("common/inventory/cloud_fruit", fn, assets) 
