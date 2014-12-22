local _G = GLOBAL
local assert, error = _G.assert, _G.error

--[[
-- This is for measuring how long the mod is taking to load.
--
-- If os.clock is available, under Linux this will measure the time the
-- actual process takes (even if the CPU is busy with other concurrent
-- processes). Under other OSes, this will measure the real elapsed time.
--
-- If os.clock is not available, it will use whatever GLOBAL.GetTime provides.
--]]
local GetUserTime
do
	local os = _G.rawget(_G, "os")
	if os then
		local os_clock = _G.rawget(_G, "clock")
		if os_clock and _G.pcall(os_clock) then
			GetUserTime = os_clock
		end
	end

	if not GetUserTime then
		GetUserTime = _G.GetTime
	end
end

function NewTimeMeasurer()
	local t0

	local ret = function()
		return GetUserTime() - t0
	end

	t0 = GetUserTime()
	return ret
end

local singleton_measurer
function GetSingletonTimeMeasurer()
	if singleton_measurer == nil then
		singleton_measurer = NewTimeMeasurer()
	end
	return singleton_measurer
end
