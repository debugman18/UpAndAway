BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloud_blob.zip"),
}

local function OnCharged(inst)
    inst.scale = CFG.CLOUD_BLOB.CHARGED_SCALE
    inst.Transform:SetScale(inst.scale,inst.scale,inst.scale)
end

local function OnMitosis(inst, data, child)

    local pt = ThePlayer:GetPosition()
    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 50, {"cloud_blob"})
    TheMod:DebugSay(#ents)
    if #ents > CFG.CLOUD_BLOB.MAX_ONSCREEN then return end

    -- Animate the split.
    inst.AnimState:PlayAnimation("split")

    -- On death, modify size of child blob.
    local scale = inst.scale
    local mod_scale = CFG.CLOUD_BLOB.MOD_SCALE

    TheMod:DebugSay("Old scale is " .. scale)

    local childscale = scale * mod_scale
    TheMod:DebugSay("New scale is " .. childscale)

    -- If the child would be too small, don't spawn it.
    if childscale < CFG.CLOUD_BLOB.SCALE_FLOOR then return end 

    local pos = Vector3(inst.Transform:GetWorldPosition())
    local distort = CFG.CLOUD_BLOB.DISTORT

    local childposx = pos.x + math.random(-distort,distort)
    local childposz = pos.z + math.random(-distort,distort)

    local child1 = child
    local child2 = child

    if child1 == nil then
        child1 = SpawnPrefab(CFG.CLOUD_BLOB.CHILD)
        child1.parent = inst
        child2 = SpawnPrefab(CFG.CLOUD_BLOB.CHILD)
        child2.parent = inst
    end

    child1.scale = childscale
    child1.Transform:SetPosition(childposx,pos.y,childposz)
    child1.Transform:SetScale(child1.scale,child1.scale,child1.scale)

    if child2 then
        child2.scale = childscale
        child2.Transform:SetPosition(childposx,pos.y,childposz)
        child2.Transform:SetScale(child2.scale,child2.scale,child2.scale)        
    end

end

local function OnLoad(inst, data)
    if data then
        inst.scale = data.scale
        inst.charged = data.charged or true
    end
end

local function OnSave(inst, data)
    if data then
        data.scale = inst.scale
    end
end

local function fn(Sim)

    local inst = CreateEntity()

    -- If these don't exist, make them because we will call them.

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst:AddComponent("childspawner")
    inst:AddComponent("lootdropper")
    inst:AddComponent("staticchargeable")
    inst:AddComponent("inventory")
    inst:AddComponent("thief")

    inst:AddTag("cloud_blob")

    -- We need to keep track of the scale of the cloud blob.
    
    local scale = CFG.CLOUD_BLOB.INIT_SCALE
    
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    if not inst.scale then
        inst.scale = scale
    end

    TheMod:DebugSay("Cloud Blob scale is " .. inst.scale)

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local anim = inst.AnimState

    anim:SetBank("cloud_blob")
    anim:SetBuild("cloud_blob")
    anim:PlayAnimation("idle", true)

    inst:DoPeriodicTask(math.random(0,20), function()
        inst:DoTaskInTime(math.random(0,2), function()
            inst.AnimState:PushAnimation("eat") 
            inst.AnimState:PushAnimation("idle")
        end)
    end)

    inst.AnimState:SetMultColour(CFG.CLOUD_BLOB.COLOR(), CFG.CLOUD_BLOB.COLOR(), CFG.CLOUD_BLOB.COLOR(), CFG.CLOUD_BLOB.ALPHA())
    
    inst.Transform:SetScale(inst.scale,inst.scale,inst.scale)

    inst.components.health.max = CFG.CLOUD_BLOB.HEALTH * inst.scale

    if inst.parent then
        inst.scale = inst.parent.scale * CFG.CLOUD_BLOB.MOD_SCALE
        TheMod:DebugSay("Parent scale is " .. inst.parent.scale)
        TheMod:DebugSay("Child scale is " .. inst.scale)
    end

    MakeCharacterPhysics(inst, 2 * inst.scale, 0.5)

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:ListenForEvent("death", function(inst) OnMitosis(inst, data) end, inst)

    inst:AddComponent("inspectable")

    inst.components.childspawner.childname = CFG.CLOUD_BLOB.CHILD
    inst.components.childspawner:SetSpawnPeriod(CFG.CLOUD_BLOB.DROP_PERIOD)
    inst.components.childspawner:SetMaxChildren(CFG.CLOUD_BLOB.MAX_CHILDREN)

    inst:DoPeriodicTask(CFG.CLOUD_BLOB.DROP_PERIOD/2, function(inst) 
        if inst.scale >= 2 then 
            inst.components.childspawner:StartSpawning() 
        else 
            inst.components.childspawner:StopSpawning() 
        end 
    end)

    inst.components.lootdropper:SetLoot(CFG.CLOUD_BLOB.LOOT)

    inst.components.staticchargeable:SetChargedFn(OnCharged)

    return inst
end

return Prefab ("common/cloud_blob", fn, assets)