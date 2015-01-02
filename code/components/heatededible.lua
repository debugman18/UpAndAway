

local Pred = wickerrequire "lib.predicates"
local Debuggable = wickerrequire "gadgets.debuggable"


local oneaten

--[[
-- The temperature and edible components should be added as well.
--]]
local HeatedEdible = HostClass(Debuggable, function(self, inst)
    assert( inst.components.temperature, "The Temperature component should be added before the HeatedEdible one!" )

    self.inst = inst
    Debuggable._ctor(self, "HeatedEdible")
    inst:AddTag("show_temperature")

    self.heat_capacity = 0

    self.inst:ListenForEvent("oneaten", oneaten)
end)

function HeatedEdible:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("oneaten", oneaten)
    self.inst:RemoveTag("show_temperature")
end

function HeatedEdible:GetHeatCapacity()
    return self.heat_capacity
end

function HeatedEdible:SetHeatCapacity(C)
    self.heat_capacity = C
end

oneaten = function(inst, data)
    local self = inst.components.heatededible
    local eater = data.eater

    if not (
        self
        and eater
        and inst.components.temperature	
        and eater.components.temperature
    ) or inst.components.temperature.settemp then return end

    local eater_temp = eater.components.temperature:GetCurrent()

    eater.components.temperature:SetTemperature(
            (
                eater_temp
            +
                    self:GetHeatCapacity()
                *
                    inst.components.temperature:GetCurrent()
            )
        /
            (
                1
            +
                self:GetHeatCapacity()
            )
    )

    if self:Debug() then
        local function one_digit(x)
            return ("%.1f"):format(x)
        end
        self:Say("changed [", eater, "]'s temperature from ", one_digit(eater_temp), " to ", one_digit(eater.components.temperature:GetCurrent()))
    end
end

return HeatedEdible
