local Perishable = require "components/perishable"
local Pred = wickerrequire "lib.predicates"

local FlexiblePerishable = Class(Perishable, function(self, inst)
    Perishable._ctor(self, inst)

    self.rate = 1
end)

function FlexiblePerishable:SetRate(r)
    assert( Pred.IsNumber(r) or Pred.IsCallable(r) )
    self.rate = r
end

local function GetNumericalRate(self)
    local r = self.rate
    if Pred.IsCallable(r) then
        r = r(self.inst)
    end
    assert( Pred.IsNumber(r) )
    return r
end


local function Update(inst, dt)
    local self = inst.components.perishable

    if not (inst:IsValid() and self) then
        return
    end

    local r = GetNumericalRate(self)
    local old_val = self.perishremainingtime
    local new_val = math.max(old_val - dt*r, 0)

    self.perishremainingtime = new_val

    if math.floor(old_val*100) ~= math.floor(new_val*100) then
        inst:PushEvent("perishchange", {percent = self:GetPercent()})
    end
    
    if self.perishremainingtime == 0 then
        self:Perish()
    end
end

function FlexiblePerishable:LongUpdate(dt)
    if self.updatetask then
        Update(self.inst, dt)
    end
end

function FlexiblePerishable:StartPerishing()
    if self.updatetask then
        self.updatetask:Cancel()
        self.updatetask = nil
    end

    local dt = 10 + math.random()*_G.FRAMES*8

    self.updatetask = self.inst:DoPeriodicTask(dt, Update, math.random()*2, dt)
end

local function OnRemove(self)
    self:StopPerishing()
end

FlexiblePerishable.OnRemoveFromEntity = OnRemove
FlexiblePerishable.OnRemoveEntity = OnRemove

return {FlexiblePerishable, "perishable"}
