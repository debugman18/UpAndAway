BindGlobal()

local assets=
{
	Asset("ANIM", "anim/gustflower.zip"),
}

local prefabs=
{
	"gustflower_seeds",
    "whirlwind",
}

local cfg = wickerrequire("adjectives.configurable")("GUSTFLOWER")

local function onpickedfn(inst)
	--inst:Remove()
end

local function OnSpawned(inst, child)
    if GetClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 1 then
        StopSpawning(inst)
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner and GetSeasonManager() and GetSeasonManager():IsWinter() then
        inst.components.childspawner:StartSpawning()  
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function onunchargedfn(inst)
    inst.components.childspawner:StopSpawning()
    inst.AnimState:PlayAnimation("idle_1")
end

local function onchargedfn(inst)
    inst:DoTaskInTime(0, function(inst)
        inst.components.childspawner:ReleaseAllChildren() 
        inst.components.childspawner:StartSpawning() 
        inst.AnimState:PlayAnimation("idle_2")         
    end)    
end

local function fn(Sim)
    --Carrot you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("gustflower")
    inst.AnimState:SetBuild("gustflower")
    inst.AnimState:PlayAnimation("idle_1")
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
    inst.components.childspawner:SetRegenPeriod(cfg:GetConfig("WHIRLWIND_SPAWN_PERIOD"))
    inst.components.childspawner:SetSpawnPeriod(3)
    inst.components.childspawner:SetMaxChildren(1)
    --inst.components.childspawner.spawnoffscreen = true
 
    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetChargedFn(onchargedfn)
    inst.components.staticchargeable:SetUnchargedFn(onunchargedfn)

	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload
	
    return inst
end

return Prefab( "common/inventory/gustflower", fn, assets, prefabs) 
