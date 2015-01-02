error "This shouldn't be used presently."

--[[
-- IMPORTANT:
--
-- This is a *dummy* component. What really matters is ua_camera_replica.lua.
--
-- It should NEVER be added directly to an entity. There's a postinit in
-- place adding it automatically to where it needs to be added.
--]]

local UACamera = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "UACamera")
end)

return UACamera
