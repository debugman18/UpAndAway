

local Pred = wickerrequire 'lib.predicates'

local Debuggable = wickerrequire 'adjectives.debuggable'

local MarkovChain = wickerrequire 'math.probability.markovchain'


-- In seconds.
local UPDATING_PERIOD = 2


local events_map = {
	UNCHARGED = "upandaway_uncharge",
	CHARGED = "upandaway_charge",
}

local generic_event = "upandaway_chargechange"

---
--
-- The StaticGenerator component.
-- <br />
-- Pushes the events "upandaway_charge", "upandaway_uncharge" and "upandaway_chargechange".
--
-- @author simplex
--
-- @class table
-- @name StaticGenerator
local StaticGenerator = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self)

	self:SetConfigurationKey("STATIC")

	local COOLDOWN = self:GetConfig "COOLDOWN"
	assert( Pred.IsPositiveNumber(COOLDOWN) )

	local chain = MarkovChain()
	chain:AddState("CHARGED")
	chain:AddState("UNCHARGED")
	chain:SetInitialState("NONE")
	chain:SetTransitionProbability("NONE", "UNCHARGED", 1)
	chain:SetTransitionFn(function(old, new)
		local event = assert( events_map[new] )
		self:DebugSay("Pushing event ", ("%q"):format(event))
		self.inst:PushEvent(event)
		self:DebugSay("Pushing generic event ",("(%q, {state = %q})"):format(generic_event, new))
		self.inst:PushEvent(generic_event, {state = new})
		self:StopGenerating()
		self.inst:DoTaskInTime(COOLDOWN, function(inst)
			if inst:IsValid() and inst.components.staticgenerator then
				inst.components.staticgenerator:StartGenerating()
			end
		end)
	end)
	self.chain = chain

	self.task = nil
end)


local function average_time_to_probability(dt)
	assert( Pred.IsPositiveNumber(dt) )
	return 1/math.ceil(dt/UPDATING_PERIOD)
end


---
-- Sets the average duration of the CHARGED state.
--
-- @param dt Average duration, in seconds.
function StaticGenerator:SetAverageChargedTime(dt)
	self.chain:SetTransitionProbability( "CHARGED", "UNCHARGED", average_time_to_probability(dt) )
end

---
-- Sets the average duration of the UNCHARGED state.
--
-- @param dt Average duration, in seconds.

function StaticGenerator:SetAverageUnchargedTime(dt)
	self.chain:SetTransitionProbability( "UNCHARGED", "CHARGED", average_time_to_probability(dt) )
end


---
-- Returns whether the prefab is CHARGED.
--
-- @return A boolean, representing the state.
function StaticGenerator:IsCharged()
	return self.chain:GetState() == "CHARGED"
end

---
-- Starts updating the state transition.
function StaticGenerator:StartGenerating()
	if not self.task and self.inst:IsValid() then
		self.task = self.inst:DoPeriodicTask(UPDATING_PERIOD, function(inst)
			if inst:IsValid() and inst.components.staticgenerator then
				inst.components.staticgenerator.chain:Step()
			end
		end)
	end
end

---
-- Halts the updating of the state transition.
function StaticGenerator:StopGenerating()
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
end

---
-- Handles long updates by simply going to the UNCHARGED state.
function StaticGenerator:LongUpdate(dt)
	self.chain:GoTo("UNCHARGED")
end


--[[
-- These are just convenience functions, mostly for testing.
--]]

---
-- Goes to the CHARGED state.
function StaticGenerator:Charge()
	self.chain:GoTo("CHARGED")
end

---
-- Goes to the UNCHARGED state.
function StaticGenerator:Uncharge()
	self.chain:GoTo("UNCHARGED")
end

---
-- Goes to the other state.
function StaticGenerator:Toggle()
	if self:IsCharged() then
		self:Uncharge()
	else
		self:Charge()
	end
end

---
-- Saves the current state.
function StaticGenerator:OnSave()
	return {
		state = self.chain:GetState(),
	}
end

---
-- Loads the saved state and goes to it.
function StaticGenerator:OnLoad(data)
	local state = data and data.state
	if type(state) == "string" then
		state = state:upper()
		if self.chain:IsState(state) then
			self.LoadPostPass = function()
				self.chain:GoTo(state)
			end
		end
	end
end


return StaticGenerator
