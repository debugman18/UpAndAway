--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local ACTIONS = ACTIONS


BindTheMod()


ACTIONS.DEPLOY.strfn = (function()
	local oldfn = ACTIONS.DEPLOY.strfn

	return function(act)
		if act.invobject and act.invobject:HasTag("portable_structure") then
			return "PORTABLE_STRUCTURE"
		else
			return oldfn(act)
		end
	end
end)()


local Withdraw = Action(1)
Withdraw.str = "Withdraw"
Withdraw.id = "WITHDRAW"
Withdraw.fn = function(act)
	local doer = act.doer
	local targ = act.target or act.invobject
	if doer and targ and targ.components.withdrawable then
		return targ.components.withdrawable:Withdraw(doer)
	end
end

AddAction(Withdraw)

AddStategraphActionHandler("wilson", ActionHandler(Withdraw, function(inst, action)
	local un = action.target and action.target.components.withdrawable
	if un then
		return un.quickwithdraw and "doshortaction" or "dolongaction"
	end
end))
