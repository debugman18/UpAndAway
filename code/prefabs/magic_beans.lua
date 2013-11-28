BindGlobal()

local assets =
{
	Asset("ANIM", "anim/magic_beans.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/magic_beans.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans.tex" ),

	Asset( "ATLAS", "images/inventoryimages/magic_beans_cooked.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans_cooked.tex" ),	
}

local prefabs =
{
	"magic_beans_cooked",
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
	local tree = SpawnPrefab("beanstalk") 
	if tree then 
		tree.Transform:SetPosition(pt.x, pt.y, pt.z)
		inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge") 
		inst.AnimState:PlayAnimation("emerge")		
        inst.AnimState:PushAnimation("idle", "loop")		
		inst.components.stackable:Get():Remove()
		GetPlayer().AnimState:PlayAnimation("wakeup")
	end 
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
}
