--[[
-- Physics patches.
--
-- Basically stores information about physical properties which the game
-- doesn't expose outside of the engine.
--]]

local Physics = assert( _G.Physics )


--[[
-- There are the attributes we track.
--]]
tracked_attributes = {
    "Damping",
    "Restitution",
    "Friction",
}

--[[
-- Metadata table for the Physics engine-level component.
--]]
local metadata = setmetatable({}, {__mode = "k"})


for _, attr in ipairs(tracked_attributes) do
    local setter_name = "Set"..attr
    Physics[setter_name] = (function()
        local oldSetter = assert( Physics[setter_name] )
        return function(t, ...)
            local datum = metadata[t]
            if not datum then
                datum = {}
                metadata[t] = datum
            end
            datum[attr] = {...}
            return oldSetter(t, ...)
        end
    end)()

    local getter_name = "Get"..attr
    local function getter(inst)
        local phys = inst.Physics
        if phys then
            if inst:IsValid() then
                local datum = metadata[phys]
                local val = datum and datum[attr]
                if val then
                    return unpack(val)
                else
                    return 0
                end
            else
                metadata[phys] = nil
            end
        end
    end
    _M[getter_name] = getter
end
