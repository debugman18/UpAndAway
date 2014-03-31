
modrequire 'map.tiledefs'

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
