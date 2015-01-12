--[[
-- This is our world entity.
--
-- I kept the Forest and Cave constructors ("fns") at the end of the file
-- for reference.
--]]



local Lambda = wickerrequire "paradigms.functional"
local Logic = wickerrequire "paradigms.logic"
local Pred = wickerrequire "lib.predicates"

local table = wickerrequire "utils.table"

local Configurable = wickerrequire "adjectives.configurable"


require "util"


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

    Asset("SOUNDPACKAGE", "sound/upandaway.fev"),
    Asset("SOUND",        "sound/upandaway.fsb"),

    --sound/upandaway/bgm/ambiance[1-5]

    Asset("IMAGE", "images/cloudwave.tex"),
}

local essential_prefabs = 
{
    "world",
	"ua_cave",

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
    
--	"antlion",
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

local function FilterOverrides(inst)
    local overrides = inst.topology and inst.topology.overrides
    if not overrides then return end

    local filter_out = {
        misc = {
            season = true,
        },
    }

    for k, entries in pairs(filter_out) do
        local overrides_category = overrides[k]
        if overrides_category then
            table.TrimArray(overrides_category, function(v)
                if entries[v[1]] then
                    return false
                else
                    return true
                end
            end)
        end
    end
end

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

        if not IsDST() then
            local sm = inst.components.seasonmanager
            if sm then
                sm.incaves = false
            end
        end
    end
end


local function fn()
    local inst = SpawnPrefab("ua_cave")
    inst.entity:SetCanSleep(false)

    inst.prefab = "cave"
    inst:AddTag("cloudrealm")

    SetupLevelTypeFix(inst)

    if not IsDST() then
		assert( inst.components.clock )

        local sm = assert( inst.components.seasonmanager )
        PatchSeasonManager(sm)
    end

    --AddNeutralComponent(inst, "quaker")
   
    --Uses our cloudwaves.
    local waves = inst.entity:AddWaveComponent()
    waves:SetRegionSize(40, 29) --This definitely works.
    waves:SetRegionNumWaves(12) --8
    waves:SetWaveTexture(GLOBAL.resolvefilepath("images/cloudwave.tex"))   
    waves:SetWaveEffect("shaders/waves.ksh" ) -- texture.ksh   
    waves:SetWaveSize(2048, 562) --This definitely works.
   
    --inst:SetReverbPreset("clouds")
	
    if not IsDST() then
        --[[
        -- This is wrong. The AmbientSoundMixer:SetOverride is for sounds
        -- associated with tile types. And it's not DST compatible.
        --]]
        --inst.components.ambientsoundmixer:SetOverride("dontstarve/ocean/waves", "dontstarve/common/clouds")
    end
    --inst.componentsambientsoundmixer.wave_sound = "dontstarve/common/clouds"
   
    inst:SetOverrideColourCube("images/colour_cubes/snowdusk_cc.tex")

    --inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )
    
    if IsMasterSimulation() then
        inst:AddComponent("staticgenerator")
        do
            local staticgen = inst.components.staticgenerator
            local cfg = Configurable("STATIC")

            staticgen:SetAverageUnchargedTime( cfg:GetConfig "AVERAGE_UNCHARGED_TIME" )
            staticgen:SetAverageChargedTime( cfg:GetConfig "AVERAGE_CHARGED_TIME" )
            staticgen:SetCooldown( cfg:GetConfig "COOLDOWN" )

            staticgen:StartGenerating()
        end
    end

    ---------------------------------------------
    --
    -- Spawners
    --

    if not IsDedicated() then
        inst:AddComponent("cloudambientmanager")
    end

    -- Temporarily disabled to reduce blasphemy.
    --[[
    if not IsDST() then
        --FIXME: not MP compatible
        inst:AddComponent("balloonhounded")
    end
    ]]

    ---------------------------------------------

    inst:DoTaskInTime(0, FilterOverrides)

    TheMod:DebugSay("Built cloudrealm entity [", inst, "]")
    return inst
end


return Prefab("worlds/cloudrealm", fn, assets, prefabs)
