--[[
-- This runs when savedata is processed.
-- It runs in the global environment.
--
-- Do NOT place references to anything outside of this function.
-- Use only things in the global environment and defined in the function
-- itself.
--]]
local function onload()
	pcall(function()
		local function IsUpAndAway(moddir)
			local modinfo = KnownModIndex:GetModInfo(moddir)
			return modinfo and modinfo.id == "upandaway"
		end

		local function IsUpAndAwayEnabled()
			for _, moddir in ipairs( ModManager:GetEnabledModNames() ) do
				if IsUpAndAway(moddir) then
					return true
				end
			end
			return false
		end

		if not IsUpAndAwayEnabled() then
			local oldDoInitGame = DoInitGame

			local function get_upandaways()
				local ret = {}
				for _, moddir in ipairs(KnownModIndex:GetModNames()) do
					if IsUpAndAway(moddir) then
						table.insert(ret, moddir)
					end
				end
				return ret
			end

			_G.DoInitGame = function(...)
				local args = {...}
				
				local status = pcall(function()
					local ScriptErrorScreen = require "screens/scripterrorscreen"

					local buttons = {
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
					}

					local upandaways = get_upandaways()
					if #upandaways == 1 then
						-- "Enable U&A" does not work. The ampersand does not show,
						-- for some reason.
						table.insert(buttons, 1, {text = "Enable UA", cb = function()
							KnownModIndex:Enable(upandaways[1])
							KnownModIndex:Save(function()
								StartNextInstance(Settings)
							end)
						end})
					end

					TheFrontEnd:ShowScreen(ScriptErrorScreen(
						"HIC SUNT DRACONES!",
						"This save was last played with the mod Up and Away enabled. It is STRONGLY RECOMMENDED that you DO NOT play this save with it disabled, at the risk of data loss and a permanently broken save.",
						buttons,
						ANCHOR_MIDDLE,
						"Please consider reenabling Up and Away before running this save.",
						30
					))
				end)

				if not status then
					oldDoInitGame(unpack(args))
				end
			end
		end
	end)
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
