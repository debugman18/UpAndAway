--[[
-- This runs when savedata is processed.
-- It runs in the global environment.
--
-- Do NOT place references to anything outside of this function.
-- Use only things in the global environment and defined in the function
-- itself.
--]]
local function onload()
	local function IsUpAndAwayEnabled()
		for _, moddir in ipairs( KnownModIndex:GetModsToLoad() ) do
			if KnownModIndex:GetModInfo(moddir).id == "upandaway" then
				return true
			end
		end
		return false
	end

	if not IsUpAndAwayEnabled() then
		local oldDoInitGame = DoInitGame

		_G.DoInitGame = function(...)
			local args = {...}

			if Settings.ignore_missing_upandaway then
				return oldDoInitGame(...)
			else
				local ScriptErrorScreen = require "screens/scripterrorscreen"

				TheFrontEnd:ShowScreen(ScriptErrorScreen(
					"HIC SUNT DRACONES!",
					"This save was last played with the mod Up and Away enabled. It is STRONGLY RECOMMENDED that you DO NOT play this save with it disabled, at the risk of data loss and a permanently broken game.",
					{
						{text = "Main Menu", cb = function()
							if rawget(_G, "EnableAllDLC") then
								-- This is needed for the DLC main screen to be shown.
								EnableAllDLC()
							end
							StartNextInstance()
						end},
						{text = "Ignore", cb = function()
							TheFrontEnd:PopScreen()
							oldDoInitGame(unpack(args))
						end},
					},
					ANCHOR_MIDDLE,
					"Please consider reenabling Up and Away before running this save.",
					30
				))
			end
		end
	end
end
setfenv(onload, _G)


require "mainfunctions"
_G.SavePersistentString = (function()
	local SavePersistentString = _G.SavePersistentString

	return function(name, data, ...)
		local status, parent_info = pcall(debug.getinfo, 3, 'f')

		if status and parent_info and parent_info.func == _G.SaveGame then
			data = ("loadstring(%q)();"):format(string.dump(onload))..data
		end

		return SavePersistentString(name, data, ...)
	end
end)()
