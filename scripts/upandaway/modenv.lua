---
-- Defines the mod environment.
--
-- @author simplex

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

LOGROOT = MODROOT .. "log/"

--[[
-- Note that this does NOT run in a "global" environment, things should be
-- explicitly imported (unless they are by wicker itself already).
--
-- Since this environment is shared by every mod file, it should remain that way.
--]]

function GetStaticGenerator()
	local w = GetWorld()
	return w and w.components.staticgenerator
end


RegisterModEnvironment(_M)
return _M
