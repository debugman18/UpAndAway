---
-- Action tweaks (not necessarily postinits ;P).
--
-- @author simplex


--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

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
