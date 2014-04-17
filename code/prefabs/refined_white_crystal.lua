BindGlobal()

local assets =
{
	Asset("ANIM", "anim/refined_white_crystal.zip"),

	Asset( "ATLAS", "images/inventoryimages/refined_white_crystal.xml" ),
	Asset( "IMAGE", "images/inventoryimages/refined_white_crystal.tex" ),		
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("refined_white_crystal")
	inst.AnimState:PlayAnimation("closed")

	inst.Transform:SetScale(1.2,1.2,1.2)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/refined_white_crystal.xml"		

	return inst
end

return Prefab ("common/inventory/refined_white_crystal", fn, assets) 
