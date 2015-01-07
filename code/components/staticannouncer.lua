local RegisterBroadcastEvent = wickerrequire "plugins.broadcastevents"

---

local assert = assert

---

local function AddAnnouncer(self, base_event_name)
	local inst = assert( self.inst )
	local event_name = base_event_name.."_broadcast"

	RegisterBroadcastEvent(inst, event_name)

	if IsServer() then
		inst:ListenForEvent(base_event_name, function()
			self:DebugSay("Broadcasting event '", event_name, "'.")
			ServerRPC.PushBroadcastEvent(inst, event_name)
		end, TheWorld)
	end
	inst:ListenForEvent(event_name, function(inst)
		assert( TheWorld )
		if inst ~= TheWorld then
			self:DebugSay("Repushing event '", event_name, "' under entity [", TheWorld, "].")
			TheWorld:PushEvent(event_name)
		end
	end)
end

---

-- This goes on clients as well (without a replica).
local StaticAnnouncer = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self, "StaticAnnouncer")

	self:SetConfigurationKey "STATIC_ANNOUNCER"

	assert( TheWorld )

	AddAnnouncer(self, "upandaway_charge")
	AddAnnouncer(self, "upandaway_uncharge")

	self.inst:DoTaskInTime(0, function()
		if IsDST() then
			assert( self.inst == TheWorld.net )
		else
			assert( self.inst == TheWorld )
		end
	end)
end)

return StaticAnnouncer
