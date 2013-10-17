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

_O.GetStaticGenerator = GetStaticGenerator

_O.GetStaticGen = _O.GetStaticGenerator


_O.trace_flow = (function()
	local output_path = "trace.txt"

	local f = nil

	return function()
		if f then return end

		f = assert(io.open(output_path, "w"), "Can't open '" .. output_path .. "' for writing!")

		f:write("Execution trace (", os.date("%F %X"), ")\r\n\r\n")

		debug.sethook(
			function(ev_type)
				if ev_type == "line" then
					local info = debug.getinfo(2, 'Sl')

					f:write(
						("Entered %s:%d\r\n"):format(
							info.source or "?",
							info.currentline or -1
						)
					)
				elseif ev_type == "call" then
					local info = debug.getinfo(2, 'Sn')

					f:write(
						("Calling %s %s function %s\r\n"):format(
							info.namewhat or "",
							info.what or "anonymous",
							info.name or "?"
						)
					)
				end

				f:flush()
			end,
		'lc')
	end
end)()
