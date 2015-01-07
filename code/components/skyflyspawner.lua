-- This components acts locally on each client.

local Pred = wickerrequire "lib.predicates"

local game = wickerrequire "utils.game"
local Game = game


local Debuggable = wickerrequire "adjectives.debuggable"

---
-- Component for spawning things on flowers.
--
-- @author simplex
--
-- @class table
-- @name SkyflySpawner
local SkyflySpawner = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "SkyflySpawner")

    self:SetConfigurationKey("SKYFLYSPAWNER")

    self.prefab = "skyflies"
    self.max_flies = 4
    self.delay = 10
    self.min_distance = 6
    self.max_distance = 25
    self.min_spread = 1

    self.shouldspawnfn = nil

    -- Maps flies to "onremove" callbacks.
    self.flies = {}
    self.numflies = 0

    self.is_persistent = true

    self.task = nil
end)


local tracked_events = {"entitysleep", "enterlimbo", "onremove"}

---
-- Sets the fly prefab.
function SkyflySpawner:SetFlyPrefab(prefab)
    self.prefab = prefab
end

---
-- Sets the fly cap.
function SkyflySpawner:SetMaxFlies(n)
    self.max_flies = n
end

---
-- Sets the delay between spawns.
--
-- @param dt A positive number or a function, receiving self.inst and
-- returning the delay.
function SkyflySpawner:SetDelay(dt)
    assert( Pred.IsPositiveNumber(dt) or Pred.IsCallable(dt) )
    self.delay = dt
end

---
-- Returns the delay, possibly calling the configured one.
function SkyflySpawner:GetDelay()
    return Pred.IsNumber( self.delay ) and self.delay or self.delay(self.inst)
end

---
-- Minimum distance from player to spawn.
function SkyflySpawner:SetMinDistance(ds)
    self.min_distance = ds
end

---
-- Maximum distance from player to spawn.
function SkyflySpawner:SetMaxDistance(ds)
    self.max_distance = ds
end

---
-- Minimum distance between flies.
function SkyflySpawner:SetMinFlySpread(ds)
    self.min_spread = ds
end

---
-- Sets the function called to determine whether a skyfly should be spawned
-- or not.
--
-- @param fn The predicate function.
function SkyflySpawner:SetShouldSpawnFn(fn)
    assert( fn == nil or Pred.IsCallable(fn) )
    self.shouldspawnfn = fn
end

---
-- Sets whether entities spawned should be kept across reloading.
--
-- @param b A boolean.
function SkyflySpawner:SetPersistence(b)
    self.is_persistent = b
end

---
-- @description Adds a fly to the tracking list, if it's not there already.
-- 
-- Sets up "entitysleep" and "enterlimbo" callbacks for removing it.
function SkyflySpawner:Track(fly)
    if self.flies[fly] then return end
    self:DebugSay("Tracking [", fly, "]")

    if not self.is_persistent then
        fly.persists = false
    end

    self.flies[fly] = function(fly)
        if self.flies[fly]  then
            self:Untrack(fly)
            self:DebugSay("Removing [", fly, "]")
            fly:Remove()
        end
    end

    self.numflies = self.numflies + 1

    for _, event in ipairs(tracked_events) do
        self.inst:ListenForEvent(event, self.flies[fly], fly)
    end
end

---
-- @description Removes a fly from the tracking list.
--
-- Removes the event listeners.
function SkyflySpawner:Untrack(fly)
    if not self.flies[fly] then return end
    self:DebugSay("Untracking [", fly, "]")

    if not self.is_persistent then
        fly.persists = true
    end

    for _, event in ipairs(tracked_events) do
        self.inst:RemoveEventCallback(event, self.flies[fly], fly)
    end

    self.flies[fly] = nil
    self.numflies = self.numflies - 1
    self:Touch()
end

function SkyflySpawner:OnSave()
    self:DebugSay("OnSave")

    if not self.is_persistent then return end

    local saved = false

    local flies = {}
    for fly in pairs(self.flies) do
        if fly:IsValid() and not fly:IsInLimbo() then
            table.insert(flies, fly.GUID)
            saved = true
        end
    end

    if saved then
        return {flies = flies}, flies
    end
end

function SkyflySpawner:LoadPostPass(newents, savedata)
    self:DebugSay("LoadPostPass")

    if savedata and savedata.flies then
        local to_track = {}

        for _, GUID in pairs(savedata.flies) do
            local inst = newents[GUID] and newents[GUID].entity
            if inst then
                if not self.is_persistent then
                    inst:Remove()
                elseif inst.prefab == self.prefab then
                    table.insert(to_track, inst)
                end
            end
        end

        self.inst:DoTaskInTime(0, function()
            for _, fly in ipairs(to_track) do
                self:Track(fly)
            end
        end)
    end

    self:Reboot()
end

---
-- Sets up the spawning task.
function SkyflySpawner:StartSpawning()
    if self.task then return end

    self:DebugSay("StartSpawning")

    self.task = self.inst:DoTaskInTime(self:GetDelay(), function()
        self.task = nil
        self:TrySpawn()
        self:Touch()
    end)
end

---
-- Stops the spawning task, if any.
function SkyflySpawner:StopSpawning()
    if self.task then
        self:DebugSay("StopSpawning")
        self.task:Cancel()
        self.task = nil
    end
end

---
-- Starts or stops spawning according to the number of flies already
-- tracked.
function SkyflySpawner:Touch()
    self:DebugSay("Touch")

    if self.numflies < self.max_flies then
        self:StartSpawning()
    else
        self:StopSpawning()
    end
end

---
-- Stops spawning and then calls Touch().
function SkyflySpawner:Reboot()
    self:DebugSay("Reboot")

    self:StopSpawning()
    self:Touch()
end


---
-- Gets a flower to spawn a fly on.
function SkyflySpawner:GetSpawnFlower()
    local player = self.inst

    if not player then return end

    local minsq = self.min_distance*self.min_distance

    return Game.FindRandomEntity(
        player,
        self.max_distance,
        function(flower)
            return player:GetDistanceSqToInst(flower) >= minsq and not Game.FindSomeEntity(
                flower,
                self.min_spread,
                function(fly)
                    return fly.prefab == self.prefab
                end
            )
        end,
        {"flower"}
    )
end

function SkyflySpawner:TrySpawn()
    if self.numflies >= self.max_flies or (self.shouldspawnfn and not self.shouldspawnfn(self.inst)) then
        return
    end

    self:DebugSay("TrySpawn")

    local flower = self:GetSpawnFlower()
    if flower then
        local fly = SpawnPrefab(self.prefab)
        if fly then
            fly.Transform:SetPosition( flower:GetPosition():Get() )
            self:Track(fly)
            return fly
        end
    end

    self:DebugSay("TrySpawn failed")
end

---

function SkyflySpawner:OnRemoveFromEntity()
	for fly in pairs(self.flies) do
		fly.persists = false
		fly:DoTaskInTime(0.2 + 2*math.random(), function(fly)
			if fly:IsValid() then
				fly:Remove()
			end
		end)
	end
end

SkyflySpawner.OnRemoveEntity = SkyflySpawner.OnRemoveFromEntity

---

return SkyflySpawner
