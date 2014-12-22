---
-- Defines the mod environment.
--
-- @author simplex


Lambda = wickerrequire "paradigms.functional"
Logic = wickerrequire "lib.logic"
Pred = wickerrequire "lib.predicates"
Game = wickerrequire "game"
Math = wickerrequire "math"

Configurable = wickerrequire "adjectives.configurable"
Debuggable = wickerrequire "adjectives.debuggable"

FunctionQueue = wickerrequire "gadgets.functionqueue"

LOGROOT = MODROOT .. "log/"


netcfg = Configurable("NETWORK")


AddSelfPostInit(function()
	Climbing = modrequire "lib.climbing"
end)


--[[
-- Note that this does NOT run in a "global" environment, things should be
-- explicitly imported (unless they are by wicker itself already).
--
-- Since this environment is shared by every mod file, it should remain that way.
--]]

GetStaticGenerator = memoize_0ary(function()
	local w = GetWorld()
	return w and w.components.staticgenerator
end)
GetStaticGen = GetStaticGenerator


if VarExists("IsDLCEnabled") then
	IsDLCEnabled = _G.IsDLCEnabled
else
	IsDLCEnabled = Lambda.False
end
if VarExists("IsDLCInstalled") then
	IsDLCInstalled = _G.IsDLCInstalled
else
	IsDLCInstalled = Lambda.False
end
if VarExists("REIGN_OF_GIANTS") then
	REIGN_OF_GIANTS = _G.REIGN_OF_GIANTS
else
	REIGN_OF_GIANTS = 1
end


if not IsWorldgen() then
	--[[
	-- This cancels a thread (as in inst:StartThread()), avoiding the pitfalls/crashes
	-- with using KillThread directly.
	--]]
	CancelThread = (function()
		local to_cleanup = nil

		_G.scheduler.Run = (function()
			local SchedRun = assert(_G.scheduler.Run)

			return function(self)
				SchedRun(self)
				if to_cleanup then
					for _, thread in ipairs(to_cleanup) do
						_G.KillThread(thread)
					end
					to_cleanup = nil
				end
			end
		end)()

		return function(thread)
			if thread then
				if not to_cleanup then
					to_cleanup = {}
				end
				table.insert(to_cleanup, thread)
			end
		end
	end)()
end


RegisterModEnvironment(_M)
return _M
