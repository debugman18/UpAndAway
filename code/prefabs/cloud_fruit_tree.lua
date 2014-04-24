BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_fruit_tree.zip"),
}

local prefabs = {
	"cloud_fruit",
}

local function onpickedfn(inst)
	inst.components.pickable.cycles_left = 2
	inst.AnimState:Hide("BANANA") 
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("cave_banana_tree")
    inst.AnimState:SetBuild("cloud_fruit_tree")
	inst.AnimState:PlayAnimation("idle_loop", true)

	inst:AddComponent("inspectable")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_fruit_tree.tex") 

    inst:AddComponent("pickable")
	inst.components.pickable:SetUp("cloud_fruit", 40)	
	inst.components.pickable.onpickedfn = onpickedfn    

	return inst
end

return Prefab ("common/inventory/cloud_fruit_tree", fn, assets, prefabs) 
