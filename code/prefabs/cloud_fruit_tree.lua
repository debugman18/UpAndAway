BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cave_banana_tree.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cave_banana_tree")
    inst.AnimState:SetBuild("cave_banana_tree")
	inst.AnimState:PlayAnimation("idle_loop", true)

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	return inst
end

return Prefab ("common/inventory/cloud_fruit_tree", fn, assets) 
