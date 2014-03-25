---
-- Postinits to extend the poorly implemented temperature component...
--
-- @author simplex




local Temperature = require "components/temperature"

Temperature.SetTemperature = (function()
	local oldSet = Temperature.SetTemperature

	return function(self, temp)
		temp = math.min(self.maxtemp, math.max(self.mintemp, temp))

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
