--[[
-- This handles network sync of temperature.
--
-- It is only used for some entities. It's original purpose is to allow
-- the temperature meter for inventory items to work on clients.
--]]

local RELATIVE_THRESHOLD = netcfg("TEMPERATURE_PERCENT_DELTA_THRESHOLD")/100

---

local function getPercentage(self, current)
    if current == nil then
        current = self.net_current.value
    end

    local p = (current - self.net_mintemp.value)/(self.net_maxtemp.value - self.net_mintemp.value)

    if p >= 1 then
        return 1
    elseif p <= 0 then
        return 0
    else
        return p
    end
end

local updateCurrentTemp
if IsHost() then
    updateCurrentTemp = function(inst)
        local self = replica(inst).ua_temperature
        if not self then return end
        local temp = inst.components.temperature
        if not temp then return end

        local new_current = temp:GetCurrent()
        
        local p = getPercentage(self, new_current)
        if math.abs(p - self.last_percent) >= RELATIVE_THRESHOLD then
            self.last_percent = p
            self.net_current.value = new_current
            inst:PushEvent("ua_temperaturedelta")
        end
    end
else
    updateCurrentTemp = Lambda.Error("updateCurrentTemp should not be called on clients.")
end

local function ondirtyfn(inst)
    local self = replica(inst).ua_temperature
    if self then
        self.last_percent = getPercentage(self)
        inst:PushEvent("ua_temperaturedelta")
    end
end

local UATemperatureReplica = Class(function(self, inst)
    self.inst = inst

    local temp = inst.components.temperature
    assert(Logic.Implies(IsHost(), temp) and Logic.Implies(IsClient(), not temp), "Logic error.")

    self.net_current = NetShortInt(inst, "ua_temperature.current")
    self.net_maxtemp = NetShortInt(inst, "ua_temperature.maxtemp")
    self.net_mintemp = NetShortInt(inst, "ua_temperature.mintemp")

    self.net_current.value = temp and temp.current or 30
    self.net_maxtemp.value = temp and temp.maxtemp or 40
    self.net_mintemp.value = temp and temp.mintemp or -20

    self.net_current:AddOnDirtyFn(ondirtyfn)
    self.net_maxtemp:AddOnDirtyFn(ondirtyfn)
    self.net_mintemp:AddOnDirtyFn(ondirtyfn)

    self.last_percent = getPercentage(self)

    if temp then
        inst:ListenForEvent("temperaturedelta", updateCurrentTemp)
    end
end)
local TempRep = UATemperatureReplica


function TempRep:GetCurrent()
    return self.net_current.value
end

function TempRep:GetMax()
    return self.net_maxtemp.value
end

function TempRep:GetMin()
    return self.net_mintemp.value
end

function TempRep:GetPercent()
    return self.last_percent
end

return TempRep
