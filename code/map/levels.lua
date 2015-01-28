
-- Load the global levels script.
require "map/levels"

modrequire "map.layouts"

-- Load all the mod's levels here.
modrequire "map.levels.sky_level_1"
modrequire "map.levels.upandaway_test"

-- Dev purposes only.
if modinfo.name and modinfo.name == "Up and Away (dev)" then
	modrequire "map.levels.sky_level_1_debug"
end