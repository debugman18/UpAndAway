local LEVELTYPE = _G.LEVELTYPE

-- FIXME: Replace with a decent method, when possible.
--local has_rog = IsDLCEnabled(REIGN_OF_GIANTS)
local has_rog = true

local season_start = has_rog and "autumn" or "summer"
local season_mode = has_rog and "onlyautumn" or "onlysummer"

TheMod:AddLevel(LEVELTYPE.SURVIVAL, {
	id="UPANDAWAY_SURVIVAL_TEST",
	name="Up and Away (preview)",
	nomaxwell=true,
	desc="A quick introduction to what Up and Away offers.",

	overrides={
		{"world_size", 		"tiny"},
		{"day", 			"longday"}, 
		{"looping",			"more"},

		{"season_start", 	season_start},		
		{"season_mode",		season_mode},
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


TheMod:AddPostRun(function(file)
	if file ~= "main" then return end
	TheMod:AddSimPostInit(function(player)
		if SaveGameIndex:GetCurrentMode() ~= "survival" then return end

		local world = GetWorld()

		if not world or not world.meta or world.meta.level_id ~= "UPANDAWAY_SURVIVAL_TEST" then return end


		--[[
		-- General tweaks to the world.
		--]]

		world.components.clock.GetMoonPhase = Lambda.Constant("full")


		if not (SaveGameIndex:GetSlotDay() == 1 and GetClock():GetNormTime() == 0) then return end


		--[[
		-- Tweaks for the first time the world is loaded.
		--]]

		--[[
		if player.components.inventory then
			for _, prefabs in ipairs{ {"boards", 10} } do
				local inst = SpawnPrefab(prefabs[1])
				if inst then
					if inst.components.stackable then
						inst.components.stackable:SetStackSize(prefabs[2] or 1)
					end

					player.components.inventory:GiveItem(inst)
				end
			end
		end
		]]--
	end)
end)
