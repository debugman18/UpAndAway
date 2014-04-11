BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function OnTurnOn(inst)  
	
end

local function OnTurnOff(inst)  
	
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
	inst.components.prototyper.trees = FABLE_1   
	inst.components.prototyper.onactivate = function() end  
	inst.components.prototyper.onturnoff = OnTurnOff      
	inst.components.prototyper.onturnon = OnTurnOn	
	inst.components.prototyper.on = true      	

	return inst
end

return Prefab ("common/inventory/research_lectern", fn, assets) 
