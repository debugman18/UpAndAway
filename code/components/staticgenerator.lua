local Pred = wickerrequire "lib.predicates"

local Debuggable = wickerrequire "adjectives.debuggable"

local MarkovChain = wickerrequire "math.probability.markovchain"


-- In seconds.
local UPDATING_PERIOD = 2


---
-- Returns a new state transition function.
local function NewStateTransitionFunction(self)
    local events_map = {
        UNCHARGED = "upandaway_uncharge",
        CHARGED = "upandaway_charge",
    }

    return function(old, new)
        if self.inst:IsValid() then
            local event = assert( events_map[new] )
            if self:Debug() then
                self:Say("Pushing event ", ("%q"):format(event))
            end
            self.inst:PushEvent(event)

            local cooldown = self:GetCooldown()
            if cooldown then
                self:HoldState(cooldown)
            end
        end
    end
end

---
--
-- The StaticGenerator component.
-- <br />
-- Pushes the events "upandaway_charge", "upandaway_uncharge" and "upandaway_chargechange".
--
-- @author simplex
--
-- @class table
-- @name StaticGenerator
local StaticGenerator = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "StaticGenerator")

    self:SetConfigurationKey("STATIC")


    local chain = MarkovChain()
    chain:AddState("CHARGED")
    chain:AddState("UNCHARGED")
    chain:SetInitialState("NONE")
    chain:SetTransitionProbability("NONE", "UNCHARGED", 1)
    chain:SetTransitionFn(NewStateTransitionFunction(self))
    self.chain = chain

    self.cooldown = nil

    -- When to release the currently held state.
    -- nil if no state is being held.
    self.state_release_time = nil

    self.task = nil
end)


local function average_time_to_probability(dt)
    assert( Pred.IsPositiveNumber(dt) )
    return 1/math.ceil(dt/UPDATING_PERIOD)
end


---
-- Sets the average duration of the CHARGED state.
--
-- @param dt Average duration, in seconds.
function StaticGenerator:SetAverageChargedTime(dt)
    self.chain:SetTransitionProbability( "CHARGED", "UNCHARGED", average_time_to_probability(dt) )
end

---
-- Sets the average duration of the UNCHARGED state.
--
-- @param dt Average duration, in seconds.

function StaticGenerator:SetAverageUnchargedTime(dt)
    self.chain:SetTransitionProbability( "UNCHARGED", "CHARGED", average_time_to_probability(dt) )
end

---
-- Sets the cooldown for state transition updating.
--
-- @param dt Cooldown, in seconds.
function StaticGenerator:SetCooldown(dt)
    assert( dt == nil or Pred.IsNonNegativeNumber(dt), "Nil or non-negative number expected as cooldown." )
    self.cooldown = dt
end

---
-- Returns the cooldown, in seconds.
function StaticGenerator:GetCooldown()
    return self.cooldown
end

---
-- Returns whether the prefab is CHARGED.
--
-- @return A boolean, representing the state.
function StaticGenerator:IsCharged()
    return self.chain:GetState() == "CHARGED"
end

---
-- Starts updating the state transition.
function StaticGenerator:StartGenerating()
    if self:IsHoldingState() then return end

    if not self.task and self.inst:IsValid() then
        self.task = self.inst:DoPeriodicTask(UPDATING_PERIOD, function(inst)
            if inst:IsValid() and inst.components.staticgenerator then
                inst.components.staticgenerator.chain:Step()
            end
        end)
    end
end

---
-- Halts the updating of the state transition.
function StaticGenerator:StopGenerating()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

---
-- Handles long updates by simply going to the UNCHARGED state.
function StaticGenerator:LongUpdate(dt)
    if self.state_release_time then
        self.state_release_time = self.state_release_time - dt
        if self.state_release_time <= GetTime() then
            self:ReleaseState()
        else
            return
        end
    end
    self.chain:GoTo("UNCHARGED")
end

function StaticGenerator:IsHoldingState()
    if self.state_release_time then
        assert( self.state_release_time + _G.FRAMES/2 >= GetTime() )
        return true
    else
        return false
    end
end

function StaticGenerator:IsPermanentState()
    return self.state_release_time == math.huge
end

local function cancelReleaseTask(self)
    if self.releasetask then
        self.releasetask:Cancel()
        self.releasetask = nil
    end
end

---
-- Holds the state for the specified amount of seconds (which may be infinite).
function StaticGenerator:HoldState(dt)
    assert( Pred.IsNonNegativeNumber(dt), "Non-negative number expected as amount of seconds to hold state." )

    if not self.inst:IsValid() then return end

    local release_time = GetTime() + dt
    if self.state_release_time then
        if self.state_release_time < release_time then
            cancelReleaseTask(self)
        else
            return
        end
    end

    self:DebugSay("HoldState(", dt, ")")

    self.state_release_time = release_time

    self:StopGenerating()

    if self.state_release_time == math.huge then return end

    self.releasetask = self.inst:DoTaskInTime(dt, function(inst)
        local self = inst.components.staticgenerator
        if inst:IsValid() and self then
            self:ReleaseState()
        end
    end)
end

---
-- Releases the held state.
function StaticGenerator:ReleaseState()
    self:DebugSay("ReleaseState()")

    self.state_release_time = nil

    assert( not self:IsHoldingState() )
    self:StartGenerating()

    cancelReleaseTask(self)
end

--[[
-- These are just convenience functions, mostly for testing.
--]]

---
-- Goes to the CHARGED state.
function StaticGenerator:Charge(force)
    if not force and self:IsHoldingState() then return end

    self.chain:GoTo("CHARGED")
end

---
-- Goes to the UNCHARGED state.
function StaticGenerator:Uncharge(force)
    if not force and self:IsHoldingState() then return end

    self.chain:GoTo("UNCHARGED")
end

---
-- Goes to the other state.
function StaticGenerator:Toggle(force)
    if self:IsCharged() then
        self:Uncharge(force)
    else
        self:Charge(force)
    end
end


---
-- Saves the current state.
function StaticGenerator:OnSave()
    local release_delay
    if self.state_release_time then
        if self.state_release_time == math.huge then
            release_delay = -1
        else
            release_delay = math.max(0, self.state_release_time - GetTime())
        end
    end
    return {
        state = self.chain:GetState(),
        state_release_delay = release_delay,
    }
end

---
-- Loads the saved state and goes to it.
function StaticGenerator:LoadPostPass(newents, data)
    if not data then return end

    local state = data.state
    if type(state) == "string" then
        state = state:upper()
        if self.chain:IsState(state) then
            self.chain:GoTo(state)
        end
    end

    local release_delay = data.state_release_delay
    if release_delay then
        if release_delay < 0 then
            release_delay = math.huge
        end
        self:HoldState(release_delay)
    end
end


return StaticGenerator
