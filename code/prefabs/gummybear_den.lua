BindGlobal()

local assets =
{
    Asset("ANIM", "anim/gummybear_den.zip"),
}

local prefabs = 
{
    "merm",
    "collapse_big",
}

local loot = 
{
    "log",
    "log",
    "goldnugget",
    "trinket_2",
}
  
local function onlightning(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    SpawnPrefab("lightning").Transform:SetPosition(inst:GetPosition():Get())
    SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst:GetPosition():Get())

    inst:DoTaskInTime(1, function()
        inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
        SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst:GetPosition():Get())
        SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())
    end)
end

local zapchance = 0.04
    
local flickerchance = 0.2
  
local function onhammered(inst, worker)
    inst:RemoveComponent("childspawner")
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren(worker)
    end
end

local function IsSpawnTime()
    local c = GetPseudoClock()
    return c and (c:IsDay() or c:CurrentPhaseIsAlways())
end

local function StartSpawning(inst)
    if inst.components.childspawner then
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
    if not IsSpawnTime() and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 1 and not child.components.combat.target then
        StopSpawning(inst)
    end
    if inst:HasTag("zapped") then
        inst:RemoveTag("zapped")
        SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
        inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("full")
        inst.AnimState:SetBloomEffectHandle("")
    end
end

local function OnGoHome(inst, child) 
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    if inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() < 1 then
        StartSpawning(inst)
    end
    inst:DoTaskInTime(1, function()
        if not inst:HasTag("zapped") then
            inst:AddTag("zapped") 
            inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
            inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
            inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
            SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())
            inst.Light:Enable(true)
            inst.AnimState:PlayAnimation("med")
        end
    end)
end

-- Called in a inst:DoPeriodicTask().
-- Disabled when the entity is asleep.
local function AttemptLightFlicker(inst)
    if inst.components.childspawner and inst.components.childspawner.childreninside > 0 then
        if math.random() < flickerchance then
            inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
            SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst:GetPosition():Get())
            inst.AnimState:PlayAnimation("med")
            inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

            inst:DoTaskInTime(0.1, function()
                inst.Light:Enable(false)
                inst.AnimState:PlayAnimation("full")
                inst.AnimState:SetBloomEffectHandle("")
            end)
            inst:DoTaskInTime(0.2, function()
                inst.Light:Enable(true)
                inst.AnimState:PlayAnimation("med")
                inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
            end)
            inst:DoTaskInTime(0.3, function()
                inst.Light:Enable(false)
                inst.AnimState:PlayAnimation("full")
                inst.AnimState:SetBloomEffectHandle("")
            end)
            inst:DoTaskInTime(0.4, function()
                inst.Light:Enable(true)
                inst.AnimState:PlayAnimation("med")
                inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
            end)
        end
    else
        inst.AnimState:PlayAnimation("full")
        inst.AnimState:SetBloomEffectHandle("")
        inst.Light:Enable(false)
    end
end

local function StartFlickerTask(inst)
    if not inst.flickertask then
        inst.flickertask = inst:DoPeriodicTask(100/100, AttemptLightFlicker)
    end
end

local function StopFlickerTask(inst)
    if inst.flickertask then
        inst.flickertask:Cancel()
        inst.flickertask = nil
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("gummybear_den.tex")
    
    MakeObstaclePhysics(inst, 2)

    inst.Transform:SetScale(1.4, 1.4, 1.4)
    inst.AnimState:SetBank("rock_stalagmite")
    inst.AnimState:SetBuild("gummybear_den")
    inst.AnimState:PlayAnimation("full")

    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,121/255,12/255)

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddTag("lightningrod")
    inst:ListenForEvent("lightningstrike", onlightning)

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "gummybear"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*0.4)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(3)

    -- Ensures clock savedata has been loaded.
    inst:DoTaskInTime(0, function(inst)
        if not GetPseudoClock():CurrentPhaseIsAlways() then
            inst:ListenForEvent("daytime", function() 
                inst.components.childspawner:ReleaseAllChildren()
                StartSpawning(inst)
            end, GetWorld())
            inst:ListenForEvent("dusktime", function() StopSpawning(inst) end , GetWorld())
        end
        if IsSpawnTime() then
            StartSpawning(inst)
        end
    end)

    StartFlickerTask(inst)
    inst:ListenForEvent("entitysleep", StopFlickerTask)
    inst:ListenForEvent("entitywake", StartFlickerTask)

    inst:AddComponent("inspectable")

    return inst
end



return Prefab( "common/objects/gummybear_den", fn, assets, prefabs)
