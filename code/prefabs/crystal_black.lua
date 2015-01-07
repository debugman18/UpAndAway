BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal_black.zip"),
}

local prefabs =
{
   "crystal_fragment_black",
}

local loot = 
{
   "crystal_fragment_black",
   "crystal_fragment_black",
   "crystal_fragment_black",
}

local function onMined(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")
    inst.components.childspawner:ReleaseAllChildren()
    inst:Remove()	
end

local function onhit(inst, worker)
    inst.components.childspawner:ReleaseAllChildren()
    inst.AnimState:PlayAnimation("idle")
    inst.thief = worker
    inst.components.childspawner.noregen = true
    if inst.components.childspawner and worker then
        for k,v in pairs(inst.components.childspawner.childrenoutside) do
            if v.components.combat then
                v.components.combat:SuggestTarget(worker)
            end
        end
    end		
end

local function StartSpawning(inst)
    if inst.components.childspawner and GetPseudoSeasonManager() and GetPseudoSeasonManager():IsWinter() then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    if GetPseudoClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 5 and not child.components.combat.target then
        StopSpawning(inst)
    end
end

local function OnGoHome(inst, child) 
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    if inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() < 3 then
        StartSpawning(inst)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("crystal_black")
    inst.AnimState:SetBuild("crystal_black")
    inst.AnimState:PlayAnimation("idle_occupied")
    MakeObstaclePhysics(inst, 1)
    --inst.AnimState:SetMultColour(1, 1, 1, 0.86)
    inst.Transform:SetScale(2.4, 2.4, 2.4)
    inst:AddTag("crystal")
    inst:AddTag("owl_crystal")


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
    inst.components.workable:SetOnWorkCallback(onhit)	 

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "owl"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*7)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(2)     

    return inst
end

return Prefab ("common/inventory/crystal_black", fn, assets, prefabs) 
