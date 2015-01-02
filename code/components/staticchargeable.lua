

local Logic = wickerrequire "paradigms.logic"

local Pred = wickerrequire "lib.predicates"

local Debuggable = wickerrequire "adjectives.debuggable"


---
-- Simple component for handling static state transitions.
--
-- @author simplex
--
-- @class table
-- @name StaticChargeable
local StaticChargeable = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "StaticChargeable")

    self:SetConfigurationKey("STATICCHARGEABLE")

    self.charged = false

    self.charge_delay = nil
    self.uncharge_delay = nil

    self.state_release_task = nil
    self.state_release_targettime = nil
    self.toggle_states_on_release = nil

    local function charge_callback()
        inst:DoTaskInTime(self:GetOnChargedDelay() or 0, function(inst)
            local c = inst.components.staticchargeable
            if inst:IsValid() and c then
                c:Charge()
            end
        end)
    end

    local function uncharge_callback()
        inst:DoTaskInTime(self:GetOnUnchargedDelay() or 0, function(inst)
            local c = inst.components.staticchargeable
            if inst:IsValid() and c then
                c:Uncharge()
            end
        end)
    end

    inst:ListenForEvent("upandaway_charge", charge_callback, GetWorld())
    inst:ListenForEvent("upandaway_uncharge", uncharge_callback, GetWorld())

    function self:OnRemoveFromEntity()
        self.inst:RemoveEventCallback("upandaway_charge", charge_callback, GetWorld())
        self.inst:RemoveEventCallback("upandaway_uncharge", uncharge_callback, GetWorld())
    end

    inst:DoTaskInTime(0, function(inst)
        local sgen = GetStaticGenerator()
        if sgen and sgen:IsCharged() then
            local c = inst.components.staticchargeable
            if inst:IsValid() and c then
                c:Charge()
            end
        end
    end)
end)

---
-- Returns whether it is charged.
function StaticChargeable:IsCharged()
    return self.charged
end

---
-- Returns whether the current state is unaffected by the ambient.
function StaticChargeable:IsInHeldState()
    assert( Logic.IfAndOnlyIf(self.state_release_task == nil, self.state_release_targettime == nil) )
    return self.state_release_task and true or false
end

--
-- Lists aliases of methods.
--
-- These are implemented both for convenience and to avoid crashes due to
-- simple typos.
--
local aliases = {
    OnCharged = {
        "OnCharge",
        "Charged",
        "Charge",
    },
    OnUncharged = {
        "OnUncharge",
        "Uncharged",
        "Uncharge",
    },
}


---
-- Returns the oncharge callback.
--
function StaticChargeable:GetOnChargedFn(fn)
    return self.onchargedfn
end

---
-- Sets the oncharge callback.
--
function StaticChargeable:SetOnChargedFn(fn)
    self.onchargedfn = fn
end

---
-- Returns the onuncharge callback.
--
function StaticChargeable:GetOnUnchargedFn(fn)
    return self.onunchargedfn
end

---
-- Sets the onuncharge callback.
--
function StaticChargeable:SetOnUnchargedFn(fn)
    self.onunchargedfn = fn
end

---
-- Returns the oncharge delay as a number.
function StaticChargeable:GetOnChargedDelay()
    return Pred.IsCallable(self.charge_delay) and self.charge_delay() or self.charge_delay
end

---
-- Sets the oncharge delay.
-- Can be a function.
function StaticChargeable:SetOnChargedDelay(delay)
    self.charge_delay = delay
end

---
-- Returns the onuncharge delay as a number.
function StaticChargeable:GetOnUnchargedDelay()
    return Pred.IsCallable(self.uncharge_delay) and self.uncharge_delay() or self.uncharge_delay
end

---
-- Sets the onuncharge delay.
-- Can be a function.
function StaticChargeable:SetOnUnchargedDelay(delay)
    self.uncharge_delay = delay
end


for basic_infix, tbl in pairs(aliases) do
    for _, access in ipairs{"Get", "Set"} do
        for _, suffix in ipairs{"Fn", "Delay"} do
            local primitive = assert( StaticChargeable[access .. basic_infix .. suffix] )
            for _, alias in ipairs(tbl) do
                StaticChargeable[access .. alias .. suffix] = primitive
            end
        end
    end
end


---
-- Charges if not already.
--
-- @param force Forces the charging, even if already charged.
function StaticChargeable:Charge(force)
    if not self.charged and not self:IsInHeldState() or force then
        --self:DebugSay("Charge()")
        self.toggle_states_on_release = nil
        self.charged = true
        if self.onchargedfn then
            self.onchargedfn(self.inst)
        end
    elseif self:IsInHeldState() then
        self.toggle_states_on_release = not self.charged
    end
end

---
-- Uncharges if not already.
--
-- @param force Forces the uncharging, even if already uncharged.
function StaticChargeable:Uncharge(force)
    if self.charged and not self:IsInHeldState() or force then
        --self:DebugSay("Uncharge()")
        self.toggle_states_on_release = nil
        self.charged = false
        if self.onunchargedfn then
            self.onunchargedfn(self.inst)
        end
    elseif self:IsInHeldState() then
        self.toggle_states_on_release = self.charged
    end
end

---
-- Toggles the state.
function StaticChargeable:Toggle(force)
    if self.charged then
        self:Uncharge(force)
    else
        self:Charge(force)
    end
end

---
-- Keeps the current state for a predetermined amount of time.
-- During that period, the state doesn't change with the ambient.
function StaticChargeable:HoldState(time)
    self:DebugSay("HoldState()")

    time = Pred.IsCallable(time) and time() or time
    assert( Pred.IsNumber(time) )

    local targettime = GetTime() + time
    if self.state_release_targettime and self.state_release_targettime >= targettime then
        return
    end
    self.state_release_targettime = targettime

    self:DebugSay("holding state for ", time, " seconds.")

    if self.state_release_task then
        self.state_release_task:Cancel()
    end

    self.state_release_task = self.inst:DoTaskInTime(time, function(inst)
        if inst.components.staticchargeable then
            inst.components.staticchargeable.state_release_task = nil
            inst.components.staticchargeable:ReleaseState()
        end
    end)
end

---
-- Reverses the effect of the KeepState.
function StaticChargeable:ReleaseState()
    self:DebugSay("ReleaseState()")

    self.state_release_targettime = nil
    if self.state_release_task then
        self.state_release_task:Cancel()
        self.state_release_task = nil

        if self.toggle_states_on_release then
            self:Toggle()
            self.toggle_states_on_release = nil
        end
    end
end

---
-- Returns the duration of the current state holding, and nil otherwise.
function StaticChargeable:GetStateHoldingDuration()
    return self.state_release_targettime and (self.state_release_targettime - GetTime())
end

---
-- @description Saves the charged state.
--
-- Tries to use as little savedata as possible, since we'll have a lot of
-- entities with this component.
function StaticChargeable:OnSave()
    return {
        c = self.charged and 1 or nil,
        hold_time = self:GetStateHoldingDuration(),
    }
end

---
-- @description Loads the charged state.
--
-- Calls Charge() or Uncharge() appropriately.
function StaticChargeable:OnLoad(data)
    if data then
        local charged = data.c
        if charged then
            self:Charge()
        else
            self:Uncharge()
        end

        if data.hold_time then
            self:HoldState(data.hold_time)
        end
    end
end


return StaticChargeable
