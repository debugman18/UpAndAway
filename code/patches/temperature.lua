---
-- Postinits to extend the poorly implemented temperature component...
--
-- @author simplex




local Temperature = require "components/temperature"

Temperature.SetTemperature = (function()
    local oldSet = Temperature.SetTemperature

    local function clampTemp(self, temp)
        if self.maxtemp then
            temp = math.min(temp, self.maxtemp)
        end
        if self.mintemp then
            temp = math.max(temp, self.mintemp)
        end
        return temp
    end

    if IsDLCEnabled(REIGN_OF_GIANTS) then
        return function(self, temp)
            return oldSet(self, clampTemp(self, temp))
        end
    else
        return function(self, temp)
            temp = clampTemp(self, temp)

            local old = self:GetCurrent()
            local was_freezing = self:IsFreezing()

            oldSet(self, temp)

            local is_freezing = self:IsFreezing()

            self.inst:PushEvent("temperaturedelta", {last = old, new = self:GetCurrent()})

            if not was_freezing and is_freezing then
                self.inst:PushEvent("startfreezing")
            elseif was_freezing and not is_freezing then
                self.inst:PushEvent("stopfreezing")
            end
        end
    end
end)()

Temperature.OnLoad = (function()
    local oldOnLoad = Temperature.OnLoad

    return function(self, data)
        if data.current then
            self:SetTemperature(data.current)
        end
        return oldOnLoad(self, data)
    end
end)()
