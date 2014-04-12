--[[
-- This is for measuring how long the mod is taking to load.
--]]
local t0 = GLOBAL.GetTime()

modimport 'lib/use.lua'

TheMod = use 'start_wicker'


modimport "assets.lua"
modimport "prefabfiles.lua"


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

TheMod:Run("main")


TheMod:Say( ("Finished loading in %.3f seconds."):format(GLOBAL.GetTime() - t0) )
