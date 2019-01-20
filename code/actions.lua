BindGlobal()


local ACTIONS = ACTIONS

BindTheMod()

local mount_enabled = {mount_enabled = true}
local mount_disabled = {mount_enabled = false}

local Deploy = Action(mount_enabled)
Deploy.strfn = (function()
    local oldfn = ACTIONS.DEPLOY.strfn

    return function(act)
        if act.invobject and act.invobject:HasTag("portable_structure") then
            return "PORTABLE_STRUCTURE"
        else
            return oldfn(self.act)
        end
    end
end)()

Deploy.str = "Deploy"
Deploy.id = "DEPLOY"

---

local Climb = Action(mount_enabled)
Climb.str = "Climb"
Climb.id = "CLIMB"
Climb.fn = function(act)
	local doer = act.doer
	local targ = act.target or act.invobject
	if doer and doer.components.climbingvoter and targ and targ.components.climbable then
		if GetClimbingManager():HasRequest() then
			return false, "INUSE"
		end
		return doer.components.climbingvoter:BeginPoll(targ)
	end
end

AddAction(Climb)

local climb_sg_handler = "doshortaction"

AddStategraphActionHandler("wilson", ActionHandler(Climb, climb_sg_handler))
if IsClient() then
	AddStategraphActionHandler("wilson_client", ActionHandler(Climb, climb_sg_handler))
end

---

local Withdraw = Action(mount_enabled, 1)
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

local withdraw_sg_handler = "dolongaction"

AddStategraphActionHandler("wilson", ActionHandler(Withdraw, withdraw_sg_handler))
if IsClient() then
    AddStategraphActionHandler("wilson_client", ActionHandler(Withdraw, withdraw_sg_handler))
end

---

-- Ugly name, but avoids confusion with vanilla's TALKTO action.
local BeginSpeech = Action(mount_enabled, -1, false, false, TheMod:GetConfig("SPEECHGIVER", "MAX_DIST"))
BeginSpeech.str = ACTIONS.TALKTO.str
BeginSpeech.id = "BEGINSPEECH"
BeginSpeech.fn = function(act)
    local doer = act.doer
    local targ = act.target
    if doer and targ and targ.components.speechgiver then
        TheMod:Say "BeginSpeech.fn going forward!"
        return targ.components.speechgiver:InteractWith(doer)
    end
    TheMod:Say "BeginSpeech.fn failed..."
end

AddAction(BeginSpeech)

AddStategraphActionHandler("wilson", ActionHandler(BeginSpeech, function(inst, action)
    if action.target and action.target.components.speechgiver then
        inst:PerformBufferedAction()
        return "idle"
    end
end))

if IsClient() then
    AddStategraphActionHandler("wilson_client", ActionHandler(BeginSpeech, function(inst, action)
        if action.target and replica(action.target).speechgiver then
            inst:PerformPreviewBufferedAction()
            return "idle"
        end
    end))
end

---

local Brew = Action(mount_enabled)
Brew.str = "Brew"
Brew.id = "BREW"
Brew.fn = function(act)
    local brewer = act.target.components.brewer
    if brewer then
        brewer:StartBrewing( act.doer )
        return true
    end
end

AddAction(Brew)
