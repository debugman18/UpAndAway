--[[
-- This is our world entity.
--
-- I kept the Forest and Cave constructors ("fns") at the end of the file
-- for reference.
--]]

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


--local Lambda = wickerrequire 'paradigms.functional'
--local Logic = wickerrequire 'paradigms.logic'
--local Pred = wickerrequire 'lib.predicates'


require 'util'


local essential_assets =
{
	Asset("IMAGE", "images/colour_cubes/day05_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/dusk03_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/night03_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/snow_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/snowdusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/night04_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_day_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_dusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_night_cc.tex"),

    Asset("IMAGE", "images/colour_cubes/caves_default.tex"),
    Asset("IMAGE", "images/colour_cubes/ruins_light_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/ruins_dim_cc.tex"),
    Asset("IMAGE", "images/colour_cubes/ruins_dark_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/fungus_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/sinkhole_cc.tex"),

	Asset("IMAGE", "levels/textures/snow.tex"),

    Asset("ANIM", "anim/snow.zip"),
    Asset("ANIM", "anim/lightning.zip"),
    Asset("ANIM", "anim/splash_ocean.zip"),
    Asset("ANIM", "anim/frozen.zip"),

	--Asset("IMAGE", "images/wave.tex"),

    Asset("SOUND", "sound/forest_stream.fsb"),
    Asset("SOUND", "sound/cave_AMB.fsb"),
    Asset("SOUND", "sound/cave_mem.fsb"),
}

local essential_prefabs = 
{
	"world",
	"cloud_mist",
	--"snow",
	--"rain",
	
	"beanstalk_exit",
}


local custom_assets = {

}

local custom_prefabs = {
	"beanstalk",
	"beanstalk_exit",
	"beanstalk_chunk",
	"magic_beans",

	"skyflower",
	"datura",
	"skyflower_petals",
	"datura_petals",

	"sheep",
	"sheep_electric",

	"cloud_cotton",
	"cloud_turf",
	"cloud_bush",
	--"cloudcrag",

	"golden_egg",
}


local assets = _G.ArrayUnion(essential_assets, custom_assets)
local prefabs = _G.ArrayUnion(essential_prefabs, custom_prefabs)

--[[
function AddNeutralComponent(inst, name)
	local Lambda = wickerrequire 'paradigms.functional'
	local Pred = wickerrequire 'lib.predicates'

	assert(Pred.IsStringable(name), "The component name should be a string!")
	local cmp = require("components/" .. tostring(name))

	local ret = {}
	for k, v in pairs(cmp) do
		if type(k) == "string" and type(v) == "function" and not k:match("^_") then
			ret[k] = Lambda.Nil
		end
	end

	ret.inst = inst

	for _, method in ipairs{"OnLoad", "OnSave", "GetDebugString"} do
			ret[method] = nil
	end

	if ret.OnUpdate then
		ret.OnUpdate = function()
				inst:StopUpdatingComponent(name)
		end
	end

	if inst.components[name] then
			inst:RemoveComponent(name)
	end
	inst.components[name] = ret

	return ret
end
]]--


local function SetupLevelTypeFix(inst, new_level_type)
	new_level_type = new_level_type or "cloudrealm"
	
	local oldLoadPostPass = inst.LoadPostPass

	function inst:LoadPostPass(...)
		assert( self.topology )
		self.topology.level_type = new_level_type

		if oldLoadPostPass then
			return oldLoadPostPass(self, ...)
		end
	end
end


local function fn(Sim)
	local inst = SpawnPrefab("world")
	inst.entity:SetCanSleep(false)

	inst.prefab = "cave"
	inst:AddTag("cloudrealm")

	-- This is needed so that the clock's ambient color updating is prevented.
	-- We need this for the static mechanic.
	inst:AddTag("cave")

	SetupLevelTypeFix(inst)

	inst:AddComponent("seasonmanager")

	--AddNeutralComponent(inst, "quaker")

	inst:AddComponent("colourcubemanager")
	--inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )

	return inst
end


return Prefab("cloudrealm", fn, assets, prefabs)


-------------------------------------------------


--[[
-- Forest and cave constructors, for reference.

-- Forest
local function fn(Sim)

	local inst = SpawnPrefab("world")
	inst.prefab = "forest"
	inst.entity:SetCanSleep(false)
	
	
	--add waves
	local waves = inst.entity:AddWaveComponent()
	waves:SetRegionSize( 32, 16 )
	waves:SetRegionNumWaves( 6 )
	waves:SetWaveTexture( "images/wave.tex" )

	-- See source\game\components\WaveRegion.h
	waves:SetWaveEffect( "shaders/waves.ksh" ) -- texture.ksh
	waves:SetWaveSize( 2048, 512 )

	inst:AddComponent("seasonmanager")
    inst:AddComponent("birdspawner")
    inst:AddComponent("butterflyspawner")
	inst:AddComponent("hounded")
	inst:AddComponent("basehassler")
	inst:AddComponent("hunter")
	
    inst.components.butterflyspawner:SetButterfly("butterfly")

	inst:AddComponent("frograin")

	inst:AddComponent("lureplantspawner")
	inst:AddComponent("penguinspawner")

	inst:AddComponent("colourcubemanager")
	inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )
    return inst
end

-- Cave
local function fn(Sim)
	local inst = SpawnPrefab("world")
	inst:AddTag("cave")

	inst.prefab = "cave"
	--cave specifics
	inst:AddComponent("quaker")
	inst:AddComponent("seasonmanager")
	inst.components.seasonmanager:SetCaves()
	inst:AddComponent("colourcubemanager")

	inst.components.ambientsoundmixer:SetReverbPreset("cave")

    return inst
end

]]--
