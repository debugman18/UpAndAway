BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloudcrag.zip"),
}

local prefabs = CFG.CLOUD_CRAG.PREFABS

SetSharedLootTable("cloudcrag", CFG.CLOUD_CRAG.LOOT)

local function common(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
    MakeObstaclePhysics(inst, 1.)
    
    local minimap = inst.entity:AddMiniMapEntity()

    MakeSnowCovered(inst)        

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("lootdropper") 
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CLOUD_CRAG.WORK_TIME)
    
    inst.components.workable:SetOnWorkCallback(
        function(inst, worker, workleft)
            local pt = Point(inst.Transform:GetWorldPosition())
            if workleft <= 0 then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
                inst.components.lootdropper:DropLoot(pt)
                inst:Remove()
            else
                                
                if workleft < TUNING.ROCKS_MINE*(1/3) then
                    inst.AnimState:PlayAnimation("low")
                elseif workleft < TUNING.ROCKS_MINE*(2/3) then
                    inst.AnimState:PlayAnimation("med")
                else
                    inst.AnimState:PlayAnimation("full")
                end
            end
        end)         

    inst:AddComponent("inspectable")

    return inst
end

local function cloudcrag(Sim)
    local inst = common(Sim)
    inst.AnimState:SetBank("rock")
    inst.AnimState:SetBuild("cloudcrag")
    inst.AnimState:PlayAnimation("full")

    inst.components.lootdropper:SetChanceLootTable("cloudcrag")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloudcrag.tex") 

    return inst
end

return {
    Prefab("forest/objects/rocks/cloudcrag", cloudcrag, assets, prefabs),
}
