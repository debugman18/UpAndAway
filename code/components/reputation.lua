-- The component constructor.
local Reputation = HostClass(Debuggable, function(self, inst)
	self.inst = inst
    self.factions = nil
end)

-- Starts reputation decay for a given faction.
function Reputation:StartDecaying(faction)
	-- Better double check.
	assert(faction ~= nil)

	local rate = self.factions[faction].decay_rate
	local delay = self.factions[faction].decay_delay
	local trigger = self.factions[faction].decay_trigger

	if self.factions[faction].decay_task == nil then
       self.factions[faction].decay_task = self.inst:DoPeriodicTask(delay, function()

        	-- Shift towards a resting value.
    	    local delta = rate
    	    local old_reputation = self.factions[faction].reputation
    	    local resting_reputation = self.factions[faction].decay_resting

		    if old_reputation > resting_reputation then
		        delta = -delta
		    end

		    if delta < 0 then
		    	self:LowerReputation(faction, delta, trigger)
		    else
		    	self:IncreaseReputation(faction, delta, trigger)
		    end
        end)
    end
end

-- Stops reputation decay for a given faction.
function Reputation:StopDecaying(faction)
    if self.decay_task then
        self.decay_task:Cancel()
        self.decay_task = nil
    end
end

-- Returns the current reputation of a given faction.
function Reputation:GetReputation(faction)
	return self.factions[faction].reputation
end

-- Changes whether or not a given faction's reputation can decay.
function Reputation:SetDecay(faction, boolean)
	self.factions[faction].decay = boolean
	if boolean == false then
		self:StopDecaying()
	else
		self:StartDecaying()
	end
end

-- Changes values related to decay.
function Reputation:SetDecayRate(faction, decay_rate, decay_delay, decay_trigger, decay_resting)
	self.factions[faction].decay_rate = decay_rate or 1
	self.factions[faction].decay_delay = decay_delay or 60
	self.factions[faction].decay_trigger = decay_trigger or true
	self.factions[faction].decay_resting = decay_resting or 0
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

-- Increase or decrease reputation by a specific amount for a specific faction.
function Reputation:DoDelta(faction, delta, trigger, permanent)
	TheMod:DebugSay("Changing the reputation of the " .. faction .. " faction by " .. delta .. " points.")

	-- We shouldn't be changing a faction that doesn't exist.
	assert(faction ~= nil)

	-- Do the math.
	self.factions[faction].reputation = self.factions[faction].reputation + delta

	-- Whether or not to trigger a stage callback.
	if delta >= 0 and trigger and self.factions[faction].trigger_positive then
		self:OnDelta(faction, true)
	elseif delta <0 and trigger and self.factions[faction].trigger_negative then
		self:OnDelta(faction, false)
	end

	-- Will not go above the ceiling.
    if self.factions[faction].reputation >= self.factions[faction].maxrep then
        self.factions[faction].reputation = self.factions[faction].maxrep
    end

    -- Will not go below the floor.
    if self.factions[faction].reputation <= self.factions[faction].minrep then
        self.factions[faction].reputation = self.factions[faction].minrep
    end

    -- Permanently increase the resting reputation.
    if permanent and self.factions[faction].decay then
		local decay_rate = self.factions[faction].decay_rate
		local decay_delay = self.factions[faction].decay_delay
		local decay_trigger = self.factions[faction].decay_trigger
		local decay_resting = self.factions[faction].decay_resting + delta
		
		self:SetDecayRate(faction, decay_rate, decay_delay, decay_trigger, decay_resting)
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
function Reputation:AddFaction(faction, baserep, minrep, maxrep, decay_resting)
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

			-- The rate at which reputation decays.
			decay_rate = 0, --Default to nothing.

			-- The delay between each decay task.
			decay_delay = 60, --Default to a minute.

			-- Whether or not decay will trigger triggers.
			decay_trigger = true,

			-- What reputation value to decay towards.
			decay_resting = decay_resting or 0

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
