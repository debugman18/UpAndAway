BindGlobal()


local RefiningRecipeBook = modrequire 'resources.refining_recipebook'


local assets =
{
	Asset("ANIM", "anim/refiner.zip"),
}

local prefabs =
{
    "rocks",
    "twigs",
    "cutgrass",
}    

local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function startbrewfn(inst)
    inst.AnimState:PlayAnimation("smashing", true)
    inst.SoundEmitter:KillSound("snd")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("idle_open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
    if not inst.components.brewer.brewing then
        inst.AnimState:PlayAnimation("idle_closed")
        inst.SoundEmitter:KillSound("snd")
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end

local function donebrewfn(inst)
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
    inst.AnimState:PlayAnimation("idle_closed")
end

local slotpos = {
    Vector3(0,64+32+8+4,0), 
    Vector3(0,32+4,0),
    Vector3(0,-(32+4),0), 
    Vector3(0,-(64+32+8+4),0)
}

local widgetbuttoninfo = {
    text = "Refine",
    position = Vector3(0, -165, 0),
    fn = function(inst)
        inst.components.brewer:StartBrewing( GetPlayer() )  
    end,
        
    validfn = function(inst)
        return inst.components.brewer:CanBrew()
    end,
}

local function itemtest(inst, item, slot)
    return (item:HasTag("refinable")) 
        or item.prefab == "beanstalk_chunk"
        or item.prefab == "cloud_coral_fragment"
        or item.prefab == "cloud_algae_fragment"
        or item.prefab == "cloud_cotton"
        or item.prefab == "bonestew"
        or item.prefab == "cloud_jelly"
        or item.prefab == "jellycap_red"
        or item.prefab == "jellycap_blue"
        or item.prefab == "jellycap_green"
        or item.prefab == "golden_petals"
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
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(4)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_cookpot_1x4"
    inst.components.container.widgetanimbuild = "ui_cookpot_1x4"
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = false
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("refiner.tex") 

    inst:AddComponent("lootdropper")

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    --inst.components.deployable.ondeploy = ondeploy

	return inst
end

return {
    Prefab ("common/inventory/refiner", fn, assets, prefabs),
    MakePlacer ("common/refiner_placer", "refiner", "refiner", "idle_closed", false, false, 3),
}    
