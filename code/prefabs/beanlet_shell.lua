BindGlobal()

local assets =
{
	Asset("ANIM", "anim/beanlet_shell.zip"),

    Asset( "ATLAS", "images/inventoryimages/beanlet_shell.xml" ),
    Asset( "IMAGE", "images/inventoryimages/beanlet_shell.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("beanlet_shell")
	inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beanlet_shell.xml"

	return inst
end

return Prefab ("common/inventory/beanlet_shell", fn, assets) 
