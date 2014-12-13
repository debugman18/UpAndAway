BindGlobal()

local assets =
{
    --Asset("ANIM", "anim/arrow_indicator.zip"),
}

local prefabs = 
{
    "manta",
}

local function CanSpawn(inst)
    return true
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(20, math.random(1,16))
    inst.components.periodicspawner:SetPrefab("manta")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:Start()
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    
    return inst
end

return Prefab( "cloudrealm/mantaspawner", fn, assets, prefabs) 
