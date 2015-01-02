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
    inst.components.pickable.cycles_left = 0
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner and GetPseudoSeasonManager() and GetPseudoSeasonManager():IsWinter() then
        inst.components.childspawner:StartSpawning()  
    end
end

local function OnSpawned(inst, child)
    if GetPseudoClock():IsDay() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 1 then
        StopSpawning(inst)
    end

    if math.random(1,5) == 1 then
    local seeds = SpawnPrefab("gustflower_seeds")
        local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,4.5,0)
        seeds.Transform:SetPosition(pt:Get())
        local down = TheCamera:GetDownVec()
        local angle = math.atan2(down.z, down.x) + (math.random()*60-30)*DEGREES
        local sp = math.random()*4+2
        seeds.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
    end
end

local function onunchargedfn(inst)
    inst.components.childspawner:StopSpawning()
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.entityflinger then
            child.components.entityflinger:RequestDeath()
        else
            child:Remove()
        end
    end
    inst.AnimState:PlayAnimation("idle_2")
    inst.AnimState:SetBank("gustflower")
    inst.AnimState:PlayAnimation("sway", true)
end

local function onchargedfn(inst)
    inst:DoTaskInTime(1 + math.random(), function(inst)
        inst.components.childspawner:ReleaseAllChildren() 
        StartSpawning(inst)
        inst.AnimState:SetBank("gustflower_charged")
        inst.AnimState:PlayAnimation("sway", true)       
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
    inst.AnimState:PlayAnimation("sway")
    inst.AnimState:SetRayTestOnBB(true)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
;
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("gustflower_seeds", 1, 1)
    inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = false

    local basescale = math.random(8,14)
    local scale = basescale / 10
    inst.Transform:SetScale(scale, scale, scale)

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
