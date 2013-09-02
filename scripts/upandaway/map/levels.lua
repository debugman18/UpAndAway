--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

-- Load the global levels script.
require 'map/levels'

-- Load all the mod's levels here.
modrequire 'map.levels.sky_level_1'
