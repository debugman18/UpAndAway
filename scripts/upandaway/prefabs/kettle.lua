--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire 'paradigms.functional'

local Brewing = modrequire 'lib.brewing'
local BrewingRecipeBook = modrequire 'resources.brewing_recipebook'


require "prefabutil"


local assets=
{
	Asset("ANIM", "anim/cook_pot.zip"),
	Asset("ANIM", "anim/cook_pot_food.zip"),
}


local prefabs = Lambda.CompactlyMap(Brewing.Recipe.GetName, BrewingRecipeBook:Recipes())


local slotpos = {	Vector3(0,64+32+8+4,0), 
					Vector3(0,32+4,0),
					Vector3(0,-(32+4),0), 
					Vector3(0,-(64+32+8+4),0)}

local widgetbuttoninfo = {
	text = "Brew",
	position = Vector3(0, -165, 0),
	fn = function(inst)
		inst.components.brewer:StartBrewing()	
	end,
	
	validfn = function(inst)
		return inst.components.brewer:CanBrew()
	end,
}

local function itemtest(inst, item, slot)
	return (item.components.edible and item.components.edible.foodtype ~= "MEAT") or item:HasTag("tea_leaf")
end

--anim and sound callbacks

local function startbrewfn(inst)
	inst.AnimState:PlayAnimation("cooking_loop", true)
	--play a looping sound
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
	inst.Light:Enable(true)
end


local function onopen(inst)
	inst.AnimState:PlayAnimation("cooking_pre_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
	if not inst.components.brewer.cooking then
		inst.AnimState:PlayAnimation("idle_empty")
		inst.SoundEmitter:KillSound("snd")
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end

local function donebrewfn(inst)
	inst.AnimState:PlayAnimation("cooking_pst")
	inst.AnimState:PushAnimation("idle_full")
	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.brewer.product)
	
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
	inst.Light:Enable(false)
	--play a one-off sound
end

local function continuedonefn(inst)
	inst.AnimState:PlayAnimation("idle_full")
	--inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.brewer.product)
end

local function continuebrewfn(inst)
	inst.AnimState:PlayAnimation("cooking_loop", true)
	--play a looping sound
	inst.Light:Enable(true)

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function harvestfn(inst)
	inst.AnimState:PlayAnimation("idle_empty")
end

local function getstatus(inst)
	if inst.components.brewer.cooking then
		return "BREWING"
	elseif inst.components.brewer.done then
		return "DONE"
	else
		return "EMPTY"
	end
end

local function onfar(inst)
	inst.components.container:Close()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_empty")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "cookpot.png" )
	
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("cook_pot")
    inst.AnimState:SetBuild("cook_pot")
    inst.AnimState:PlayAnimation("idle_empty")

    inst:AddComponent("brewer")
    inst.components.brewer.onstartbrewing = startbrewfn
    inst.components.brewer.oncontinuebrewing = continuebrewfn
    inst.components.brewer.oncontinuedone = continuedonefn
    inst.components.brewer.ondonebrewing = donebrewfn
    inst.components.brewer.onharvest = harvestfn
    
    
    
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


    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus


    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)


	--MakeSnowCovered(inst, .01)    
	inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end


return {
	Prefab( "common/kettle", fn, assets, prefabs),
	MakePlacer( "common/kettle_placer", "cook_pot", "cook_pot", "idle_empty" ),
}
