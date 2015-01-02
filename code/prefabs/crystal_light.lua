BindGlobal()

local assets =
{
    Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
    "crystal_fragment_light",
}

local loot = 
{
   "crystal_fragment_light",
   "crystal_fragment_light",
   "crystal_fragment_light",
}

local function workcallback(inst, worker, workleft)
    if workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        --inst.components.lootdropper:DropLoot()
        inst:Remove()
    else            
        if workleft <= TUNING.SPILAGMITE_ROCK * 0.5 then
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
    light:SetFalloff(0.5)
    light:SetIntensity(.8)
    light:SetRadius(1.5)
    light:SetColour(237/255, 237/255, 209/255)
    light:Enable(false)

    local basescale = math.random(8,14)
    local scale = math.random(3,4)
    inst.Transform:SetScale(scale, scale, scale)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)   

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnFinishCallback(onMined)
    inst.components.workable:SetOnWorkCallback(workcallback)

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(function() light:Enable(true) end)
    inst.components.staticchargeable:SetOnUnchargeFn(function() light:Enable(false) end)

    return inst
end

return Prefab ("common/inventory/crystal_light", fn, assets, prefabs) 
