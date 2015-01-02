if not Pred.IsWorldgen() then return end

wickerrequire "plugins.addgeneratenewpreinit"

local Climbing = modrequire "lib.climbing"


local package = _G.package

local function OverrideSetPieceAdder(name)
    local full_name = "map/"..name
    require(full_name)
    package.loaded[full_name] = modrequire("map."..name)
    return OverrideSetPieceAdder
end


TheMod:AddGenerateNewPreInit(function(parameters)
    if not Climbing.IsCloudLevelNumber(parameters.current_level or 1) then return end

    TheMod:DebugSay("Overriding standard set piece additions.")

    OverrideSetPieceAdder
        "traps"
        "pointsofinterest"
        "protected_resources"
        "boons"
        
end)
