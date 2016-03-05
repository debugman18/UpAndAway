--FIXME: not MP compatible (the full moon only thing)

--[[
-- RoG only parameters (like "onlyautumn") get translated into their vanilla
-- counterparts automatically by patches.world_customisation_compat.
--]]

local LEVELTYPE = _G.LEVELTYPE

TheMod:AddLevel(LEVELTYPE.SURVIVAL, {
    id="UPANDAWAY_SURVIVAL_TEST",
    name="Up and Away (preview)",
    nomaxwell=true,
    desc="A quick introduction to what Up and Away offers.",

    overrides={
        {"world_size", 		"tiny"},
        {"day", 			"longday"}, 
        {"looping",			"more"},

        {"season_start", 	"autumn"},		
        {"season_mode",		"onlyautumn"},
        {"weather", 		"never"},
        {"boons",			"often"},
        {"roads", 			"never"},	

        {"beefalo",			"often"},
        {"beefaloheat",		"never"},

        {"deerclops", 		"never"},
        {"bearger",			"never"},
        {"goosemoose",		"never"},
        {"dragonfly",		"never"},
        {"deciduousmonster","never"},
        {"liefs",			"never"},
        {"hounds", 			"never"},	
        {"frogs",			"never"},
        {"moles",			"never"},
        {"rain",			"never"},

        {"flint",			"often"},
        {"carrot",			"often"},

        {"touchstone",		"often"},

        
        {"start_setpeice", 	"UpAndAway_TestStart"},				
        {"start_node",		"Clearing"},
    },
    
    tasks = {
        "UpAndAway_survival_preview_1",
        "UpAndAway_survival_preview_2",
        "UpAndAway_survival_preview_3",
    },
    
    set_pieces = {
    },

    required_prefabs = {
        "shopkeeper",
        "beefalo",
        "mound",
    },
})


local patched_world = false
local function patch_preview_world(world)
    if world.meta then
        if patched_world then return end
        patched_world = true

        if world.meta.level_id == "UPANDAWAY_SURVIVAL_TEST" then
            --[[
            -- General tweaks to the world.
            --]]

            TheMod:DebugSay("Patching preview world.")

            if world.components.clock then
                TheMod:DebugSay("Overriding moon cycle to permanent full moon.")
                world.components.clock.GetMoonPhase = Lambda.Constant("full")
            end
        end
    end
end

local function wrap_with_patch(fn)
    return function(world, ...)
        patch_preview_world(world)
        return fn(world, ...)
    end
end

TheMod:AddPostRun(function(file)
    if file ~= "main" then return end
    TheMod:AddPrefabPostInit("forest", function(world)
        if SaveGameIndex:GetCurrentMode() ~= "survival" then return end

        world.SetPersistData = wrap_with_patch(world.SetPersistData)
        world.LoadPostPass = wrap_with_patch(world.LoadPostPass)
    end)
end)
