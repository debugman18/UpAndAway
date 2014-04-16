BindGlobal()

local assets =
{
	Asset("ANIM", "anim/ambrosia.zip"),

	Asset( "ATLAS", "images/inventoryimages/ambrosia.xml" ),
	Asset( "IMAGE", "images/inventoryimages/ambrosia.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("ambrosia")
	inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ambrosia.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = math.random(-20,20)
    inst.components.edible.sanityvalue = math.random(-20,20)

	return inst
end

return Prefab ("common/inventory/ambrosia", fn, assets) 
