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

RegisterServerEvent = wickerrequire "plugins.serverevents"


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

GetClimbingManager = memoize_0ary(function()
	local inst
	if IsDST() then
		inst = TheWorld and TheWorld.net
	else
		inst = TheWorld
	end
	if inst then
		if IsServer() then
			return inst.components.climbingmanager
		else
			return replica(inst).climbingmanager
		end
	end
end)


--[[
-- This is to simplify atlasing several textures into one later on.
--]]
function inventoryimage_atlas(prefab)
--    return "images/inventoryimages/"..prefab..".xml"
	return "images/ua_inventoryimages.xml"
end
function inventoryimage_texture(prefab)
--    return "images/inventoryimages/"..prefab..".tex"
	return "images/ua_inventoryimages.tex"
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
