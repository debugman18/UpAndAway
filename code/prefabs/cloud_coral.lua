BindGlobal()

local assets =
{
	Asset("ANIM", "anim/marble_pillar.zip"),
}

local function mine_remove(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("cloud_coral_fragment")
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("marble_pillar")
	inst.AnimState:SetBuild("marble_pillar")
	inst.AnimState:PlayAnimation("full")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_coral.tex") 	

	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetOnFinishCallback(mine_remove)
    inst.components.workable:SetWorkLeft(2)	

   	inst:AddComponent("lootdropper") 
   	--inst.components.lootdropper:SetLoot(loot)     

	return inst
end

return Prefab ("common/inventory/cloud_coral", fn, assets) 
