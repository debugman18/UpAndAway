local cfg = wickerrequire("adjectives.configurable")("SHOPKEEPER_SPAWNER")

local assets = {}

local prefabs = {
    "shopkeeper",
    "lightning",
    "maxwell_smoke",
}

local function spawn_prefab_at(inst, prefab)
    local dude = SpawnPrefab(prefab)
    if dude then
        dude.Transform:SetPosition(inst.Transform:GetWorldPosition())
        return dude
    end
end

local function do_remove(inst)
    if not inst:IsValid() then return end

    TheMod:DebugSay("Removed [", inst, "].")

    inst:Remove()
end

local function deschedule_removal(inst)
    if inst.despawntask then
        inst.despawntask:Cancel()
        inst.despawntask = nil

        TheMod:DebugSay("Cancelled removal of [", inst, "].")
    end
    inst.despawntime = nil
end

local function schedule_removal(inst, delay)
    if not inst:IsValid() then return end

    delay = delay or cfg:GetConfig("REMOVE_DELAY")

    if inst.despawntime then
        if inst.despawntime <= GetTime() + delay then
            return
        else
            deschedule_removal(inst)
        end
    end

    TheMod:DebugSay("Removing [", inst, "] in ", delay, " seconds.")

    inst.despawntime = GetTime() + delay
    inst.despawntask = inst:DoTaskInTime(delay, do_remove)
end

local function do_spawn_shopkeeper(inst)
    if not inst:IsValid() then return end

    spawn_prefab_at(inst, "lightning")
    spawn_prefab_at(inst, "maxwell_smoke")

    local keeper = spawn_prefab_at(inst, "shopkeeper")
    if keeper then
        TheMod:DebugSay("[", keeper, "] spawned at ", keeper:GetPosition(), ".")
        TheMod:DebugSay("Removed [", inst, "].")
        inst:Remove()
    end
end

local function OnSave(inst, data)
    if inst.despawntime then
        data.despawn_delay = math.max(0, inst.despawntime - GetTime())
    end
end

local function OnLoad(inst, data)
    if data and data.despawn_delay then
        schedule_removal(inst, data.despawn_delay)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst:AddTag("shopkeeper_spawner")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("playerprox")
    do
        local playerprox = inst.components.playerprox
        local maxdist = cfg:GetConfig("MAX_DIST")

        playerprox:SetDist(maxdist, maxdist)
        playerprox:SetOnPlayerNear(do_spawn_shopkeeper)
    end

    inst:ListenForEvent("rainstop", function()
        schedule_removal(inst)
    end, GetWorld())

    inst:ListenForEvent("rainstart", function()
        deschedule_removal(inst)
    end, GetWorld())

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab( "common/shopkeeper_spawner", fn, assets, prefabs )
