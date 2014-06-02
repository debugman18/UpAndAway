---
-- Action tweaks
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

local Weapon = require "components/weapon"
Weapon.CollectEquippedActions = (function()
	local CollectEquippedActions = Weapon.CollectEquippedActions
	return function(self, doer, target, ...)
		if target and target:HasTag("shopkeeper") then
			return
		end
		return CollectEquippedActions(self, doer, target, ...)
	end
end)()
