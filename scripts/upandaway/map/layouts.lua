--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

modrequire 'map.tiledefs'

--Controls setpeices.
local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

Layouts["BeanstalkTop"] = StaticLayout.Get("map.static_layouts.beanstalk_top")
