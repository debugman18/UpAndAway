local UniformVariable = wickerrequire "math.probability.randomvariable" .Uniform

---

local cfg = Configurable "CLIMBING_MANAGER"

local function proportional_test(p)
	local ceil = math.ceil
	return function(total, n)
		return ceil(p*total)
	end
end

local function all_but(k)
	return function(total)
		return total - k
	end
end

--[[
-- These are the available consensus modes.
--
-- Each is a function receiving the total number of players
-- and returning the minimum amount of players required to
-- approve the motion.
--]]
local consensus_modes = {
	UNANIMOUS = function(total)
		return total
	end,
	SIMPLE_MAJORITY = proportional_test(1/2),
	THREE_QUARTERS = proportional_test(3/4),
	NINETY_PERCENT = proportional_test(0.9),
	ALL_BUT_ONE = all_but(1),
	ALL_BUT_TWO = all_but(2),
	ALL_BUT_THREE = all_but(3),
}

---

local ClearPlayer

---

local ClimbingManager = Class(Debuggable, function(self, inst)
	assert( TheWorld )

	if IsDST() then
		assert( inst == TheWorld.net )
	else
		assert( inst == TheWorld )
	end

	self.inst = inst
	Debuggable._ctor(self, "ClimbingManager")

	self:SetConfigurationKey "CLIMBING_MANAGER"

	self:SetConsensusMode(cfg "CONSENSUS")

	self.current_request = nil
	self.last_request_time = -math.huge

	if IsDST() then
		TheWorld:ListenForEvent("playerdeactivated", function(_, player)
			ClearPlayer(self, player)
		end)
	end
end)

local GetTotalPlayers
if IsDST() then
	GetTotalPlayers = function()
		return #_G.AllPlayers
	end
else
	GetTotalPlayers = Lambda.One
end

---

function ClimbingManager:GetConsensusMode()
	return self.consensus
end

function ClimbingManager:SetConsensusMode(modename)
	local mode = consensus_modes[modename]
	if mode == nil then
		return error("Invalid consensus mode name '"..tostring(modename).."'", 2)
	end
	self.consensus = mode
end

function ClimbingManager:GetMinimumPlayers()
	return self.consensus(GetTotalPlayers())
end

function ClimbingManager:GetAgreeablePlayers()
	local r = self.current_request
	if r ~= nil then
		local n = 0
		for player, v in pairs(r.agreeing_set) do
			if v and player:IsValid() then
				n = n + 1
			end
		end
		return n
	end
	return 0
end

function ClimbingManager:GetDisagreeablePlayers()
	local r = self.current_request
	if r ~= nil then
		local n = 0
		for player, v in pairs(r.disagreeing_set) do
			if v and player:IsValid() then
				n = n + 1
			end
		end
		return n
	end
	return GetTotalPlayers()
end

function ClimbingManager:GetUndecidedPlayers()
	return GetTotalPlayers() - (self:GetAgreeablePlayers() + self:DisagreeablePlayers())
end

function ClimbingManager:GetRemainingPlayers()
	return math.max(0, self:GetMinimumPlayers() - self:GetAgreeablePlayers())
end

function ClimbingManager:GetTargetEntity()
	local r = self.current_request
	if r ~= nil then
		return r.target
	end
end

---

local function OnStopUpdating(self)
	if not self.updating_thread then
		return
	end

	if self:GetRemainingPlayers() <= 0 then
		local target = self:GetTargetEntity()
		if target and target:IsValid() then
			local climbable = target.components.climbable
			if climbable then
				climbable:Climb()
			end
		end
	end

	self.current_request = nil
end

local function StopUpdating(self)
	if self.updating_thread then
		CancelThread(self.updating_thread)
		OnStopUpdating(self)
		self.updating_thread = nil
	end
end

local function StartUpdating(self)
	StopUpdating(self)

	local delay_range = self:GetConfig "UPDATE_PERIOD"
	local get_delay = UniformVariable(delay_range[1], delay_range[2])

	local TIMEOUT = self:GetConfig "TIMEOUT"
	local t0 = GetTime()

	self.updating_thread = self.inst:StartThread(function()
		--[[
		repeat
			--TODO: actually doing something here.
			Sleep(get_delay())
		until GetTime() - t0 >= TIMEOUT
		]]--
		Sleep(TIMEOUT)
		StopUpdating(self)
	end)
end

---

local new_playerset = (function()
	local setmetatable = setmetatable

	local mt = {__mode = "k"}
	return function()
		return setmetatable({}, mt)
	end
end)()

function ClimbingManager:AddRequest(climbable_inst)
	if not Pred.IsValidEntity(climbable_inst) or not climbable_inst.components.climbable then
		self:Say("Request to climb [", climbable_inst, "] ignored. Invalid climbable target.")
		return false
	end

	if self.current_request == nil then
		local time_left = GetTime() - (self.last_request_time + self:GetConfig("COOLDOWN"))
		if time_left > 0 then
			self.current_request = {
				target = climbable_inst,
				agreeing_set = new_playerset(),
				disagreeing_set = new_playerset(),
			}
			StartUpdating(self)
			return true
		else
			self:Say("Request to climb [", climbable_inst, "] ignored. Still in cooldown for ", time_left, " seconds.")
		end
	else
		self:Say("Request to climb [", climbable_inst, "] ignored. Request already pending for [", self:GetTargetEntity(), "]")
	end

	return false
end

---

local function test_self(self)
	local total = GetTotalPlayers()

	local min_agreeable = self:GetMinimumPlayers()
	local max_disagreeable = total - min_agreeable

	local agreeable = self:GetAgreeablePlayers()
	local disagreeable = self:GetDisagreeablePlayers()

	if agreeable >= min_agreeable or disagreeable > max_disagreeable then
		StopUpdating(self)
	end
end

local function check_target(self, target)
	return target and target == self:GetTargetEntity()
end

function ClimbingManager:AddAgreeablePlayer(target, player)
	if not check_target(self, target) then
		TheMod:Say("Ignored agreement statement for mismatched target [", target, "].")
		return
	end

	local r = self.current_request
	if r ~= nil then
		r.agreeing_set[player] = true
		r.disagreeing_set[player] = nil
		test_self(self)
	end
end

function ClimbingManager:AddDisagreeablePlayer(target, player)
	if not check_target(self, target) then
		TheMod:Say("Ignored disagreement statement for mismatched target [", target, "].")
		return
	end

	local r = self.current_request
	if r ~= nil then
		r.agreeing_set[player] = nil
		r.disagreeing_set[player] = true
		test_self(self)
	end
end

ClearPlayer = function(self, player)
	local r = self.current_request
	if r ~= nil then
		r.agreeing_set[player] = nil
		r.disagreeing_set[player] = nil
		test_self(self)
	end
end

---

return ClimbingManager
