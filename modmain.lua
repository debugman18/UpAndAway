--[[
-- This is for measuring how long the mod is taking to load.
--]]
local t0 = GLOBAL.GetTime()

modimport 'lib/use.lua'

TheMod = use 'start_wicker'


modimport "assets.lua"
modimport "prefabfiles.lua"

local extra_prefabs
if GLOBAL.kleifileexists("scripts/networking.lua") then
	extra_prefabs = MultiplayerExclusive_PrefabFiles
else
	extra_prefabs = SingleplayerExclusive_PrefabFiles
end
if extra_prefabs then
	for _, p in GLOBAL.ipairs(extra_prefabs) do
		GLOBAL.table.insert(PrefabFiles, p)
	end
end


--RemapSoundEvent("dontstarve/music/music_FE", "upandaway/music/music_FE")


--Removing this for the moment to test new turfs.

--[[
if TheMod:Debug() then
	local new_tiles = TheMod:GetConfig("NEW_TILES")

	table.insert(PrefabFiles, "turf_test")

	AddSimPostInit(function(inst)
		local inv = inst.components.inventory
		
		for _, v in ipairs(new_tiles) do
			if inv and not inv:Has("turf_" .. v, 1) then
				inv:GiveItem( GLOBAL.SpawnPrefab("turf_" .. v) )
			end
		end
	end)
end
--]]

TheMod:Say("Running main...")
TheMod:Run("main")


TheMod:Say( ("Finished loading in %.3f seconds."):format(GLOBAL.GetTime() - t0) )
