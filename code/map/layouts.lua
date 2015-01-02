
modrequire "map.tiledefs"

--Controls setpeices.
local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

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
