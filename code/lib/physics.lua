local _M = _M


local EntityMeta = wickerrequire("gadgets.entity_table")()

local PhysicsPatches = modrequire "patches.physics"

local Physics = assert( _G.Physics )


--[[
-- These are the attributes we track.
--]]
local tracked_attributes = PhysicsPatches.tracked_attributes

--[[
-- Returns the physics metadata table for an entity.
--]]
local function phys_meta(inst)
    if inst:IsValid() then
        local ret = EntityMeta[inst]
        if not ret then
            ret = {}
            EntityMeta[inst] = ret
        end
        return ret
    end
end


for _, attr in pairs(tracked_attributes) do
    --[[
    -- Getters.
    --]]
    local getter_name = "Get"..attr
    local getter = PhysicsPatches[getter_name]
    _M[getter_name] = getter


    --[[
    -- Setters.
    --]]
    local setter_name = "Set"..attr
    local function setter(inst, ...)
        local phys = inst.Physics
        if phys then
            return phys[setter_name](phys, ...)
        end
    end
    _M[setter_name] = setter

    --[[
    -- Pushers.
    --]]
    local pusher_name = "Push"..attr
    local function pusher(inst, ...)
        local meta = phys_meta(inst)
        if meta then
            meta[attr] = meta[attr] or {}
            table.insert(meta[attr], {getter(inst)})
            return setter(inst, ...)
        end
    end
    _M[pusher_name] = pusher

    --[[
    -- Poppers.
    --]]
    local popper_name = "Pop"..attr
    local function popper(inst)
        local meta = phys_meta(inst)
        local attr_table = meta and meta[attr]
        local old_value = attr_table and table.remove(attr_table)
        if old_value then
            return setter(inst, unpack(old_value))
        end
    end
    _M[popper_name] = popper
end
