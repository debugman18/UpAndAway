local PersistentData = wickerrequire "gadgets.persistentdata"

local table = wickerrequire "utils.table"

---

local function invert_table(t)
	local u = {}
	for k, v in pairs(t) do
		u[v] = k
	end
	return u
end

local function remove_from_inverted_array(u, t, i0)
	u[t[i0]] = nil

	for i = i0 + 1, #t do
		local v = t[i]
		u[v] = u[v] - 1
	end
end

---

local TrackPlayer, UntrackPlayer
local ApplyTrackingMask

---

local OnDeleteUserSession = FunctionQueue()
if IsDST() and not IsWorldgen() then
	_G.DeleteUserSession = OnDeleteUserSession..assert(_G.DeleteUserSession)
end

local activated_players = setmetatable({}, {__mode = "k"})

local PlayerTracker = HostClass(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self, "UAPlayerTracker")

	if not IsDST() then
		return
	end

	self.player_id_list = {}
	self.player_id_idx = {}
	self.data = {}

	self.whitelist = {}
	self.whitelist_map = {}
	self.whitelist_dirty = false

	local function process_whitelist(whitelist)
		if whitelist == nil then return end

		self.whitelist = whitelist
		self.whitelist_map = invert_table(whitelist)

		ApplyTrackingMask(self, self.whitelist_map)
	end

	self.whitelist_file = nil

	self.inst:DoTaskInTime(0, function(inst)
		assert( inst == TheWorld )
		local meta = assert( inst.meta )

		self.whitelist_file = PersistentData("tracked_players_whitelist_"..meta.session_identifier, {})
		self.whitelist_file:Load(function(whitelist)
			process_whitelist(whitelist)
			self:Refresh()
		end)
	end)

	self.inst:ListenForEvent("playeractivated", function(inst, player)
		TrackPlayer(self, player)
		activated_players[player] = true
	end)
	self.inst:ListenForEvent("playerdeactivated", function(inst, player)
		TrackPlayer(self, player)
		activated_players[player] = nil
	end)
	table.insert(OnDeleteUserSession, function(player)
		UntrackPlayer(self, player)
	end)

	---

	_G.ResumeExistingUserSession = (function()
		local Resume = assert( _G.ResumeExistingUserSession )
		return function(data, guid, ...)
			Resume(data, guid, ...)
			if IsServer() then
				local player = _G.Ents[guid]
				if player ~= nil then
					self:Say("Fixing [", player, "] spawn position as a function of LEVEL x SESSION_ID...")

					local pos = self:GetPlayerData(player, "pos")
					if pos == nil or not Pred.IsValidPoint(player) then
						TheWorld.components.playerspawner:SpawnAtNextLocation(TheWorld, player)
					else
						TheWorld.components.playerspawner:SpawnAtLocation(TheWorld, player, pos.x or 0, pos.y or 0, pos.z or 0)
					end
				end
			end
		end
	end)()
end)

---

if not IsDST() or IsWorldgen() then
	return PlayerTracker
end

---

local tracked_data = {
	pos = function(player)
		local x, y, z = player.Transform:GetWorldPosition()
		if y == 0 then
			y = nil
		end
		return {x = x, y = y, z = z}
	end,
}

---

local function get_player_id(player)
	return player.userid
end

local function get_player_with_id(player_id)
	return Game.FindSomePlayer(function(player)
		return get_player_id(player) == player_id
	end)
end

local function update_player_data(self, player)
	local player_id = get_player_id(player)
	if player_id == nil then return end

	local idx = self.player_id_idx[player_id]
	if idx == nil then return end

	local data = self.data
	for k, v in pairs(tracked_data) do
		self:DebugSay("Updating '", k, "' data for [", player, "]...")

		local subdata = data[k]
		if subdata == nil then
			subdata = {}
			data[k] = subdata
		end
		subdata[idx] = v(player)
	end
end

function PlayerTracker:GetPlayerData(player, which)
	local player_id = get_player_id(player)
	if player_id ~= nil then
		local idx = self.player_id_idx[player_id]
		if idx ~= nil then
			return self.data[which][idx]
		end
	end
end

---

-- @param player is optional.
local function TrackPlayerId(self, player_id, player)
	local id_map = self.player_id_idx
	if id_map[player_id] == nil then
		local id_list = self.player_id_list

		local n = #id_list + 1
		id_list[n] = player_id
		id_map[player_id] = n

		if player == nil then
			player = get_player_with_id(player_id)
		end
		if player == nil then
			return error("No such player with user id '"..tostring(player_id).."'.")
		end
	end

	local whitelist_map = self.whitelist_map
	if whitelist_map[player_id] == nil then
		local whitelist = self.whitelist

		local n = #whitelist + 1
		whitelist[n] = player_id
		whitelist_map[player_id] = n

		self.whitelist_dirty = true
	end

	update_player_data(self, player)
end

TrackPlayer = function(self, player)
	local player_id = get_player_id(player)
	if player_id ~= nil then
		return TrackPlayerId(self, player_id, player)
	end
end

local function UntrackPlayerId(self, player_id)
	local id_map = self.player_id_idx
	local idx = id_map[player_id]
	if idx then
		local id_list = self.player_id_list
		remove_from_inverted_array(id_map, id_list, idx)
		table.remove(id_list, idx)

		for k, subdata in pairs(self.data) do
			table.remove(subdata, idx)
		end
	end

	local whitelist_map = self.whitelist_map
	local whitelist_idx = whitelist_map[player_id]
	if whitelist_idx then
		local whitelist = self.whitelist
		remove_from_inverted_array(whitelist_map, whitelist, whitelist_idx)
		table.remove(whitelist, whitelist_idx)

		self.whitelist_dirty = true
	end
end

UntrackPlayer = function(self, player)
	local player_id = get_player_id(player)
	if player_id ~= nil then
		return UntrackPlayerId(self, player_id)
	end
end

---
-- AND's the tracked ids with the mask.
-- Does not change the whitelist.
--
-- @param mask a set of player ids.
ApplyTrackingMask = function(self, mask)
	local id_list = self.player_id_list
	local id_map = self.player_id_idx

	local keys_to_keep = {}

	for player_id, v in pairs(mask) do
		if v then
			local idx = id_map[player_id]
			if idx then
				keys_to_keep[idx] = true
			end
		end
	end

	if next(keys_to_keep) == nil then return end

	local function filter(_, i)
		return keys_to_keep[i]
	end

	table.TrimArray(id_list, filter)

	for k, subdata in pairs(self.data) do
		table.TrimArray(subdata, filter)
	end

	self.player_id_idx = invert_table( id_list )
end

---

function PlayerTracker:Refresh()
	for _, player in ipairs(Game.FindAllPlayers()) do
		TrackPlayer(self, player)
	end
end

---

function PlayerTracker:OnLoad(savedata)
	if not savedata then return end

	self.player_id_list = savedata.ids or {}
	self.player_id_idx = invert_table(self.player_id_list)

	self.data = savedata.data or {}
end

function PlayerTracker:OnSave()
	self:Refresh()
	if self.whitelist_file ~= nil and self.whitelist_dirty then
		self.whitelist_file:Save(function()
			self.whitelist_dirty = false
		end)
	end
	return {
		ids = self.player_id_list,
		data = self.data,
	}
end

---

return PlayerTracker
