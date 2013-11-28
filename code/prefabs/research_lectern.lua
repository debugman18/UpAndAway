BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function OnTurnOn(inst)  
	local playervar = GLOBAL.GetPlayer()    
	if playervar then        
		playervar.components.builder.accessible_tech_trees = GLOBAL.TECH.FABLE_ONE
	end
	inst.components.prototyper.on = true
	print(playervar.components.builder.accessible_tech_trees)
end

local function OnTurnOff(inst)  
	local playervar = GLOBAL.GetPlayer()    
	if playervar then        
		playervar.components.builder.accessible_tech_trees = GLOBAL.TECH.NONE    
	end
	inst.components.prototyper.on = false
	print(playervar.components.builder.accessible_tech_trees)
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
	inst.components.prototyper.trees = GLOBAL.TUNING.PROTOTYPER_TREES.FABLE     
	inst.components.prototyper.onactivate = function() end  
	inst.components.prototyper.onturnoff = OnTurnOff      
	inst.components.prototyper.onturnon = OnTurnOn	      	

	return inst
end

return Prefab ("common/inventory/research_lectern", fn, assets) 
