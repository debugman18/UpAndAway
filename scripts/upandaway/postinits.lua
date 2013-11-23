---
-- Loads the postinit submodules.
--

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

modrequire 'postinits.burning'
modrequire 'postinits.temperature'
modrequire 'postinits.itemtile'
