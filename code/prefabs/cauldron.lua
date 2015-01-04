BindGlobal()

local CFG = TheMod:GetConfig()

local AlchemyRecipeBook = modrequire "resources.alchemy_recipebook"

local widget_spec = pkgrequire "common.containerwidgetspecs" .cauldron


local assets =
{
    Asset("ANIM", "anim/cauldron.zip"),
    Asset("SOUND", "sound/common.fsb"),
}


local valid_extra_ingredients = CFG.CAULDRON.INGREDIENTS

local function itemtest(inst, item, slot)
    return (item:HasTag("alchemy"))
        or Game.IsEdible(item)
        or (item.prefab and valid_extra_ingredients[item.prefab])
end
widget_spec:SetItemTestFn(itemtest)

local function startbrewfn(inst)
    inst.components.burnable:Ignite()
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "snd")
    inst.Light:Enable(true)
end

local function donebrewfn(inst)
    inst.components.burnable:Extinguish()
    local smoke = SpawnPrefab("gummybear_rainbow")
    smoke.AnimState:SetMultColour(0.3, 0.7, 0.7, 1)
    smoke.Transform:SetPosition(inst.Transform:GetWorldPosition())   

    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo", "snd")
    inst.Light:Enable(false)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("cauldron")
    inst.AnimState:SetBuild("cauldron")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cauldron.tex")	

    local light = inst.entity:AddLight()
    light:Enable(false)
    light:SetRadius(CFG.CAULDRON.RADIUS)
    light:SetFalloff(CFG.CAULDRON.FALLOFF)
    light:SetIntensity(CFG.CAULDRON.INTENSITY)
    light:SetColour(235/255,62/255,12/255)  

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    -----------------------
    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX(CFG.CAULDRON.BURNFX, Vector3(0, .4, 0))

    inst:AddComponent("brewer")
    do
        local brewer = inst.components.brewer

        brewer:SetRecipeBook(AlchemyRecipeBook)
        brewer.onstartbrewing = startbrewfn
        --brewer.oncontinuebrewing = continuebrewfn
        --brewer.oncontinuedone = continuedonefn
        brewer.ondonebrewing = donebrewfn
        --brewer.onharvest = harvestfn
    end

    inst:AddComponent("inspectable")
        
    inst:AddComponent("container")
    do
        local container = inst.components.container

        widget_spec:ConfigureEntity(inst)

        --container.onopenfn = onopen
        --container.onclosefn = onclose
    end

    return inst
end

return Prefab ("common/inventory/cauldron", fn, assets) 
