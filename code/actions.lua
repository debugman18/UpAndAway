BindGlobal()


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


-- Ugly name, but avoids confusion with vanilla's TALKTO action.
local BeginSpeech = Action(-1, false, false, TheMod:GetConfig("SPEECHGIVER", "MAX_DIST"))
BeginSpeech.str = ACTIONS.TALKTO.str
BeginSpeech.id = "BEGINSPEECH"
BeginSpeech.fn = function(act)
	local doer = act.doer
	local targ = act.target
	if doer and targ and targ.components.speechgiver then
		return targ.components.speechgiver:InteractWith(doer)
	end
end

AddAction(BeginSpeech)

AddStategraphActionHandler("wilson", ActionHandler(BeginSpeech, function(inst, action)
	if action.target and action.target.components.speechgiver then
		inst:PerformBufferedAction()
		return "idle"
	end
end))
