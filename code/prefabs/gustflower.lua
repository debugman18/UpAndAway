BindGlobal()

local assets=
{
	Asset("ANIM", "anim/carrot.zip"),
}

local prefabs=
{
	"gustflower_seeds",
    "whirlwind",
}

local function onpickedfn(inst)
	--inst:Remove()
end

local function OnSpawned(inst, child)
    if GetClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 4 then
        StopSpawning(inst)
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner and GetSeasonManager() and GetSeasonManager():IsWinter() and GetWorld().components.staticgenerator.IsCharged() then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function fn(Sim)
    --Carrot you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("carrot")
    inst.AnimState:SetBuild("carrot")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("gustflower_seeds", 1)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "whirlwind"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*10)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(6)
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab( "common/inventory/gustflower", fn, assets) 
