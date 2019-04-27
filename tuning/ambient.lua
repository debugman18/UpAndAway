-- Note that the static generator only updates itself every 2 seconds, so
-- using too low of a value will give low precision.
STATIC.AVERAGE_UNCHARGED_TIME = 2*TUNING.TOTAL_DAY_TIME
STATIC.AVERAGE_CHARGED_TIME = 1*TUNING.TOTAL_DAY_TIME
STATIC.COOLDOWN = 20

--[[
-- The game's dusk ambient coĺour.
-- It seems not taking a multiple of it as ambient colour creates weird auras
-- around light sources (probably due to the colour cube, which is set to dusk
-- winter).
--
-- Please don't modify this. It's meant as an accurate reference.
-- Use the scaling factors below.
-- -simplex
--]]
local dusk_colour = Point(100/255, 100/255, 100/255)

-- Ambient colour (RGB) for the static states.
-- Always multiply with numbers on the right.
CLOUD_AMBIENT.UNCHARGED_COLOUR = dusk_colour*1.8--2.5 --1.5
CLOUD_AMBIENT.CHARGED_COLOUR = dusk_colour*0.18 --0.75 --0.6

-- Transition time between ambient colours.
CLOUD_AMBIENT.COLOUR_TRANSITION_TIME = 5


-- Delay for skyflower -> datura transformation.
-- Can be a function.
SKYFLOWER.CHARGE_DELAY = function() return 0.5 + 5*math.random() end
SKYFLOWER.UNCHARGE_DELAY = SKYFLOWER.CHARGE_DELAY


SKYFLYSPAWNER.MAX_FLIES = 10
-- Range, (min, max)
SKYFLYSPAWNER.SPAWN_DELAY = {5, 12} --5,12
-- Distance from player allowed for spawning, (min, max)
SKYFLYSPAWNER.PLAYER_DISTANCE = {3, 14} --3,14
-- Minimum distance between spawned flies.
SKYFLYSPAWNER.MIN_FLY2FLY_DISTANCE = 2
-- Should skyflies be preserved across saves?
SKYFLYSPAWNER.PERSISTENT = true


GUSTFLOWER.WHIRLWIND_SPAWN_PERIOD = 1.5*TUNING.TOTAL_DAY_TIME
