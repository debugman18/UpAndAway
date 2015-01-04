BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset("ANIM", "anim/cloud_coral_fragment.zip"),

	Asset( "ATLAS", inventoryimage_atlas("cloud_coral_fragment") ),
	Asset( "IMAGE", inventoryimage_texture("cloud_coral_fragment") ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("cloud_coral_fragment")
	inst.AnimState:PlayAnimation("closed")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = CFG.CLOUD_CORAL_FRAGMENT.STACK_SIZE

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_coral_fragment")

	inst:AddTag("coral")

	inst:AddComponent("tradable")

	return inst
end

return Prefab ("common/inventory/cloud_coral_fragment", fn, assets) 
