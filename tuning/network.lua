--[[
-- Cooldown for a player to be able to request climbing to another level.
--]]
CLIMBING_MANAGER.COOLDOWN = 30

--[[
-- Maximum time players have to agree to a climb before the request times out.
--]]
CLIMBING_MANAGER.TIMEOUT = 15

--[[
-- Period between updating and broadcasting the current poll data.
--
-- Range (randomized).
--]]
CLIMBING_MANAGER.UPDATE_PERIOD = {0.7, 1}

--[[
-- Consensus method to determine if a climb (up or down) should be performed.
-- Check components/climbingmanager.lua for the possibilities.
--]]
CLIMBING_MANAGER.CONSENSUS = "UNANIMOUS"

-- Percentage of an entity's temperature that must change in order for
-- it to be broadcast to the clients.
NETWORK.TEMPERATURE_PERCENT_DELTA_THRESHOLD = 2
