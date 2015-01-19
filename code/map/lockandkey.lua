BindWickerModule "plugins.lockandkey"


local KEYS, LOCKS = KEYS, LOCKS
local LOCKS_KEYS = _G.LOCKS_KEYS


TheMod:AddKey("CRAFTABLE_HEAT")
TheMod:AddKey("SUSTAINABLE_HEAT")

TheMod:AddKey("FABLE_TECH")
TheMod:AddKey("EXPLORE_INITIAL")

TheMod:AddLock("FABLE_TECH", {KEYS.FABLE_TECH})
TheMod:AddLock("EXPLORE_INITIAL", {KEYS.EXPLORE_INITIAL})

TheMod:AddLock("CRAFTABLE_HEAT", {KEYS.CRAFTABLE_HEAT})
TheMod:AddLock("SUSTAINABLE_HEAT", {KEYS.SUSTAINABLE_HEAT})
-- Either key unlocks.
TheMod:AddLock("HEAT", {KEYS.CRAFTABLE_HEAT, KEYS.SUSTAINABLE_HEAT})


SAFE_KEYS = setmetatable({}, {
    __index = function(_, k)
        local v = KEYS[k]
        if v == nil then
            return error("Invalid key "..tostring(k).."!")
        end
        return v
    end,
})

SAFE_LOCKS = setmetatable({}, {
    __index = function(_, k)
        local v = LOCKS[k]
        if v == nil or LOCKS_KEYS[v] == nil then
            return error("Invalid lock "..tostring(k).."!")
        end
        return v
    end,
})
