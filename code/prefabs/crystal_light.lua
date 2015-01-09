BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal.zip"),
}

local prefabs = CFG.CRYSTAL.PREFABS

SetSharedLootTable("crystal_light", CFG.CRYSTAL_LIGHT.LOOT)

local function workcallback(inst, worker, workleft)
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        inst:Remove()
    else            
        if workleft <= CFG.CRYSTAL.WORK_TIME * 0.5 then
            inst.AnimState:PlayAnimation("idle_low")
        else
            inst.AnimState:PlayAnimation("idle_med")
        end
    end
end

local function onMined(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

    inst:Remove()   
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("crystal_light.png")

    anim:SetBank("crystal_light")
    anim:SetBuild("crystal")
    anim:PlayAnimation("idle_full")
 
    inst:AddTag("crystal")
    inst:AddTag("owl_crystal")
  
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, 1)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    

    inst:AddComponent("inspectable")

    local light = inst.entity:AddLight()
    light:SetFalloff(CFG.CRYSTAL_LIGHT.FALLOFF)
    light:SetIntensity(CFG.CRYSTAL_LIGHT.INTENSITY)
    light:SetRadius(CFG.CRYSTAL_LIGHT.RADIUS)
    light:SetColour(237/255, 237/255, 209/255)
    light:Enable(false)    

    inst.Transform:SetScale(CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE())

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("crystal_light")   

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CRYSTAL.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onMined)
    inst.components.workable:SetOnWorkCallback(workcallback)

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(function() light:Enable(true) end)
    inst.components.staticchargeable:SetOnUnchargeFn(function() light:Enable(false) end)

    return inst
end

return Prefab ("common/inventory/crystal_light", fn, assets, prefabs) 
