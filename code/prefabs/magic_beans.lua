BindGlobal()
require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/magic_beans.zip"),
	Asset("ANIM", "anim/beanstalk_sapling.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/magic_beans.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans.tex" ),

	Asset( "ATLAS", "images/inventoryimages/magic_beans_cooked.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans_cooked.tex" ),	
}

local prefabs =
{
	"magic_beans_cooked",
	"beanstalk",
	"beanstalk_sapling",
}

local function plantbeanstalk(inst, hole, doer)
	print("Beans accepted.")
	local tree = SpawnPrefab("beanstalk_sapling") 
	if tree then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end 
	inst:Remove()
end

local function common(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("magic_beans")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "magic_beans_cooked"	

	inst.components.inventoryitem.atlasname = "images/inventoryimages/magic_beans.xml"
	return inst
end

local function cooked()
    local inst = common()
    inst.AnimState:PlayAnimation("cooked")
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 100
    inst.components.edible.hungervalue = 100
    inst.components.edible.sanityvalue = -50
	inst:AddTag("cooked")	
	if not IsDLCEnabled(REIGN_OF_GIANTS) then
		inst:RemoveComponent("tradable")
	end	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/magic_beans_cooked.xml"
    return inst
end

return {
	Prefab ("common/inventory/magic_beans", common, assets, prefabs), 
	Prefab ("common/inventory/magic_beans_cooked", cooked, assets, prefabs),
	MakePlacer ("common/magic_beans_placer", "beanstalk_sapling", "beanstalk_sapling", "idle"),	
}
