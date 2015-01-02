--[[
-- Better log information.
--]]

local io = wickerrequire "utils.io"

EntityScript.AddComponent = (function()
    local AddComponent = EntityScript.AddComponent

    local Nag = io.NewNotifier("WARNING", 1)

    return function(self, name)
        if self.components[name] then
            Nag("Overwriting existing component '", name, "' of [", self, "].")
        end
        return AddComponent(self, name)
    end
end)()
