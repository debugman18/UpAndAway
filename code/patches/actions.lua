---
-- Action tweaks
--
-- @author simplex



require "actions"

_G.ACTIONS.HARVEST.fn = (function()
    local oldfn = _G.ACTIONS.HARVEST.fn

    return function(act)
        if act.target.components.brewer then
            return act.target.components.brewer:Harvest(act.doer)
        else
            return oldfn(act)
        end
    end
end)()

TheMod:PatchComponentAction("EQUIPPED", "weapon", function(fn)
    assert(fn)
    return function(inst, doer, target, ...)
        if target and target:HasTag("shopkeeper") then
            return
        end
        return fn(inst, doer, target, ...)
    end
end)
