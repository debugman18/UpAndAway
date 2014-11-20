name = "Up and Away"
author = "The Fellowship of the Bean"
version = "alpha-0.1.0"

id = "upandaway"
branch = "dev"

description = ([[
A massive mod that adds many new things to the traditional Don't Starve experience, including new items, new monsters, new food, new structures, new recipes, and more.

Original concept by debugman18.
]]):gsub("^%s+", ""):gsub("%s+$", "")

dont_starve_compatible = true
reign_of_giants_compatible = true

forumthread = "/forum/49-mod-collaboration-up-and-away"

api_version = 6

icon_atlas = "favicon/upandaway.xml"
icon = "upandaway.tex"

priority = -1

if not _PARSING_ENV and branch ~= "master" then
	name = name.." ("..branch..")"
end

------------------------------------------------------------------------
-- CFG
------------------------------------------------------------------------

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

------------------------------------

configuration_options = {
	EnableSwitch("CLOUD_LIGHTNING.ENABLED", "Ground Lightning", true),
	EnableSwitch("CLOUD_MIST.ENABLED", "Mist", true),
	EnableSwitch("RAM.SPARKS", "Storm Ram Sparks", true),
	EnableSwitch("DEBUG", "Debugging Mode", true),
	EnableSwitch("UP_SPLASH.ENABLED", "Custom Menu", true),
}
