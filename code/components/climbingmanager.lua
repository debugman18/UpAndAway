local ClimbingManagerReplica = require "components/climbingmanager_replica"

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

	self:SetConsensusMode(self:GetConfig "CONSENSUS")

	self.current_request = nil
	self.last_request_time = -math.huge

	if IsDST() then
		TheWorld:ListenForEvent("playerdeactivated", function(_, player)
			ClearPlayer(self, player)
		end)
		TheWorld:ListenForEvent("playeractivated", function(_, player)
			self:Broadcast()
		end)
	end
end)

local get_player_id
if IsDST() then
	get_player_id = function(player)
		return player.userid
	end
else
	get_player_id = Lambda.One
end

local GetTotalPlayers
if IsDST() then
	local rawget = rawget
	local _G = _G
	GetTotalPlayers = function()
		local plist = rawget(_G, "AllPlayers")
		if plist ~= nil then
			return #plist
		else
			return 0
		end
	end
else
	GetTotalPlayers = Lambda.One
end

ClimbingManager.GetTotalPlayers = GetTotalPlayers

---

function ClimbingManager:GetConsensusMode()
	return self.consensus
end

function ClimbingManager:SetConsensusMode(modename)
	local consensus_modes = assert( self:GetConfig("CONSENSUS_MODES") )
	local mode = consensus_modes[modename]
	if mode == nil then
		local msg_pieces = {"Invalid consensus mode name '"..tostring(modename).."'.\nAvailable consensus modes are:"}
		for k in pairs(consensus_modes) do
			table.insert(msg_pieces, "    "..tostring(k))
		end
		return error(table.concat(msg_pieces, "\n"), 2)
	end
	self:Say("Setting consensus mode to '", modename, "'...")
	self.consensus = mode
end

function ClimbingManager:HasRequest()
	return self.current_request ~= nil
end

function ClimbingManager:GetMinimumPlayers()
	return math.max(1, self.consensus(GetTotalPlayers()))
end

local function count_player_set(set)
	local n = 0
	for player, v in pairs(set) do
		if v and player:IsValid() and get_player_id(player) ~= nil then
			n = n + 1
		end
	end
	return n
end

function ClimbingManager:GetAgreeablePlayers()
	local r = self.current_request
	if r ~= nil then
		return count_player_set(r.agreeing_set)
	end
	return 0
end

function ClimbingManager:GetDisagreeablePlayers()
	local r = self.current_request
	if r ~= nil then
		return count_player_set(r.disagreeing_set)
	end
	return GetTotalPlayers()
end

function ClimbingManager:GetUndecidedPlayers()
	return GetTotalPlayers() - (self:GetAgreeablePlayers() + self:GetDisagreeablePlayers())
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

function ClimbingManager:GetPollData()
	return ClimbingManagerReplica.GetPollData(self)
end

function ClimbingManager:AddStartRequestCallback(fn)
	return replica(self.inst).climbingmanager:AddStartRequestCallback(fn)
end

function ClimbingManager:AddFinishRequestCallback(fn)
	return replica(self.inst).climbingmanager:AddFinishRequestCallback(fn)
end

function ClimbingManager:Broadcast()
	self:GetPollData():announce()
	replica(self.inst).climbingmanager:Broadcast()
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
	self:OnFinishRequest()
end

local function StopUpdating(self, dont_cancel_thread)
	if self.updating_thread then
		if not dont_cancel_thread then
			CancelThread(self.updating_thread)
		end
		OnStopUpdating(self)
		self.updating_thread = nil
	end
end

local function StartUpdating(self)
	StopUpdating(self)

	local TIMEOUT = self:GetConfig "TIMEOUT"

	self.updating_thread = self.inst:StartThread(function()
		if TIMEOUT == math.huge then
			_G.Hibernate()
		else
			_G.Sleep(TIMEOUT)
		end
		StopUpdating(self, true)
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
		return false, "INVALID"
	end

	if self.current_request == nil then
		local now = GetTime()
		local cooldown
		if IsDST() then
			cooldown = assert( self:GetConfig("COOLDOWN") )
		else
			cooldown = 0
		end
		local time_left = now - (self.last_request_time + cooldown)
		if time_left > 0 then
			self.last_request_time = now
			self.current_request = {
				target = climbable_inst,
				agreeing_set = new_playerset(),
				disagreeing_set = new_playerset(),
			}
			StartUpdating(self)
			self:OnStartRequest()
			return true
		else
			self:Say("Request to climb [", climbable_inst, "] ignored. Still in cooldown for ", time_left, " seconds.")
			return false, "COOLDOWN"
		end
	else
		if self:GetTargetEntity() == climbable_inst then
			return true
		end

		self:Say("Request to climb [", climbable_inst, "] ignored. Request already pending for [", self:GetTargetEntity(), "]")
		return false, "INUSE"
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
		self:Broadcast()
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
		self:Broadcast()
		test_self(self)
	end
end

ClearPlayer = function(self, player)
	local r = self.current_request
	if r ~= nil then
		r.agreeing_set[player] = nil
		r.disagreeing_set[player] = nil
		self:Broadcast()
		test_self(self)
	end
end

function ClimbingManager:OnStartRequest()
	self:Broadcast()
	replica(self.inst).climbingmanager:OnStartRequest()
end

function ClimbingManager:OnFinishRequest()
	self:Broadcast()
	replica(self.inst).climbingmanager:OnFinishRequest()
end

---

return ClimbingManager
