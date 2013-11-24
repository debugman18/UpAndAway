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


local Undeploy = Action(1)
Undeploy.str = "Undeploy"
Undeploy.id = "UNDEPLOY"
Undeploy.fn = function(act)
	local doer = act.doer
	local targ = act.target or act.invobject
	if doer and targ and targ.components.undeployable then
		return targ.components.undeployable:Undeploy(doer)
	end
end

AddAction(Undeploy)

AddStategraphActionHandler("wilson", ActionHandler(Undeploy, function(inst, action)
	local un = action.target and action.target.components.undeployable
	if un then
		return un.quickundeploy and "doshortaction" or "dolongaction"
	end
end))
