---
-- Utilities for debugging.
--
-- @author simplex

--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


if not TheMod:Debug() then return end


local time = wickerrequire 'utils.time'


-- Output environment for the utilities.
local _O = _G


--[[
-- Type ClimbTo(0) in the console to return to the surface.
--]]
_O.ClimbTo = (modrequire 'lib.climbing').ClimbTo


function _O.GetStaticGenerator()
	local world = GetWorld()
	return world and world.components.staticgenerator
end
_O.GetStaticGen = _O.GetStaticGenerator
