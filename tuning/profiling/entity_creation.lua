--[[
-- Time parameters are in seconds.
--]]

local OPTS = PROFILING.ENTITY_CREATION


-- Delay from save load until the profiling starts.
OPTS.START_DELAY = 5

--[[
-- Name of the output file, relative to MODROOT. Gets overriden every time
-- new profile data is written, which happens whenever the game saves.
--
-- Its contents represent the full entity count per function (followed by
-- file name and line count) responsible, since the profiling started.
--
-- When these values are written to disk, they are not zeroed out in memory,
-- so that consecutive saves will write the total cumulative data for the
-- save load.
--]]
OPTS.OUTPUT_FILE = "entity_count_profiling.txt"
