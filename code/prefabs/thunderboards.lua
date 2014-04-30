BindGlobal()

local assets =
{
	Asset("ANIM", "anim/thunderboards.zip"),

	Asset( "ATLAS", "images/inventoryimages/thunderboards.xml" ),
	Asset( "IMAGE", "images/inventoryimages/thunderboards.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("boards")
	inst.AnimState:SetBuild("thunderboards")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/thunderboards.xml"

	return inst
end

return Prefab ("common/inventory/thunderboards", fn, assets) 
