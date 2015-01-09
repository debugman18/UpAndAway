BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal.zip"),
}

local prefabs = CFG.CRYSTAL.PREFABS

SetSharedLootTable("crystal_quartz", CFG.CRYSTAL_QUARTZ.LOOT)

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
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("crystal_quartz")
    inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("idle_full")
    MakeObstaclePhysics(inst, 1)
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)
    inst:AddTag("crystal")
    inst:AddTag("gnome_crystal")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("crystal_quartz")

    inst.Transform:SetScale(CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE(), CFG.CRYSTAL.SCALE())

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CRYSTAL.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onMined)
    inst.components.workable:SetOnWorkCallback(workcallback)  

    return inst
end

return Prefab ("common/inventory/crystal_quartz", fn, assets, prefabs) 
