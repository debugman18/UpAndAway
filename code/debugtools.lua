---
-- Utilities for debugging.
--
-- @author simplex

BindGlobal()


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
	local output_path = LOGROOT .. "trace.txt"

	--local reopen_file = (_G.PLATFORM ~= "LINUX")
	local reopen_file = false

	local f = nil

	return function()
		if f then return end

		f = assert(io.open(output_path, "wb"), "Can't open '" .. output_path .. "' for writing!")

		f:write("Execution trace (", os.date("%Y-%m-%d %X"), ")\r\n\r\n")

		if reopen_file then
			f:close()
		else
			f:flush()
		end

		debug.sethook(
			function(ev_type)
				if reopen_file then
					f = assert(io.open(output_path, "a+b"), "Can't open '" .. output_path .. "' for appending!")
				end

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

					if info.namewhat and info.namewhat ~= "" and info.name then
						f:write(
							("Calling %s %s function %s\r\n"):format(
								info.namewhat,
								info.what or "unknown",
								info.name
							)
						)
					else
						f:write(
							("Calling anonymous %s function\r\n"):format(
								info.what or "unknown"
							)
						)
					end
				end

				if reopen_file then
					f:close()
				else
					f:flush()
				end
			end,
		'lc')
	end
end)()
