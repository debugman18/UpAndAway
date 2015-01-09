BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal_black.zip"),
}

local prefabs = CFG.CRYSTAL.PREFABS

SetSharedLootTable("crystal_black", CFG.CRYSTAL_BLACK.LOOT)

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
    inst.Transform:SetScale(CFG.CRYSTAL_BLACK.SCALE, CFG.CRYSTAL_BLACK.SCALE, CFG.CRYSTAL_BLACK.SCALE)
    inst:AddTag("crystal")
    inst:AddTag("owl_crystal")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("crystal_black") 	

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CRYSTAL.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onMined)
    inst.components.workable:SetOnWorkCallback(onhit)	 

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = CFG.CRYSTAL_BLACK.CHILD
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(CFG.CRYSTAL_BLACK.REGEN_PERIOD)
    inst.components.childspawner:SetSpawnPeriod(CFG.CRYSTAL_BLACK.SPAWN_PERIOD)
    inst.components.childspawner:SetMaxChildren(CFG.CRYSTAL_BLACK.MAX_CHILDREN)     

    return inst
end

return Prefab ("common/inventory/crystal_black", fn, assets, prefabs) 
