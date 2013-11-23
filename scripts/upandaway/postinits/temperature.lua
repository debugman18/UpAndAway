---
-- Postinits to extend the poorly implemented temperature component...
--
-- @author simplex


--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


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
