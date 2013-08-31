local assets =
{
	Asset("ANIM", "anim/magic_beans.zip"),
}

local function test_ground(inst, pt)
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
						tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
						tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
	
	if ground_OK then
	    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4)
		local min_spacing = inst.components.deployable.min_spacing or 2

	    for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v:HasTag("player") and not v.components.placer and v.parent == nil and not v:HasTag("FX") then
				if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
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

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("magic_beans")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable.test = test_ground
	inst.components.deployable.min_spacing = 2	

	return inst
end

return Prefab ("common/inventory/magic_beans", fn, assets) 
