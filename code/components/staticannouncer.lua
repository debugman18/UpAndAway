local RegisterBroadcastEvent = wickerrequire "plugins.broadcastevents"

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
	else
		inst:ListenForEvent(event_name, function(inst)
			if inst ~= TheWorld then
				self:DebugSay("Translating event '", event_name, "' to '", base_event_name, "' over [", TheWorld, "].")
				TheWorld:PushEvent(base_event_name)
			end
		end)
	end
end

---

-- This goes on clients as well (without a replica).
local StaticAnnouncer = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self, "StaticAnnouncer")

	self:SetConfigurationKey "STATIC_ANNOUNCER"

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
