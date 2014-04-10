-- Maximum distance from the player for it to spawn a shopkeeper.
SHOPKEEPER_SPAWNER.MAX_DIST = 8

-- How long the shopkeeper spawner stays in the world after rain stops.
SHOPKEEPER_SPAWNER.REMOVE_DELAY = 30

-- Number of beans the Shopkeeper has.
-- (should we make it regen with time?)
SHOPKEEPER.NUMBEANS = 3

-- Defining functions in the cfg file should be limited for very simple things,
-- since the environment is very slim.
SHOPKEEPER.IS_A_COW = function(inst)
	return inst.prefab == "beefalo"
end

-- Maximum distance for a cow to be negotiated.
SHOPKEEPER.MAX_COW_DIST = 17


SHEEP.HEALTH = 100
RAM.HEALTH = 600

SHEEP.DAMAGE = 5
RAM.DAMAGE = 35

-- Radius to find a new target.
RAM.TARGET_DIST= 6

-- Maximum distance to herd when chasing a target.
SHEEP.CHASE_DIST = 10
RAM.CHASE_DIST = 30

-- Delay for sheep -> ram transformation.
-- Can be a function.
SHEEP.CHARGE_DELAY = function() return 0.5 + 10*math.random() end
-- Opposite
SHEEP.UNCHARGE_DELAY = SHEEP.CHARGE_DELAY

-- Owl tuning.
OWL.HEALTH = 250
OWL.DEFEND_DIST = 8
OWL.DAMAGE = 15
OWL.ATTACK_PERIOD = .7

BALL_LIGHTNING.HEALTH = 100
BALL_LIGHTNING.UNCHARGED_DAMAGE = 10
BALL_LIGHTNING.CHARGED_DAMAGE = 20
BALL_LIGHTNING.WALKSPEED = 7
BALL_LIGHTNING.RUNSPEED = 7
BALL_LIGHTNING.ATTACK_PERIOD = 2
BALL_LIGHTNING.CHARGE_DELAY = SHEEP.CHARGE_DELAY
BALL_LIGHTNING.UNCHARGE_DELAY = SHEEP.UNCHARGE_DELAY

--[[
-- Minimum span between lays.
--]]
GOOSE.LAY_PERIOD = 120

--[[
-- Delay after static starts until an egg is laid. May be a function.
--]]
GOOSE.LAY_DELAY = function() return 5 + 5*math.random() end

-- Maximum range for flower hopping.
SKYFLY.HOP_RANGE = 16
-- Cooldown for a skyfly to switch flowers. Randomized between the two values.
SKYFLY.HOP_COOLDOWN = {2, 4}
-- The smaller this is, the closer skyflies will concentrate around the player. Must be positive.
SKYFLY.PLAYER_FARNESS = 2

-- Height with respect to ground. Can't be more than 2, otherwise the hound can't be attacked.
BALLOON_HOUND.HEIGHT = 2
BALLOON_HOUND.BALLOON_SCALE = 1
-- Possible balloon colours (chosen at random).
BALLOON_HOUND.BALLOON_COLOURS = {
    Point(198/255,  43/255,  43/255),
    Point( 79/255, 153/255,  68/255),
    Point( 35/255, 105/255, 235/255),
    Point(233/255, 208/255,  69/255),
    Point(109/255,  50/255, 163/255),
    Point(222/255, 126/255,  39/255),
}
-- Initial height of the hound when dropping.
BALLOON_HOUND.INITIAL_HEIGHT = 25
-- Damping when falling. The closer to 1 it is, the slower the fall. It must be strictly less than 1, otherwise the hound does not move at all.
BALLOON_HOUND.FALL_DAMPING = 0.9999
-- How long it stays in the world after spawning (without its balloon having popped). {min, max}
BALLOON_HOUND.TIMEOUT = {30, 90}
-- Speed in which it floats away upwards after the permanency timeout.
BALLOON_HOUND.FLOAT_AWAY_SPEED = 5
-- Distance to spawn a hound if the player is still. {min, max}
BALLOON_HOUND.STILL_SPAWN_DIST = {3, 8}
-- Distance to spawn a hound if the player is moving. {min, max}
BALLOON_HOUND.MOVING_SPAWN_DIST = {8, 12}

--Maximum distance for octocopter to target a target.
OCTOCOPTER.TARGET_DIST = 15
--Maximum distance for octocopter to attack a target.
OCTOCOPTER.RANGE = 5
--The health of the octocopter.
OCTOCOPTER.HEALTH = 1000
--Minimum time between octocopter attacks.
OCTOCOPTER.ATTACK_PERIOD = 4