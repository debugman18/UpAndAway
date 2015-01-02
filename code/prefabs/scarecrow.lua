BindGlobal()

local assets =
{
    Asset("ANIM", "anim/scarecrow.zip"),
}

local prefabs =
{
--	"cheshire",
    "cutgrass",
    "twigs",
    "log",
}

local loot = {
    "cutgrass",
    "cutgrass",
    "cutgrass",
    "twigs",
    "twigs",
    "log",
    "log",
}

local function OnSpawn(inst)
    local bird = SpawnPrefab("bird_paradise")
end

local function onFinish(inst)
    inst.components.lootdropper:DropLoot(loot)
end

local function onWork(inst)

end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("scarecrow")
    inst.AnimState:SetBuild("scarecrow")
    inst.AnimState:PlayAnimation("anim", true)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "cheshire"
    inst.components.childspawner:SetSpawnedFn(OnSpawn)
    --inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*20)
    inst.components.childspawner:SetSpawnPeriod(60)
    inst.components.childspawner:SetMaxChildren(1)
    --inst.components.childspawner:StartSpawning

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnFinishCallback(onFinish)
    inst.components.workable:SetOnWorkCallback(onWork)	

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("scarecrow.tex")	

    return inst
end

return Prefab ("common/inventory/scarecrow", fn, assets, prefabs) 
