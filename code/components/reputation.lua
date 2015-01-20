-- The component constructor.
local Reputation = HostClass(Debuggable, function(self, inst)
	self.inst = inst
    self.factions = nil
end)

-- Returns the current reputation of a given faction.
function Reputation:GetReputation(faction)
	return self.factions[faction].reputation
end

-- Changes whether or not a given faction's reputation can decay.
function Reputation:SetDecay(faction, boolean)
	self.factions[faction].decay = boolean
	if boolean == false then
		--StopDecaying()
	else
		--StartDecaying()
	end
end

-- Changes values related to decay.
function Reputation:SetDecayRate(faction, decay_negative, decay_rate, decay_delay)
	self.factions[faction].decay_negative = decay_negative
	self.factions[faction].decay_rate = decay_rate
	self.factions[faction].decay_delay = decay_delay
end

-- Changes minimum reputation value.
function Reputation:SetMin(faction, minrep)
	self.factions[faction].minrep = minrep
end

-- Changes maximum reputation value.
function Reputation:SetMax(faction, maxrep)
	self.factions[faction].maxrep = maxrep
end

-- Changes whether or not reputation change can trigger callbacks.
function Reputation:SetTrigger(faction, trigger_negative, trigger_positive)
	self.factions[faction].trigger_negative = trigger_negative
	self.factions[faction].trigger_positive = trigger_positive
end

-- Changes whether or not a threshold will trigger callbacks.
function Reputation:SetStageTrigger(faction, stage, trigger_negative, trigger_positive)
	print(faction)
	print(stage)
	print(stage.trigger_negative)
	print(stage.trigger_positive)
	self.factions[faction].stages[stage].trigger_negative = trigger_negative
	self.factions[faction].stages[stage].trigger_positive = trigger_positive
end

-- Runs when reputation is increased or decreased for a specific faction.
function Reputation:OnDelta(faction, positive)
	if self.factions[faction] then
		for k,v in pairs(self.factions[faction].stages) do
			if positive then
				if v.threshold <= self.factions[faction].reputation then
					if v.trigger_positive then
						self:SetStageTrigger(faction, k, false, false)
						v.callback()
					end
				end 
			else
				if v.threshold >= self.factions[faction].reputation then
					if v.trigger_negative then
						self:SetStageTrigger(faction, k, false, false)
						v.callback()
					end
				end 
			end
		end
	end
end

-- Increase reputation by a specific amount for a specific faction.
function Reputation:IncreaseReputation(faction, delta, trigger)
	TheMod:DebugSay("Increasing the reputation of the " .. faction .. " faction by " .. delta .. " points.")
	if self.factions[faction] then
		if self.factions[faction].reputation + delta <= self.factions[faction].maxrep then
			self.factions[faction].reputation = self.factions[faction].reputation + delta
		else
			self.factions[faction].reputation = self.factions[faction].maxrep
		end
	end

	-- Whether or not to trigger a stage callback.
	if trigger and self.factions[faction].trigger_positive then
		self:OnDelta(faction, true)
	end

	-- Stops decay if necessary.
	if not self.factions[faction].decay_negative then
	    if self.factions[faction].reputation >= self.factions[faction].maxrep then
	        --StopDecaying()
	    end
	end

	TheMod:DebugSay("The new reputation of the " .. faction .. " faction is " .. self.factions[faction].reputation .. " points.")
end

-- Lower reputation by a specific amount for a specific faction.
function Reputation:LowerReputation(faction, delta, trigger)
	TheMod:DebugSay("Lowering the reputation of the " .. faction .. " faction by " .. delta .. " points.")
	if self.factions[faction] then
		if self.factions[faction].reputation - delta >= self.factions[faction].minrep then
			self.factions[faction].reputation = self.factions[faction].reputation - delta
		else
			self.factions[faction].reputation = self.factions[faction].minrep
		end	
	end

	-- Whether or not to trigger a stage callback.
	if trigger and self.factions[faction].trigger_negative then
		self:OnDelta(faction, false)
	end

	-- Stops decay if necessary.
	if self.factions[faction].decay_negative then
	    if self.factions[faction].reputation >= self.factions[faction].minrep then
	        --StopDecaying()
	    end
	end

	TheMod:DebugSay("The new reputation of the " .. faction .. " faction is " .. self.factions[faction].reputation .. " points.")
end

-- Add a stage, threshold, and callback for a specific faction.
function Reputation:AddStage(faction, stage, threshold, callback)
	if not self.factions[faction].stages then
		self.factions[faction].stages = {}
	end
	if not self.factions[faction].stages[stage] then
		TheMod:DebugSay("Adding the " .. stage .. " stage to the " .. faction .. " faction.")
		self.factions[faction].stages[stage] = {callback = callback, threshold = threshold, trigger_positive = true, trigger_negative = true}
	end
end

-- Add a faction if it does not exist.
function Reputation:AddFaction(faction, baserep, minrep, maxrep)
	if not self.factions then
		self.factions = {}
	end
	if not self.factions[faction] then
		TheMod:DebugSay("Adding the " .. faction .. " faction.")
		self.factions[faction] = {

			-- The base reputation value.
			reputation = baserep, 

			-- The minimum reputation value.
			minrep = minrep, 

			-- The maximum reputation value.
			maxrep = maxrep, 

			-- Whether or not reputation will decay.
			decay = false, 

			-- Whether or not the decay is negative.
			decay_negative = true, 

			-- The rate at which reputation decays.
			decay_rate = 0,

			-- The delay between each decay task.
			decay_delay = 0,

			-- The decay task.
    		decaying_task = nil,

    		-- Time till next decay.
    		next_decay = nil,

			-- Whether or not reputation decreases trigger callbacks.
			trigger_negative = true,

			-- Whether or not reputation increases trigger callbacks.
			trigger_positive = true,

		}
	end
end

-- Makes a deep copy of a table.
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- OnSave
function Reputation:OnSave()
	local data = {}
	if self.factions then
		data.factions = deepcopy(self.factions)
    end
    return data
end

-- OnLoad
function Reputation:OnLoad(data)
	if data and data.factions then
    	self.factions = deepcopy(data.factions)
    end
end

-- Return our component.
return Reputation	