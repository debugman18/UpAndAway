local ondirty_handler

local startrequest_handler
local finishrequest_handler

---

local ClimbingManager = Class(Debuggable, function(self, inst)
	assert( TheWorld )

	if IsDST() then
		assert( inst == TheWorld.net )
	else
		assert( inst == TheWorld )
	end

	self.inst = inst
	Debuggable._ctor(self, "ClimbingManagerReplica")

	self:SetConfigurationKey "CLIMBING_MANAGER"

	---

	self.startrequest_callbacks = FunctionQueue()
	self.finishrequest_callbacks = FunctionQueue()

	---

	self.last_dirty_tick = -math.huge

	self.net_targetinst = NetEntity(inst, "climbingmanager.targetinst")
	self.net_targetinst:AddOnDirtyFn(ondirty_handler)
	self.net_totalplayers = NetUByte(inst, "climbingmanager.total_players")
	self.net_totalplayers:AddOnDirtyFn(ondirty_handler)
	self.net_minplayers = NetUByte(inst, "climbingmanager.min_players")
	self.net_minplayers:AddOnDirtyFn(ondirty_handler)
	self.net_agreeableplayers = NetUByte(inst, "climbingmanager.agreeable_players")
	self.net_agreeableplayers:AddOnDirtyFn(ondirty_handler)
	self.net_disagreeableplayers = NetUByte(inst, "climbingmanager.disagreeable_players")
	self.net_disagreeableplayers:AddOnDirtyFn(ondirty_handler)

	self.net_startrequest = NetSignal(inst, "climbingmanager.start_request")
	self.net_startrequest:Connect(startrequest_handler)
	self.net_finishrequest = NetSignal(inst, "climbingmanager.finish_request")
	self.net_finishrequest:Connect(finishrequest_handler)
end)

---

function ClimbingManager:GetTargetEntity()
	return self.net_targetinst.value
end

function ClimbingManager:GetTotalPlayers()
	return self.net_totalplayers.value
end

function ClimbingManager:GetMinimumPlayers()
	return self.net_minplayers.value
end

function ClimbingManager:GetAgreeablePlayers()
	return self.net_agreeableplayers.value
end

function ClimbingManager:GetDisagreeablePlayers()
	return self.net_disagreeableplayers.value
end

function ClimbingManager:GetUndecidedPlayers()
	return self:GetTotalPlayers() - (self:GetAgreeablePlayers() + self:GetDisagreeablePlayers())
end

function ClimbingManager:GetRemainingPlayers()
	return math.max(0, self:GetMinimumPlayers() - self:GetAgreeablePlayers())
end

---

local get_poll_data = (function()
	local methods = {}
	local meta = { __index = methods }

	local function get_action_string(target)
		local climbable = assert( replica(target).climbable )
		return "climb "..climbable:GetDirectionString():lower()
	end

	local function get_target_name(target)
		local ret = nil

		local prefab = target.prefab
		if prefab then
			ret = STRINGS.NAMES[prefab:upper()]
		end

		if ret == nil then
			ret = prefab
		end
		
		return ret or "???"
	end

	local function get_poll_results(data)
		-- to fail the motion.
		local min_disagreeing = data.total - data.min + 1

		if data.remaining <= 0 then
			return "PASSED"
		elseif data.disagreeable >= min_disagreeing then
			return "FAILED"
		else
			return table.concat({
				data.agreeable.."/"..data.min.." yeas",
				data.disagreeable.."/"..min_disagreeing.." nays",
				data.undecided.. " undecided",
			}, ", ")
		end
	end

	local required_announce_data = {"target", "total", "min", "agreeable", "disagreeable", "undecided", "remaining"}

	if IsDST() then
		function methods.announce(data)
			local TheNet = assert( _G.TheNet )

			for _, k in ipairs(required_announce_data) do
				if data[k] == nil then return end
			end

			local target = assert( data.target )
			if not replica(target).climbable then return end

			TheNet:Announce("Motion to "..get_action_string(target).." "..get_target_name(target)..": "..get_poll_results(data)..".")
		end
	else
		methods.announce = Lambda.Nil
	end

	function meta.__tostring(data)
		return ("{agreeable = %d, disagreeable = %d, undecided = %d, min = %d}"):format(data.agreeable or 0, data.disagreeable or 0, data.undecided or 0, data.min or 0)
	end

	return function(self)
		return setmetatable({
			target = self:GetTargetEntity(),
			total = self:GetTotalPlayers(),
			min = self:GetMinimumPlayers(),
			agreeable = self:GetAgreeablePlayers(),
			disagreeable = self:GetDisagreeablePlayers(),
			undecided = self:GetUndecidedPlayers(),
			remaining = self:GetRemainingPlayers(),
		}, meta)
	end
end)()

-- doesn't include the target.
local function get_poll_data_str(self)
	return tostring(get_poll_data(self))
end

ClimbingManager.GetPollData = get_poll_data

---

function ClimbingManager:AddStartRequestCallback(fn)
	assert( Pred.IsCallable(fn) )
	table.insert(self.startrequest_callbacks, fn)
end

function ClimbingManager:AddFinishRequestCallback(fn)
	assert( Pred.IsCallable(fn) )
	table.insert(self.finishrequest_callbacks, fn)
end

---

if not IsHost() then
	ClimbingManager.Broadcast = Lambda.Error("The function ClimbingManager:Broadcast() should only be callled on the host.")
else
	function ClimbingManager:Broadcast()
		local cm = assert( self.inst.components.climbingmanager )

		self.net_targetinst.value = cm:GetTargetEntity()
		self.net_totalplayers.value = cm:GetTotalPlayers()
		self.net_minplayers.value = cm:GetMinimumPlayers()
		self.net_agreeableplayers.value = cm:GetAgreeablePlayers()
		self.net_disagreeableplayers.value = cm:GetDisagreeablePlayers()
	end
end

function ClimbingManager:OnStartRequest()
	self:DebugSay "OnStartRequest()"
	self.net_startrequest()
end

function ClimbingManager:OnFinishRequest()
	self:DebugSay "OnFinishRequest()"
	self.net_finishrequest()
end

---

ondirty_handler = function(inst)
	local self = replica(inst).climbingmanager
	local tick = GetTick()
	if tick > self.last_dirty_tick then
		self.last_dirty_tick = tick
		self.inst:DoTaskInTime(0, function()
			self:Say("Received poll broadcast.")
			self:Say("Current poll data: ", get_poll_data_str(self))
		end)
	end
end

startrequest_handler = function(inst)
	local self = replica(inst).climbingmanager
	self:Say("Received new climbing request.")
	self.startrequest_callbacks(get_poll_data(self))
end

finishrequest_handler = function(inst)
	local self = replica(inst).climbingmanager
	self:Say("Done polling current climbing request.")
	self.finishrequest_callbacks(get_poll_data(self))
end

---

return ClimbingManager
