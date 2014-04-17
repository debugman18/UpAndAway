BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal_fragment_spire.zip"),

	Asset( "ATLAS", "images/inventoryimages/crystal_fragment_spire.xml" ),
	Asset( "IMAGE", "images/inventoryimages/crystal_fragment_spire.tex" ),		
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("crystal_fragment_spire")
	inst.AnimState:PlayAnimation("closed")

	inst.Transform:SetScale(.6,.6,.6)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/crystal_fragment_spire.xml"		

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "crystal"
	inst.components.repairer.value = 1	

	return inst
end

return Prefab ("common/inventory/crystal_fragment_spire", fn, assets) 
