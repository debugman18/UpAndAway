BindGlobal()

local CFG = TheMod:GetConfig()

local assets = 
{
    Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
    --marble drops
    "crystal_fragment_spire",
}

local loot = 
{
   "crystal_fragment_spire",
   "crystal_fragment_spire",
   "crystal_fragment_spire",
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

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.AnimState:SetRayTestOnBB(true)

    MakeObstaclePhysics(inst, 1)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    inst.components.lootdropper:AddChanceLoot("crystal_fragment_spire", 0.33)

    inst:AddTag("crystal")

    anim:SetBank("crystal_spire")
    anim:SetBuild("crystal")
    anim:PlayAnimation("idle_full")
    inst.AnimState:SetMultColour(1, 1, 1, 0.8)

    --inst.entity:AddMiniMapEntity()
    --inst.MiniMapEntity:SetIcon( "statue_small.png" )

    local basescale = math.random(8,14)
    local scale = math.random(3,4)
    inst.Transform:SetScale(scale, scale, scale)

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnFinishCallback(onMined)
    inst.components.workable:SetOnWorkCallback(workcallback)
        
    return inst
end

return Prefab("cloudrealm/objects/crystal_spire", fn, assets, prefabs) 
