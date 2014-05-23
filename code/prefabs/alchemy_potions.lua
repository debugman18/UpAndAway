BindGlobal()

local assets =
{
	--Asset("ANIM", "anim/alchemy_potion.zip"),

	--Asset( "ATLAS", "images/inventoryimages/potion_default.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/potion_default.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("alchemy_potion")
	inst.AnimState:SetBuild("alchemy_potion")
	inst.AnimState:PlayAnimation("potion_default")

	inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

   	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 10
    
	inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_default.xml"

	return inst
end

return {
	Prefab("common/inventory/potion_default", fn, assets) 
end
