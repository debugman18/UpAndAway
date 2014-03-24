BindGlobal()
require "prefabutil"
local assets =
{
	Asset("ANIM", "anim/magic_beans.zip"),
	Asset("ANIM", "anim/pinecone.zip"),
	
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

local function test_ground(inst, pt)
		local tiletype = GetGroundTypeAtPosition(pt)
		local ground_OK = tiletype ~= GROUND.IMPASSABLE 

		if ground_OK then
			local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 2, nil, {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR"}) -- or we could include a flag to the search?

			for k, v in pairs(ents) do
				if not v:HasTag("mound") then 
					return false 
				end	
			end
			
			return true

		end
		return false
	
end

local function ondeploy(inst, pt)
	local tree = SpawnPrefab("beanstalk_sapling") 
	if tree then 
		tree.Transform:SetPosition(pt.x, pt.y, pt.z)
	end 
	_G.DeleteCloseEntsWithTag(inst, "mound", 2)
	inst:Remove()
	print("Mound deleted.")
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

	inst:AddComponent("inventoryitem")
	
	--[[inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable.test = test_ground
	inst.components.deployable.min_spacing = 4	
	]]
    inst:AddComponent("key")
    inst.components.key.keytype = "beans" 
	
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
	inst:RemoveComponent("deployable")	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/magic_beans_cooked.xml"
    return inst
end

return {
	Prefab ("common/inventory/magic_beans", common, assets, prefabs), 
	Prefab ("common/inventory/magic_beans_cooked", cooked, assets, prefabs),
	MakePlacer ("common/beanstalk_sapling_placer", "beanstalk_sapling", "beanstalk_sapling", "idle"),	
}
