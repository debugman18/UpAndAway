BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal.zip"),
}

local prefabs = CFG.CRYSTAL.PREFABS

SetSharedLootTable("crystal_water", CFG.CRYSTAL_WATER.LOOT)

local function MakeFishSpawner(inst)
    local fish = SpawnPrefab("flying_fish")
    local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,4.5,0)
    
    fish.Transform:SetPosition(pt:Get())
    local down = TheCamera:GetDownVec()
    local angle = math.atan2(down.z, down.x) + (math.random()*60-30)*DEGREES
    local sp = math.random()*4+2
    fish.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
    
    inst:DoTaskInTime(3, function()
        inst:AddTag("crystal_water_broken")
    end)
end

local function onMined(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.lootdropper:DropLoot()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

    inst:Remove()	
end

local function workcallback(inst, worker, workleft)
    local pt = Point(inst.Transform:GetWorldPosition())
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        inst.components.lootdropper:DropLoot(pt)
        inst:Remove()
    else            
        if workleft <= CFG.CRYSTAL.WORK_TIME * 0.5 then
            inst.AnimState:PlayAnimation("idle_low")
            print "Water at low."
        else
            inst.AnimState:PlayAnimation("idle_med")
            print "Water at med."
            MakeFishSpawner(inst)
        end
    end
end

local function GoToBrokenState(inst)
    inst.broken = true
    
    inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")  
end

local function onsave(inst, data)
    data.broken = inst.broken
end

local function onload(inst, data)
    if data then
        inst.broken = data.broken
        if inst.broken then 
            GoToBrokenState(inst)
        else
            MakeFishSpawner(inst)
        end
    else
        MakeFishSpawner(inst)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("crystal_water.png")

    inst.AnimState:SetBank("crystal_water")
    inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("idle_full")
    MakeObstaclePhysics(inst, 1)

    inst:AddTag("crystal")
    inst:AddTag("crystal_water")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("crystal_water")

    inst.Transform:SetScale(CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE())
    inst.AnimState:SetMultColour(1, 1, 1, 0.8)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CRYSTAL.WORK_TIME)
    inst.components.workable:SetOnWorkCallback(workcallback)
    inst.components.workable:SetOnFinishCallback(onMined)	

    return inst
end

return Prefab ("common/inventory/crystal_water", fn, assets, prefabs) 
