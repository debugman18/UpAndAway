name = "Up and Away"
author = "The Fellowship of the Bean"
version = "alpha-0.2.0"

id = "upandaway"
branch = "dev"

description = ([[
A massive mod that adds many new things to the traditional Don't Starve experience, including new items, new monsters, new food, new structures, new recipes, and more.

Original concept by debugman18.
]]):gsub("^%s+", ""):gsub("%s+$", "")

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

all_clients_require_mod = true
clients_only_mod = false

forumthread = "/forum/49-mod-collaboration-up-and-away"

api_version = 6

-- This is used by the packaging system.
dst_api_version = 10

icon_atlas = "favicon/upandaway.xml"
icon = "upandaway.tex"

priority = -1

if not _PARSING_ENV and branch ~= "master" then
	name = name.." ("..branch..")"
end

------------------------------------------------------------------------
-- CFG
------------------------------------------------------------------------

--[[
-- Some utility functions.
--]]

--[[
-- Flattens an array of arrays into a single array.
--]]
local function mergeArrays(arrays)
	local ret = {}
	local n = 0

	for i = 1, #arrays do
		local t = arrays[i]
		for j = 1, #t do
			n = n + 1
			ret[n] = t[j]
		end
	end

	return ret
end

--[[
-- Marks an array of options as singleplayer only.
-- Only relevant when generating the release modinfo.lua.
--]]
local function sponly(opts)
	if _PARSING_ENV then
		for i = 1, #opts do
			opts[i].forbids_dst = true
		end
	end
	return opts
end

--[[
-- Marks an array of options as multiplayer only.
-- Only relevant when generating the release modinfo.lua.
--]]
local function mponly(opts)
	if _PARSING_ENV then
		for i = 1, #opts do
			opts[i].requires_dst = true
		end
	end
	return opts
end
			
---

--[[
-- Some convenience option generators.
--]]

local function NamedSwitch(on_desc, off_desc)
	return function(name, label, default_value)
		return {
			name = name,
			label = label,
			options = {
				{description = on_desc, data = true},
				{description = off_desc, data = false},
			},
			default = default_value and true or false,
		}
	end
end

local EnableSwitch = NamedSwitch("Enabled", "Disabled")
local OnSwitch = NamedSwitch("On", "Off")
local YesSwitch = NamedSwitch("Yes", "No")

local function get_optional(first, second)
	if first ~= nil then
		return first
	else
		return second
	end
end

local function Spinner(name, label, ...)
	local raw_opts = {...}
	local opts = {}

	local default

	for i = 1, #raw_opts do
		local raw = raw_opts[i]
		local opt = {}
		opt.description = get_optional(raw.description, raw[1])
		opt.data = get_optional(raw.data, raw[2])
		opts[i] = opt

		if raw.default then
			default = opt.data
		end
	end

	if default == nil then
		default = opts[1].data
	end

	return {
		name = name,
		label = label,
		options = opts,
		default = default,
	}
end

------------------------------------

configuration_options = mergeArrays {
	--[[
	-- Options for both single and multiplayer.
	--]]
	{
		EnableSwitch("DEBUG", "Debugging mode", true),
		EnableSwitch("CLOUD_LIGHTNING.ENABLED", "Ground lightning", true),
		EnableSwitch("CLOUD_MIST.ENABLED", "Mist", true),
	},
	--[[
	-- Options for singleplayer only.
	--]]
	sponly {
		EnableSwitch("UP_SPLASH.ENABLED", "Custom menu", true),
		-- In DST, unfortunately it'd be the server setting that affects all
		-- clients, since spark entities are networked.
		EnableSwitch("RAM.SPARKS", "Storm ram sparks", true),
	},
	--[[
	-- Options for multiplayer only.
	--]]
	mponly {
		Spinner("CLIMBING_MANAGER.CONSENSUS", "Level switch consensus",
			{"Unanimous", "UNANIMOUS"},
			{"Simple majority", "SIMPLE_MAJORITY", default = true},
			{"Three quarters", "THREE_QUARTERS"},
			{"80/100 aproval", "EIGHTY_PERCENT"},
			{"90/100 approval", "NINETY_PERCENT"},
			{"All but one", "ALL_BUT_ONE"},
			{"All but two", "ALL_BUT_TWO"},
			{"All but three", "ALL_BUT_THREE"})
	},
}
