BindGlobal()

local assets =
{
	--Asset("ANIM", "anim/beanlet_hut.zip"),
}

local prefabs =
{
    "beanlet",
    "boards",
    "flowerpetals",
}

SetSharedLootTable( 'beanlet_hut',
{
    {'boards',       1.0},
    {'boards',       1.0},    
    {'flowerpetals', 1.0},
    {'flowerpetals', 1.0},
    {'flowerpetals', 0.8},
    {'flowerpetals', 0.8},        
})

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren(worker)
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function ReturnChildren(inst)
	for k,child in pairs(inst.components.childspawner.childrenoutside) do
		if child.components.homeseeker then
			child.components.homeseeker:GoHome()
		end
		child:PushEvent("gohome")
	end
end

local function OnIgniteFn(inst)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 1)

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("beanlet_hut.tex")

    --anim:SetBank("beanlet_hut")
    --anim:SetBuild("beanlet_hut")
    --anim:PlayAnimation("idle", true)

	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(100)
	inst.components.childspawner:SetSpawnPeriod(20)
	inst.components.childspawner:SetMaxChildren(math.random(3,6))
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.childname = "beanlet"
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner:SetSpawnedFn(shake)

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('beanlet_hut')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("upandaway_charge", function()
        if inst.components.childspawner then
            inst.components.childspawner:StopSpawning()
            ReturnChildren(inst) 
        end
    end)

	inst:ListenForEvent("upandaway_uncharge", function() 
        if inst.components.childspawner then
    		inst.components.childspawner:StartSpawning()
	    end		
    end)

    inst:AddComponent("inspectable")

    MakeLargeBurnable(inst)

	return inst
end

return Prefab("common/objects/beanlet_hut", fn, assets, prefabs) 
