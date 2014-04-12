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
GetStaticGen = GetStaticGenerator


if VarExists("IsDLCEnabled") then
	IsDLCEnabled = _G.IsDLCEnabled
else
	IsDLCEnabled = Lambda.False
end
if VarExists("REIGN_OF_GIANTS") then
	REIGN_OF_GIANTS = _G.REIGN_OF_GIANTS
else
	REIGN_OF_GIANTS = false
end


RegisterModEnvironment(_M)
return _M
