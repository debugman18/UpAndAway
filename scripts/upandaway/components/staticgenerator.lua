--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


local Pred = wickerrequire 'lib.predicates'

local Debuggable = wickerrequire 'gadgets.debuggable'

local MarkovChain = modrequire 'markovchain'


-- In seconds.
local UPDATING_PERIOD = 2

local COOLDOWN = TheMod:GetConfig("STATIC", "COOLDOWN")
assert( Pred.IsPositiveNumber(COOLDOWN) )


local events_map = {
	charged = { uncharged = "upandaway_uncharge" },
	uncharged = { charged = "upandaway_charge" },
}


---
--
-- The StaticGenerator component.
-- <br />
-- Pushes the events "upandaway_charge" and "upandaway_uncharge".
--
-- @author simplex
--
-- @class table
-- @name StaticGenerator
local StaticGenerator = Class(Debuggable, function(self, inst)
	self.inst = inst

	Debuggable._ctor(self)

	local chain = MarkovChain()
	chain:AddState("charged")
	chain:AddState("uncharged")
	chain:SetInitialState("uncharged")
	chain:SetTransitionFn(function(old, new)
		local event = assert( events_map[old][new] )
		self:DebugSay("Pushing event ", event)
		self.inst:PushEvent(event)
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
-- Sets the average duration of the charged state.
--
-- @param dt Average duration, in seconds.
function StaticGenerator:SetAverageChargedTime(dt)
	self.chain:SetTransitionProbability( "charged", "uncharged", average_time_to_probability(dt) )
end

---
-- Sets the average duration of the uncharged state.
--
-- @param dt Average duration, in seconds.

function StaticGenerator:SetAverageUnchargedTime(dt)
	self.chain:SetTransitionProbability( "uncharged", "charged", average_time_to_probability(dt) )
end


---
-- Returns whether the prefab is charged.
--
-- @return A boolean, representing the state.
function StaticGenerator:IsCharged()
	return self.chain:GetState() == "charged"
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
-- Handles long updates by simply going to the uncharged state.
function StaticGenerator:LongUpdate(dt)
	self.chain:GoTo("uncharged")
end


--[[
-- These are just convenience functions, mostly for testing.
--]]

---
-- Goes to the charged state.
function StaticGenerator:Charge()
	self.chain:GoTo("charged")
end

---
-- Goes to the uncharged state.
function StaticGenerator:Uncharge()
	self.chain:GoTo("uncharged")
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
	if data.state ~= nil and self.chain:IsState(data.state) then
		self.chain:GoTo(data.state)
	end
end


return StaticGenerator
