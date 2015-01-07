--[[
-- Cooldown for a player to be able to request climbing to another level.
--]]
CLIMBING_MANAGER.COOLDOWN = IfDST(20, 0)

--[[
-- Maximum time players have to agree to a climb before the request times out.
--]]
CLIMBING_MANAGER.TIMEOUT = IfDST(15, math.huge)

--[[
-- Period between updating and broadcasting the current poll data.
--
-- Range (randomized).
--
-- obs: Currently unused. An update is performed whenever a vote is received.
--]]
CLIMBING_MANAGER.UPDATE_PERIOD = {0.7, 1}

--[[
-- Consensus method to determine if a climb (up or down) should be performed.
-- Check components/climbingmanager.lua for the possibilities.
--
-- This is now a mod configuration option, but a dummy option should still
-- be set here for singleplayer.
--]]
CLIMBING_MANAGER.CONSENSUS = "UNANIMOUS"

--[[
-- Maximum range from the climbable object for players to be able to vote.
--]]
CLIMBING_VOTER.RANGE = 30


-- Percentage of an entity's temperature that must change in order for
-- it to be broadcast to the clients.
NETWORK.TEMPERATURE_PERCENT_DELTA_THRESHOLD = 2
