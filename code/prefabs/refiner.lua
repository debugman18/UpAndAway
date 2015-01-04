BindGlobal()


local RefiningRecipeBook = modrequire "resources.refining_recipebook"

local widget_spec = pkgrequire "common.containerwidgetspecs" .refiner


local assets =
{
    Asset("ANIM", "anim/refiner.zip"),
}

local prefabs =
{
    "rocks",
    "twigs",
    "cutgrass",
    "log",
}    

local function startbrewfn(inst)
    inst.AnimState:PlayAnimation("smashing", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("idle_open_pre")
    inst.AnimState:PushAnimation("idle_open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
    if not inst.components.brewer.brewing then
        inst.AnimState:PlayAnimation("idle_closed_pre")
        inst.AnimState:PushAnimation("idle_closed")
        inst.SoundEmitter:KillSound("snd")
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end

local function donebrewfn(inst)
    inst.AnimState:PlayAnimation("idle_open_pre")
    inst.AnimState:PushAnimation("idle_open")
    --inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.brewer.product)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
end

local function continuedonefn(inst)
    inst.AnimState:PlayAnimation("idle_open")
end

local function continuebrewfn(inst)
    startbrewfn(inst)
end

local function harvestfn(inst)
    inst.AnimState:PlayAnimation("idle_closed_pre")
    inst.AnimState:PushAnimation("idle_closed")
end


local valid_extra_ingredients = {
    beanstalk_chunk = true,
    cloud_coral_fragment = true,
    cloud_algae_fragment = true,
    cloud_cotton = true,
    bonestew = true,
    cloud_jelly = true,
    jellycap_red = true,
    jellycap_blue = true,
    jellycap_green = true,
    golden_petals = true,
    thunder_log = true,
}
local function itemtest(inst, item, slot)
    return (item:HasTag("refinable")) 
        or (item.prefab ~= nil and valid_extra_ingredients[item.prefab])
end
widget_spec:SetItemTestFn(itemtest)

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("refiner")
    inst.AnimState:SetBuild("refiner")
    inst.AnimState:PlayAnimation("idle_closed")
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.Transform:SetScale(3,3,3)
    MakeObstaclePhysics(inst, 1)

    inst:AddTag("structure")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("refiner.tex") 


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("brewer")
    do
        local brewer = inst.components.brewer

        brewer:SetRecipeBook(RefiningRecipeBook)
        brewer.onstartbrewing = startbrewfn
        brewer.oncontinuebrewing = continuebrewfn
        brewer.oncontinuedone = continuedonefn
        brewer.ondonebrewing = donebrewfn
        brewer.onharvest = harvestfn
    end

    inst:AddComponent("inspectable")
        
    inst:AddComponent("container")
    do
        local container = inst.components.container

        widget_spec:ConfigureEntity(inst)

        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
    end

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    return inst
end

return {
    Prefab ("common/inventory/refiner", fn, assets, prefabs),
    MakePlacer ("common/refiner_placer", "refiner", "refiner", "idle_closed", false, false, false, 3),
}    
