BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
   "crystal_fragment_white",
}

local loot = 
{
   "crystal_fragment_white",
   "crystal_fragment_white",
   "crystal_fragment_white",
}

local function onMined(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("crystal")
	inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("crystal_white")
    MakeObstaclePhysics(inst, 1.)
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)
	inst:AddTag("crystal")
	inst:AddTag("gnome_crystal")

	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnFinishCallback(onMined)
	--inst.components.workable:SetOnWorkCallback(onhit)	      

	return inst
end

return Prefab ("common/inventory/crystal_white", fn, assets, prefabs) 
