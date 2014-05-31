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
	local CollectEquippedActions = Weapon.CollectUseActions
	return function(self, doer, target, ...)
		if target and target:HasTag("shopkeeper") then--and not _G.TheInput:IsControlPressed(_G.CONTROL_FORCE_ATTACK) then
			return
		end
		return CollectEquippedActions(self, doer, target, ...)
	end
end)()
