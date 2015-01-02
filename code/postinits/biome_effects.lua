modrequire "lib.climbing"


local function start_snow()
    TheMod:DebugSay("start_snow()")
    local sm = GetPseudoSeasonManager()
    if sm then
        sm:AlwaysWet()
        sm:StartPrecip()
    end
end

local function stop_snow()
    TheMod:DebugSay("stop_snow()")
    local sm = GetPseudoSeasonManager()
    if sm then
        sm:AlwaysDry()
        sm:StopPrecip()
    end
end

---
-- This cannot be done in DST because the weather change would affect the whole level.
--
-- oldroom may be nil.
local function roomchange_snowcheck(player, newroom, oldroom)
    local newground = newroom.value
    local oldground = oldroom and oldroom.value
    if newground == GROUND.SNOW and oldground ~= GROUND.SNOW then
        start_snow()
    elseif newground ~= GROUND.SNOW and oldground == GROUND.SNOW then
        stop_snow()
    end
end

-- It's ok to use a Sim post init because the component has no savedata.
TheMod:AddSimPostInit(function()
    if Pred.IsCloudLevel() then
        local sm = GetPseudoSeasonManager()
        if sm then
            sm:AlwaysDry()
        end
    end
end)

if IsHost() then
    TheMod:AddPlayerPostInit(function(player)
        if Pred.IsCloudLevel() then
            player:AddComponent("roomwatcher")
            if not IsDST() then
                local roomwatcher = player.components.roomwatcher

                roomwatcher:AddRoomChangeCallback(roomchange_snowcheck)

                roomwatcher:StartUpdating()
            end
        end
    end)
end
