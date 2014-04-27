--[[
-- This is our world entity.
--
-- I kept the Forest and Cave constructors ("fns") at the end of the file
-- for reference.
--]]



local Lambda = wickerrequire 'paradigms.functional'
local Logic = wickerrequire 'paradigms.logic'
local Pred = wickerrequire 'lib.predicates'

local Configurable = wickerrequire 'adjectives.configurable'


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

    Asset("SOUND", "sound/forest_stream.fsb"),
    Asset("SOUND", "sound/cave_AMB.fsb"),
    Asset("SOUND", "sound/cave_mem.fsb"),

    Asset("IMAGE", "images/cloudwave.tex"),
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
    Asset("IMAGE", "images/cloudwave.tex"), 
}

local custom_prefabs = {
	"vine",
	"beanstalk",
	"beanstalk_exit",
	"beanstalk_chunk",
	
	"magic_beans",

	"skyflower",

	"skyflower_petals",
	"datura_petals",

	"sheep",

	"cloud_cotton",
	"cloud_turf",
	"cloud_bush",
	"cloudcrag",
	
	"cloud_bush",
	"bee_marshmallow",
	"hive_marshmallow",
	
	"flying_fish",
	"goose",
	
	"longbill",
	"skyflies",
	
	"antlion",
	"owl",
	"crystal_relic",
	"duckraptor",

	--[[
	"golden_egg",
	"gustflower",
	"frog",
	"golden_sunflower",
	"skeleton",
	"ball_lighting",
	"beanlet",
	"beanlet_zealot",
	"crystal_white",
	"crystal_black",
	"crystal_spire",
	"crystal_water",
	"crystal_quartz",
	"crystal_light",
	"thunder_tree",
	"skytrap",
	"balloon_hound",
	]]
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


local function PatchSeasonManager(sm)
	if not sm then return end

	local pending_stopprecip = false

	local oldOnUpdate = assert( sm.OnUpdate )
	local oldStopPrecip = assert( sm.StopPrecip )

	function sm:OnUpdate(dt)
		self.OnUpdate = oldOnUpdate
		self.StopPrecip = oldStopPrecip

		oldOnUpdate(self, dt)

		if pending_stopprecip then
			pending_stopprecip = false
			oldStopPrecip(self)
		end
	end

	function sm:StopPrecip()
		if not pending_stopprecip then
			pending_stopprecip = true
			self.inst:DoTaskInTime(0, function(inst)
				if inst.components.seasonmanager then
					inst.components.seasonmanager:OnUpdate(0)
				end
			end)
		end
	end

	sm.SetCaves = Lambda.Nil
end

local function SetupLevelTypeFix(inst, new_level_type)
	new_level_type = new_level_type or "cloudrealm"
	
	local oldLoadPostPass = inst.LoadPostPass

	function inst:LoadPostPass(...)
		assert( self.topology )
		self.topology.level_type = new_level_type

		if oldLoadPostPass then
			oldLoadPostPass(self, ...)
		end

		local sm = inst.components.seasonmanager
		if sm then
			sm.incaves = false
		end
	end
end


local function fn(Sim)
	local inst = SpawnPrefab("world")
	inst.entity:SetCanSleep(false)

	inst.prefab = "cave"
	inst:AddTag("cloudrealm")

	SetupLevelTypeFix(inst)

	if not inst.components.clock then
		inst:AddComponent("clock")
	end

	inst:AddComponent("seasonmanager")
	PatchSeasonManager(inst.components.seasonmanager)

	--AddNeutralComponent(inst, "quaker")
   
    --Uses our cloudwaves.
    local waves = inst.entity:AddWaveComponent()
    --32,16
    waves:SetRegionSize(40, 20)
    --8
    waves:SetRegionNumWaves(8)
    waves:SetWaveTexture(GLOBAL.resolvefilepath("images/cloudwave.tex"))   
    waves:SetWaveEffect("shaders/waves.ksh" ) -- texture.ksh   
    --2048,512 
	waves:SetWaveSize(2048, 562)
   
    --inst.components.ambientsoundmixer:SetReverbPreset("chess")  
    --ambientsoundmixer.wave_sound = GLOBAL.resolvefilepath("dontstarve/ocean/waves"))
   
	inst:AddComponent("colourcubemanager")
	do
		local ccman = inst.components.colourcubemanager
		local COLOURCUBE = "images/colour_cubes/snowdusk_cc.tex"

		ccman:SetOverrideColourCube(COLOURCUBE)
	end

	--inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )
	
	inst:AddComponent("staticgenerator")
	do
		local staticgen = inst.components.staticgenerator
		local cfg = Configurable("STATIC")

		staticgen:SetAverageUnchargedTime( cfg:GetConfig "AVERAGE_UNCHARGED_TIME" )
		staticgen:SetAverageChargedTime( cfg:GetConfig "AVERAGE_CHARGED_TIME" )

		staticgen:StartGenerating()
	end

	inst:AddComponent("cloudambientmanager")

	inst:AddComponent("skyflyspawner")
	do
		local flyspawner = inst.components.skyflyspawner
		local cfg = Configurable("SKYFLYSPAWNER")

		flyspawner:SetFlyPrefab("skyflies")
		flyspawner:SetMaxFlies( cfg:GetConfig "MAX_FLIES" )
		do
			local min, max = unpack(cfg:GetConfig "SPAWN_DELAY")
			local dt = max - min
			flyspawner:SetDelay( function() return min + dt*math.random() end )
		end
		do
			local min, max = unpack(cfg:GetConfig "PLAYER_DISTANCE")
			flyspawner:SetMinDistance(min)
			flyspawner:SetMaxDistance(max)
		end
		flyspawner:SetMinFlySpread(cfg:GetConfig "MIN_FLY2FLY_DISTANCE")
		flyspawner:SetPersistence( cfg:GetConfig "PERSISTENT" )

		flyspawner:SetShouldSpawnFn(function()
			local sgen = inst.components.staticgenerator
			return sgen and sgen:IsCharged()
		end)

		flyspawner:Touch()
	end

	inst:AddComponent("balloonhounded")

	TheMod:DebugSay("Built cloudrealm entity [", inst, "]")
	return inst
end


return Prefab("cloudrealm", fn, assets, prefabs)
