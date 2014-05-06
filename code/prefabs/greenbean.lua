BindGlobal()

local assets =
{
	Asset("ANIM", "anim/greenbean.zip"),
	Asset("ANIM", "anim/greenbean_cooked.zip"),

    Asset( "ATLAS", "images/inventoryimages/greenbean.xml" ),
    Asset( "IMAGE", "images/inventoryimages/greenbean.tex" ),

    Asset( "ATLAS", "images/inventoryimages/greenbean_cooked.xml" ),
    Asset( "IMAGE", "images/inventoryimages/greenbean_cooked.tex" ),
}

local prefabs =
{
    "greenbean_cooked",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("greenbean")
    inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 10

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/greenbean.xml"
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 10
    inst.components.edible.hungervalue = 30
    inst.components.edible.sanityvalue = -30	

    inst:AddComponent("cookable")
    inst.components.cookable.product = "greenbean_cooked" 

	return inst
end

local function cookedfn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("greenbean_cooked")
    inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 10

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/greenbean_cooked.xml"
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 10
    inst.components.edible.sanityvalue = -40	
	return inst
end	

return {
	Prefab("common/inventory/greenbean", fn, assets, prefabs),
	Prefab("common/inventory/greenbean_cooked", cookedfn, assets),
}
