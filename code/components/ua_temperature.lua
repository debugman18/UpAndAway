--[[
-- IMPORTANT:
--
-- This is a *dummy* component. What really matters is ua_temperature_replica.lua.
-- It only exists to avoid a possible future naming conflict with a vanilla
-- temperature_replica.lua.
--
-- It should NEVER be added directly to an entity. There's a postinit in
-- place adding it automatically to where it needs to be added.
--]]

local UATemperature = HostClass(function(self, inst)
    self.inst = inst
end)

return UATemperature
