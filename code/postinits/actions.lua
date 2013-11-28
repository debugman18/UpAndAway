---
-- Action tweaks (not necessarily postinits ;P).
--
-- @author simplex



require 'actions'

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
