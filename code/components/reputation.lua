--We don't need no stinking _G.
BindGlobal()

--The compoment constructor.
local Reputation = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    self.factions = {}
end)

--Runs when reputation is increased or decreased for a specific faction.
function Reputation:OnDelta(faction)
	if self.factions[faction] then
		for k,v in pairs(self.factions[faction].stages) do
			if v.threshold <= self.factions[faction].reputation then
				v.callback()
			end 
		end
	end
end

--Increase reputation by a specific amount for a specific faction.
function Reputation:IncreaseReputation(faction, delta)
	if self.factions[faction] then
		if self.factions[faction].reputation + (delta) <= self.factions[faction].maxrep then
			self.factions[faction].reputation = (self.factions[faction].reputation + (delta)) <= self.factions[faction].maxrep
		else
			self.factions[faction].reputation = self.factions[faction].maxrep
		end
	end

	self:OnDelta(faction)
end

--Lower reputation by a specific amount for a specific faction.
function Reputation:LowerReputation(faction, delta)
	if self.factions.faction then
		if self.factions[faction].reputation + (delta) >= self.factions[faction].minrep then
			self.factions[faction].reputation = (self.factions[faction].reputation + (delta)) >= self.factions[faction].minrep
		else
			self.factions[faction].reputation = self.factions[faction].minrep
		end	
	end

	self:OnDelta(faction)
end

--Add a stage, threshold, and callback for a specific faction.
function Reputation:AddStage(callback, faction, stage, threshold)
	if not self.factions[faction].stages then
		self.factions[faction].stages = {}
	end
	self.factions[faction].stages[stage] = {callback = callback, threshold = threshold}
end

--Add a faction if it does not exist.
function Reputation:SetFaction(faction, baserep, minrep, maxrep)
	if not self.factions[faction] then
		self.factions[faction] = {reputation = baserep, minrep = minrep, maxrep = maxrep}
	end
end

--OnSave
function Reputation:OnSave()
    return self.factions
end

--OnLoad
function Reputation:OnLoad(data)
	if data then
    	self.factions = data.factions
    end
end

--Return our component.
return Reputation	