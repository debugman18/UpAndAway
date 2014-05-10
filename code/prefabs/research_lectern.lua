BindGlobal()

local assets =
{
	Asset("ANIM", "anim/researchlab.zip"),
}

local function OnTurnOn(inst)  
	
end

local function OnTurnOff(inst)  
	
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("researchlab")
	inst.AnimState:SetBuild("researchlab")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetMultColour(100, 100, 100, 1)

	inst:AddComponent("inspectable")

	inst:AddTag("prototyper")

	inst:AddComponent("prototyper")        
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.RESEARCH_LECTERN
	inst.components.prototyper.onactivate = function() end  
	inst.components.prototyper.onturnoff = OnTurnOff      
	inst.components.prototyper.onturnon = OnTurnOn	
	inst.components.prototyper.on = true   	   	

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

return {
	Prefab ("common/inventory/research_lectern", fn, assets),
	MakePlacer ("common/research_lectern_placer", "researchlab", "researchlab", "idle"),
}	 
