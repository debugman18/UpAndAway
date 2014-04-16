modrequire "lib.climbing"


local function start_snow()
	TheMod:DebugSay("start_snow()")
	local sm = GetSeasonManager()
	if sm then
		sm:AlwaysWet()
		sm:StartPrecip()
	end
end

local function stop_snow()
	TheMod:DebugSay("stop_snow()")
	local sm = GetSeasonManager()
	if sm then
		sm:AlwaysDry()
		sm:StopPrecip()
	end
end

-- oldroom may be nil.
local function on_change_room(player, newroom, oldroom)
	local newground = newroom.value
	local oldground = oldroom and oldroom.value
	if newground == GROUND.SNOW and oldground ~= GROUND.SNOW then
		start_snow()
	elseif newground ~= GROUND.SNOW and oldground == GROUND.SNOW then
		stop_snow()
	end
end

-- It's ok to use a Sim post init because the coponent has no savedata.
TheMod:AddSimPostInit(function(player)
	if Pred.IsCloudLevel() then
		local sm = GetSeasonManager()
		if sm then
			sm:AlwaysDry()
		end

		player:AddComponent("roomwatcher")
		do
			local roomwatcher = player.components.roomwatcher

			roomwatcher:AddRoomChangeCallback(on_change_room)

			roomwatcher:StartUpdating()
		end
	end
end)
