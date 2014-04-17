BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function OnTurnOn(inst)  
	
end

local function OnTurnOff(inst)  
	
end

local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddTag("prototyper")
    inst:AddTag("structure")

	inst:AddComponent("prototyper")        
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.RESEARCH_LECTERN
	inst.components.prototyper.onactivate = function() end  
	inst.components.prototyper.onturnoff = OnTurnOff      
	inst.components.prototyper.onturnon = OnTurnOn	
	inst.components.prototyper.on = true   

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    --inst.components.deployable.ondeploy = ondeploy	   	

	return inst
end

return {
	Prefab ("common/inventory/research_lectern", fn, assets),
	MakePlacer ("common/research_lectern_placer", "marble", "void_placeholder", "anim"),
}	 
