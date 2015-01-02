local Pred = wickerrequire "lib.predicates"

-- Distance from trigger player.
local GIANT_SPAWN_DIST = 40

-- Minimum distance from any player.
local MIN_GIANT_SPAWN_DIST = 32

---

local function IsBeanlet(inst)
    return inst:HasTag("beanlet")
end

local function OnKillAny(inst, data)
    if inst.components.beanhated then
        if data.victim and inst.components.beanhated.isbeanletfn(data.victim) then
            inst.components.beanhated:IncreaseHate(1)
        end
    end
end

local BeanHated = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "BeanHated", true)

    self:SetConfigurationKey("BEANHATED")

    self.giant_prefab = "bean_giant"
    self.isbeanletfn = IsBeanlet

    self.hate = 0

    self.decaying_task = nil
    self.next_decay = nil

    self.inst:ListenForEvent("killed", OnKillAny)
end)

---

function BeanHated:SetGiantPrefab(prefab)
    self.giant_prefab = prefab
end

function BeanHated:SetIsBeanletFn(fn)
    self.isbeanletfn = fn
end

function BeanHated:IsDecaying()
    return self.decaying_task ~= nil
end

---

local function StopDecaying(self)
    if self.decaying_task then
        self.decaying_task:Cancel()
        self.decaying_task = nil
    end
    self.next_decay = nil
end

local function doDecay(inst)
    local self = inst.components.beanhated
    if not self then return end

    self.hate = self.hate - 1

    if self.hate <= 0 then
        self.hate = 0
        StopDecaying(self)
    else
        self.next_decay = _G.GetTime() + self:GetConfig("DECAY_DELAY")
    end
end

local function StartDecaying(self, next_decay_delay)
    local delay = self:GetConfig("DECAY_DELAY")
    next_decay_delay = next_decay_delay or delay

    StopDecaying(self)

    self.decaying_task = self.inst:DoPeriodicTask(delay, doDecay, next_decay_delay)
    self.next_decay = _G.GetTime() + next_decay_delay
end

local function NewSpawnPointTester(center)
    local players = Game.FindAllPlayersInRange(center, 2*MIN_GIANT_SPAWN_DIST)

    local mindistsq = MIN_GIANT_SPAWN_DIST*MIN_GIANT_SPAWN_DIST

    return function(offset)
        local pt = center + offset
        for _, p in ipairs(players) do
            if p:GetDistanceSqToPoint(center) < mindistsq then
                return false
            end
        end
        return Pred.IsClearPath(pt, center, false)
    end
end

---

function BeanHated:IncreaseHate(amount)
    self.hate = self.hate + (amount or 1)

    if self.hate >= self:GetConfig("THRESHOLD") then
        self:SpawnGiant()
    end

    if self.hate > 0 then
        if not self:IsDecaying() then
            StartDecaying(self)
        end
    else
        self.hate = 0
        StopDecaying(self)
    end
end

function BeanHated:GetSpawnPt()
    local center = self.inst:GetPosition()

    local offset = _G.FindValidPositionByFan(2*math.pi*math.random(), GIANT_SPAWN_DIST, 24, NewSpawnPointTester(center))

    if offset then
        return center + offset
    end
end

function BeanHated:SpawnGiant()
    local pt = self:GetSpawnPt()
    if pt then
        local giant = SpawnPrefab(self.giant_prefab)
        if giant then
            self.hate = math.max(0, self.hate - self:GetConfig("THRESHOLD"))

            Game.Move(giant, pt)
            if giant.components.combat and self.inst.components.combat then
                giant.components.combat:SetTarget(self.inst)
            end
        end
    end
end

---

function BeanHated:OnSave()
    if self.hate > 0 then
        return {
            hate = self.hate,
            delay = self.next_decay - _G.GetTime(),
        }
    end
end

function BeanHated:OnLoad(data)
    if data and data.hate then
        self.hate = data.hate
        if self.hate > 0 then
            StartDecaying(self, data.delay)
        end
    end
end


return BeanHated
