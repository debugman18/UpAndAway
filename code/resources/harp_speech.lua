--[[

local get_inst_gender = (function()
    local cache = {}

    return function(inst)
        local p = inst.prefab
        if not p then return "MALE" end

        local ret = cache[p]
        if not ret then
            ret = _G.GetGenderStrings(p) or "MALE"
            cache[p] = ret
        end

        return ret
    end
end)()

WORD_MAP = {
    fella = function(listener)
        return get_inst_gender(listener) == "FEMALE" and "darling" or "fella"
    end,
    gentleman = function(listener)
        return get_inst_gender(listener) == "FEMALE" and "lady" or "gentleman"
    end,
}

SPEECHES = {}

SPEECHES.SEE_PLAYER = function(mgr)
    Sleep(0.25)

    mgr "HARP TEST"
end

SPEECHES.OCTOCOPTER_HINT = function(mgr)

end

SPEECHES.SEMICONDUCTOR_HINT = function(mgr)

end

SPEECHES.BEANGIANT_HINT = function(mgr)

end

--]]
