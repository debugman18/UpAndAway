--[[
-- Translates world customisation options meant for RoG into their vanilla
-- counterparts, in case RoG is not enabled.
--]]


if IsDLCEnabled(REIGN_OF_GIANTS) then return end


wickerrequire "plugins.addpopulateworldpreinit"


local FunctionQueue = wickerrequire "gadgets.functionqueue"


local extra_patches = FunctionQueue()


--[[
-- Table mapping RoG stuff to the vanilla counterparts.
--]]

local tovanilla = {
    season_mode = {
        preonlyautumn = "preonlysummer",
        onlyautumn = "onlysummer",
        preonlyspring = "preonlysummer",
        onlyspring = "onlysummer",
    },
    season = {
        autumn = "summer",
        spring = "summer",
    },
    season_start = {
        autumn = "summer",
        spring = "summer",
    },
}

if not IsDST() then
    --[[
    -- Season start works differently outside of DST, since it's baked right into the
    -- seasonmanager savedata.
    --]]
    local function fix_season_start(savedata)
        local sm = savedata.map.persistdata and savedata.map.persistdata.seasonmanager
        if sm and tovanilla.season_start[sm.current_season] then
            sm.current_season = tovanilla.season_start[sm.current_season]
        end
    end
    table.insert(extra_patches, fix_season_start)
end

TheMod:AddPopulateWorldPreInit(function(savedata)
    local all_overrides = savedata.map.topology.overrides
    if not all_overrides then return end

    for area, overrides in pairs(all_overrides) do
        for i, override in ipairs(overrides) do
            local name = override[1]
            local vanilla_value = tovanilla[name] and tovanilla[name][override[2]]
            if vanilla_value then
                TheMod:Say("Translating RoG world customisation option for ", name, ": ", override[2], " => ", vanilla_value)
                override[2] = vanilla_value
            end
        end
    end

    extra_patches(savedata)
end)
