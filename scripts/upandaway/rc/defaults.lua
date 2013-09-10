--@@NO ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module(...)

--[[
-- This function defines default configuration values.
--
-- To do that, just declare and set "global" variables, like you would in the
-- configuration file (basically, the body of this function should look exactly
-- like a configuration file).
--]]
return function()

end
