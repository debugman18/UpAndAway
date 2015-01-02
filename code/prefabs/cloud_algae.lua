BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloud_algae.zip"),
}

local prefabs = CFG.CLOUD_ALGAE.PREFABS

local loot = CFG.CLOUD_ALGAE.LOOT

local function OnDug(inst)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end	

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_algae.tex")
        
    anim:SetBank("cloud_algae")
    anim:SetBuild("cloud_algae")
    anim:PlayAnimation("idle", true)
    inst.Transform:SetScale(CFG.CLOUD_ALGAE.SCALE, CFG.CLOUD_ALGAE.SCALE, CFG.CLOUD_ALGAE.SCALE)

    MakeObstaclePhysics(inst, .8)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

       inst:AddComponent("lootdropper") 
       inst.components.lootdropper:SetLoot(loot) 

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(CFG.CLOUD_ALGAE.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(OnDug) 

    return inst
end

return Prefab ("common/inventory/cloud_algae", fn, assets) 
