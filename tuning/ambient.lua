-- Note that the static generator only updates itself every 2 seconds, so
-- using too low of a value will give low precision.
STATIC.AVERAGE_UNCHARGED_TIME = 120
STATIC.AVERAGE_CHARGED_TIME = 30
STATIC.COOLDOWN = 20


--[[
-- The game's dusk ambient coĺour.
-- It seems not taking a multiple of it as ambient colour creates weird auras
-- around light sources (probably due to the colour cube, which is set to dusk
-- winter).
--]]
local dusk_colour = Point(100/255, 100/255, 100/255)

-- Ambient colour (RGB) for the static states.
-- Always multiply with numbers on the right.
CLOUD_AMBIENT.UNCHARGED_COLOUR = dusk_colour*1.5
CLOUD_AMBIENT.CHARGED_COLOUR = dusk_colour*0.6

-- Transition time between ambient colours.
CLOUD_AMBIENT.COLOUR_TRANSITION_TIME = 5


SKYFLYSPAWNER.MAX_FLIES = 5
-- Range, (min, max)
SKYFLYSPAWNER.SPAWN_DELAY = {5, 12}
-- Distance from player allowed for spawning, (min, max)
SKYFLYSPAWNER.PLAYER_DISTANCE = {3, 14}
-- Minimum distance between spawned flies.
SKYFLYSPAWNER.MIN_FLY2FLY_DISTANCE = 2
-- Should skyflies be preserved across saves?
SKYFLYSPAWNER.PERSISTENT = true
