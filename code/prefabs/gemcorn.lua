BindGlobal()

local assets =
{
	Asset("ANIM", "anim/pineapple.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("gemcorn")
	inst.AnimState:SetBuild("gemcorn")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/pineapple.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 15
    inst.components.edible.hungervalue = 60
    inst.components.edible.sanityvalue = 15

	return inst
end

return Prefab ("common/inventory/gemcorn", fn, assets) 
