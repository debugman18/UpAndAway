modrequire "map.tiledefs"

--Controls setpeices.
local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

-- Adds spawnpoints for multiplayer.
-- This must be set up before the first call to StaticLayout.Get.
if IsDST() then
	wickerrequire "plugins.addstaticlayoutpreinitany"

	TheMod:AddStaticLayoutPreInitAny(function(data, name)
		local objgroup = Lambda.Find(function(layer)
			return layer.type == "objectgroup"
		end, ipairs(data.layers))
		assert( objgroup )

		local objects = assert( objgroup.objects )
		
		local spawnpts = {}
		for _, obj in ipairs(objects) do
			if obj.type == "spawnpoint_master" then
				return
			end
			if obj.type == "spawnpoint" then
				TheMod:DebugSay("Generating multiplayer spawnpoint for '", name, "' from singleplayer data...")
				table.insert(spawnpts, obj)
			end
		end
		for _, obj in ipairs(spawnpts) do
			local dst_obj = Lambda.Map(Lambda.Identity, pairs(obj))
			dst_obj.type = "spawnpoint_master"
			table.insert(objects, dst_obj)
		end
	end)
end


Layouts["BeanstalkTop"] = StaticLayout.Get("map.static_layouts.beanstalk_top")
Layouts["OctocopterWreckage"] = StaticLayout.Get("map.static_layouts.octocopter_wreckage")
Layouts["WitchGrove"] = StaticLayout.Get("map.static_layouts.witch_grove")
Layouts["StrixShrine"] = StaticLayout.Get("map.static_layouts.strix_shrine")
Layouts["Cloudhenge"] = StaticLayout.Get("map.static_layouts.cloudhenge")
Layouts["CheshireHunting"] = StaticLayout.Get("map.static_layouts.cheshire_hunting")
Layouts["CloudHoles"] = StaticLayout.Get("map.static_layouts.cloudholes")

Layouts["OwlColony"] = StaticLayout.Get("map.static_layouts.owlcolony")
Layouts["SkyGrotto"] = StaticLayout.Get("map.static_layouts.skygrotto")
Layouts["HiveTrees1"] = StaticLayout.Get("map.static_layouts.hiveandtrees1")
Layouts["CloudBase1"] = StaticLayout.Get("map.static_layouts.cloudbase1")

Layouts["OctocopterPart1"] = StaticLayout.Get("map.static_layouts.octocopterpart1")
Layouts["OctocopterPart2"] = StaticLayout.Get("map.static_layouts.octocopterpart2")
Layouts["OctocopterPart3"] = StaticLayout.Get("map.static_layouts.octocopterpart3")

---

Layouts["UpAndAway_TestStart"] = StaticLayout.Get("map.static_layouts.upandaway_test_start")
