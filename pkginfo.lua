return {
	--[[
	-- Defines the name of the mod directory to be used inside the zip archive.
	-- (it doesn't need to match the actual directory name being used)
	--]]
	moddir = "UpAndAway",

	--[[
	-- Names of the files returning asset tables.
	--]]
	asset_files = {
		--[[
		-- This file lists "regular" as well as prefab assets.
		-- It is automatically generated when the game runs.
		--]]
		"asset_compilation.lua",
	},

	--[[
	-- Names of the files returning tables of prefab files to include.
	--]]
	prefab_files = {
		"prefabfiles.lua",
	},

	--[[
	-- File name suffixes to never include.
	--]]
	exclude_suffixes = {
		".png",
		".psd",
		".xcf",
		".svg",
		".sai",

		".bin",
		".scml",

		"Makefile",
		".mk",
	},

	--[[
	-- Extra files/directories to include.
	--]]
	extra = {
		--[[
		-- Do NOT include "scripts/prefabs".
		-- This is handled by what's in the prefab_files entry above.
		--]]

		"modinfo.lua",
		"modmain.lua",
		"modworldgenmain.lua",
		"start_wicker.lua",
		"timing.lua",

		"NOAUTOCOMPILE",

		"favicon",

		"assets.lua",
		"asset_utils.lua",
		"prefabfiles.lua",

		"credits.lua",
		"LICENSE",
		"NEWS.md",
		"README.md",

		"rc.defaults.lua",
		"tuning.lua",
		"tuning",

		"code",
		"wicker",
		"lib",
	},

	--[[
	-- Directories to include as empty directories.
	--
	-- They are not required to exist (being placed anyway in the zip).
	--]]
	empty_directories = {
		"log",
	},

	--[[
	-- Receives the modinfo file as a table, to be modified.
	--
	-- The resulting table is then (turned back into a file) placed in the zip.
	--]]
	modinfo_filter = function(modinfo)
		modinfo.branch = "master"

		if opts.dst and modinfo.dst_api_version then
			modinfo.api_version = modinfo.dst_api_version
		end
		modinfo.dst_api_version = nil

		if modinfo.configuration_options then
			local kinds = {"forbids_dst", "requires_dst"}
			local bad_kind = opts.dst and "forbids_dst" or "requires_dst"

			local opts = modinfo.configuration_options
			for i = #opts, 1, -1 do
				local opt = opts[i]
				if opt[bad_kind] then
					table.remove(opts, i)
				else
					for _, k in ipairs(kinds) do
						opt[k] = nil
					end
				end
			end
		end

		return modinfo
	end,
}
