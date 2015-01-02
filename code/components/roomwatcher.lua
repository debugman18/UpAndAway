local Lambda = wickerrequire "paradigms.functional"

local Topo = wickerrequire "game.topology"

local FunctionQueue = wickerrequire "gadgets.functionqueue"


local RoomWatcher = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "RoomWatcher")
    self:SetConfigurationKey("ROOM_WATCHER")

    self.node = nil

    self.onchangeroom = FunctionQueue()

    self.wants_to_update = false
end)

--------

--[[
-- Receives, in order:
-- self.inst
-- The new room.
-- The old room.
--
-- The rooms are passed as their data table (second argument to AddRoom).
-- The old room may be nil.
--]]
function RoomWatcher:AddRoomChangeCallback(fn)
    table.insert(self.onchangeroom, fn)
end
RoomWatcher.AddOnChangeRoomFn = RoomWatcher.AddRoomChangeCallback

--------

function RoomWatcher:GetCachedNode()
    return self.node
end

function RoomWatcher:GetNode()
    local node = Topo.GetNodeAt(self.inst)
    self.node = node
    return node
end

RoomWatcher.GetCachedRoomId = Lambda.Compose(Topo.GetNodeId, RoomWatcher.GetCachedNode)
RoomWatcher.GetCachedRoomData = Lambda.Compose(Topo.GetNodeData, RoomWatcher.GetCachedNode)

RoomWatcher.GetRoomId = Lambda.Compose(Topo.GetNodeId, RoomWatcher.GetNode)
RoomWatcher.GetRoomData = Lambda.Compose(Topo.GetNodeData, RoomWatcher.GetNode)

--------

local function on_new_node(self, oldnode, newnode)
    local oldid, oldroom = Topo.GetNodeRoom(oldnode)
    local newid, newroom = Topo.GetNodeRoom(newnode)

    if self:Debug() then
        self:Say("Moved from room ", (oldid or "nil"), " to ", assert(newid), ".")
    end

    self.onchangeroom(self.inst, newroom, oldroom)
end

local function new_updater_thread(self)
    local MIN_WAIT, MAX_WAIT = 2, 3

    local WAIT_DELTA = MAX_WAIT - MIN_WAIT

    return self.inst:StartThread(function()
        local inst = self.inst
        local Sleep = _G.Sleep
        local math = math
        while inst:IsValid() do
            local oldnode = self:GetCachedNode()
            local newnode = self:GetNode()
            if newnode ~= oldnode then
                on_new_node(self, oldnode, newnode)
            end
            Sleep(MIN_WAIT + WAIT_DELTA*math.random())
        end
    end)
end

function RoomWatcher:IsUpdating()
    return self.thread ~= nil
end

function RoomWatcher:StartUpdating()
    self.wants_to_update = true
    if not self.thread then
        self:DebugSay("StartUpdating()")
        self.thread = new_updater_thread(self)
    end
end

function RoomWatcher:StopUpdating()
    self.wants_to_update = false
    if self.thread then
        self:DebugSay("StopUpdating()")
        CancelThread(self.thread)
        self.thread = nil
    end
end

--------

function RoomWatcher:OnEntitySleep()
    local wanted_to_update = self.wants_to_update or self:IsUpdating()
    self:StopUpdating()
    self.wants_to_update = wanted_to_update
end

function RoomWatcher:OnEntityWake()
    if self.wants_to_update then
        self:StartUpdating()
    end
end

function RoomWatcher:OnRemoveFromEntity()
    self:StopUpdating()
end

return RoomWatcher
