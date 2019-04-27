BindGlobal()

local assets =
{
    Asset("ANIM", "anim/thunder_sapling.zip"),
}

local prefabs =
{
    "thunder_tree",
}

local seg_time = TUNING.DAY_SEGS_DEFAULT
local day_segs = 30
local day_time = seg_time * day_segs

TUNING.THUNDER_SAPLING_GROW_TIME =
{
    {
        base=2*day_time, 
        random=1*day_time
    },

    {
        base=2*day_time,
        random=1*day_time
    }
}

local function dig_up(inst, chopper)

    inst.components.lootdropper:SpawnLootPrefab("thunder_pinecone")
    inst:Remove()

end

local function growSapling(inst)

    print("Stage: Sapling")

    inst.AnimState:PlayAnimation("idle", true)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)

    inst:RemoveComponent("inventoryitem")
    
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")

    inst.sapling = true  

end

local function growTree(inst)

    print("Stage: Tree")

    inst:RemoveComponent("inventoryitem")

    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")  

    if not inst.grown then
        local tree = SpawnPrefab("thunder_tree")
        tree.components.growable:SetStage(1)
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.grown = true
    end

    inst:Remove()  

end

local growth_stages =
{
    {
        name="sapling", 

        time = function(inst) 
            return GetRandomWithVariance(
                TUNING.THUNDER_SAPLING_GROW_TIME[1].base, 
                TUNING.THUNDER_SAPLING_GROW_TIME[1].random) 
        end, 

        fn = function(inst) 
            growSapling(inst) 
        end,  

        growfn = function(inst) 
            growSapling(inst) 
        end 
    },

    {
        name="tree", 

        time = function(inst) 
            return GetRandomWithVariance(
                TUNING.THUNDER_SAPLING_GROW_TIME[2].base, 
                TUNING.THUNDER_SAPLING_GROW_TIME[2].random) 
        end, 

        fn = function(inst) 
            growTree(inst) 
        end,  

        growfn = function(inst) 
            growTree(inst) 
        end 
    }    
}

local growth_stage = 1

local function plant_sapling(inst, pt)

    inst.AnimState:PushAnimation("idle", true)

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(1)
    inst.components.growable.loopstages = false
    inst.components.growable:StartGrowing()

    inst.Transform:SetPosition(pt:Get() )
end

local function onsave(inst, data)

    if inst.sapling == true then
        data.sapling = true
    end

end

local function onload(inst, data)

    if data and (data.sapling == true) then   
        if inst.components.growable then
            inst.components.growable:SetStage(growth_stage)
        else
            inst:AddComponent("growable")
            inst.components.growable.stages = growth_stages
            inst.components.growable:SetStage(growth_stage)
            inst.components.growable.loopstages = false
            inst.components.growable:StartGrowing()
        end
    end

end

local function displaynamefn(inst)
    if inst.components.growable then
        return STRINGS.NAMES.THUNDER_SAPLING
    end

    return STRINGS.NAMES.THUNDER_PINECONE
end

local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local TheSim = TheSim
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags)
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function fn(Sim)

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("thunder_sapling")
    inst.AnimState:SetBuild("thunder_sapling")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("thunder_pinecone")

    if inst.components.inventoryitem then
        inst.AnimState:PlayAnimation("pinecone", true)
    else
        inst.AnimState:PlayAnimation("idle", true)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")

    inst:AddComponent("lootdropper")

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)  

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = plant_sapling

    inst.displaynamefn = displaynamefn

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst

end

return {
    Prefab ("common/thunder_pinecone", fn, assets, prefabs),
    MakePlacer ("common/thunder_pinecone_placer", "thunder_sapling", "thunder_sapling", "idle"),
}
