BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
   "crystal_fragment_water",
   "flying_fish",
}

local loot = 
{
   "crystal_fragment_water",
   "flying_fish",
   "flying_fish",
}

local function onMined(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function workcallback(inst, worker, workleft)
    local pt = Point(inst.Transform:GetWorldPosition())
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        inst.components.lootdropper:DropLoot(pt)
        inst:Remove()
    else            
        if workleft <= TUNING.SPILAGMITE_ROCK * 0.5 then
            --inst.AnimState:PlayAnimation("low")
            print "Water at low."
        else
            --inst.AnimState:PlayAnimation("med")
            print "Water at med."
        end
    end
end

local function GoToBrokenState(inst)
    inst.broken = true
    
    inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
    
    if inst.components.childspawner then 
        inst.components.childspawner:StartSpawning()
    end

    inst.components.workable:SetOnWorkCallback(workcallback)
    inst.components.workable:SetWorkLeft(TUNING.SPILAGMITE_ROCK)    
end

local function MakeFishSpawner(inst)
    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(120)
    inst.components.childspawner:SetSpawnPeriod(240)
    inst.components.childspawner:SetMaxChildren(math.random(2,3))
    inst.components.childspawner:StartRegen()
    inst.components.childspawner.childname = "flying_fish"
end

local function onsave(inst, data)
    data.broken = inst.broken
end

local function onload(inst, data)
    if data then
        inst.broken = data.broken
        if inst.broken then 
            GoToBrokenState(inst)
        else
            MakeFishSpawner(inst)
        end
    else
        MakeFishSpawner(inst)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("crystal")
	inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("crystal_water")
    MakeObstaclePhysics(inst, 1.)

    inst:AddTag("crystal")

	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.SPILAGMITE_SPAWNER)
    inst.components.workable:SetOnWorkCallback(
        function(inst, worker, workleft)
            if inst.components.childspawner then
                inst.components.childspawner:ReleaseAllChildren(worker)
            end
        end)
    inst.components.workable:SetOnFinishCallback(GoToBrokenState)	

	return inst
end

return Prefab ("common/inventory/crystal_water", fn, assets, prefabs) 
