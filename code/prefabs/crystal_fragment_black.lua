BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal_fragment_black.zip"),

	Asset( "ATLAS", "images/inventoryimages/crystal_fragment_black.xml" ),
	Asset( "IMAGE", "images/inventoryimages/crystal_fragment_black.tex" ),		
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("crystal_fragment_black")
	inst.AnimState:PlayAnimation("closed")

	--inst.Transform:SetScale(.6,.6,.6)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddTag("crystal")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/crystal_fragment_black.xml"		

	return inst
end

return Prefab ("common/inventory/crystal_fragment_black", fn, assets) 
