BindGlobal()

local CFG = TheMod:GetConfig()

-- These will mark the area around the Bean Giant Pod.

-- TODO

local assets =
{
    Asset("ANIM", "anim/beanlet_lamp.zip"),
    Asset("ANIM", "anim/lightning_rod_fx.zip"),
}

local prefabs = CFG.BEANLET_LAMP.PREFABS

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
end

local function discharge(inst)
    inst.AnimState:SetBloomEffectHandle("")
    inst.Light:Enable(false)
    if inst.zaptask then
        inst.zaptask:Cancel()
        inst.zaptask = nil
    end
end

local function dozap(inst)
    if inst.zaptask then
        inst.zaptask:Cancel()
        inst.zaptask = nil
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")

    local fx = SpawnPrefab("lightning_rod_fx")
    local pos = inst:GetPosition()
    fx.Transform:SetPosition(pos.x, pos.y, pos.z)

    inst.zaptask = inst:DoTaskInTime(math.random(10, 40), dozap)
end

local function setcharged(inst)
    dozap(inst)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.Light:Enable(true)
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState() 
 
     --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("beanlet_lamp.tex" )
    
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(CFG.BEANLET_LAMP.RADIUS)
    inst.Light:SetFalloff(CFG.BEANLET_LAMP.FALLOFF)
    inst.Light:SetIntensity(CFG.BEANLET_LAMP.INTENSITY)
    inst.Light:SetColour(235/255,121/255,12/255)

    inst.entity:AddSoundEmitter()
    inst:AddTag("structure")

    anim:SetBank("beanlet_lamp")
    anim:SetBuild("beanlet_lamp")
    anim:PlayAnimation("idle_1")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(CFG.BEANLET_LAMP.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    
    inst:AddComponent("inspectable")

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(setcharged)
    inst.components.staticchargeable:SetOnUnchargeFn(discharge)

    return inst
end

return {
    Prefab( "common/objects/beanlet_lamp", fn, assets, prefabs),
    MakePlacer("common/beanlet_lamp_placer", "beanlet_lamp", "beanlet_lamp", "idle"),
}  
