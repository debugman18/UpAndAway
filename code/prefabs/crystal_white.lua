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

local function workcallback(inst, worker, workleft)
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        --inst.components.lootdropper:DropLoot()
        inst:Remove()
    else            
        if workleft <= TUNING.SPILAGMITE_ROCK * 0.5 then
            inst.AnimState:PlayAnimation("idle_low")
        else
            inst.AnimState:PlayAnimation("idle_med")
        end
    end
end

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

	inst.AnimState:SetBank("crystal_white")
	inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("idle_full")
    MakeObstaclePhysics(inst, 1.)
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)
	inst:AddTag("crystal")
	inst:AddTag("gnome_crystal")

	local scale = math.random(3,4)
	inst.Transform:SetScale(scale, scale, scale)


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnFinishCallback(onMined)
	inst.components.workable:SetOnWorkCallback(workcallback)      

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("live_gnome")
    inst.components.periodicspawner:SetDensityInRange(5, 3)
    inst.components.periodicspawner:SetMinimumSpacing(5)

	return inst
end

return Prefab ("common/inventory/crystal_white", fn, assets, prefabs) 
