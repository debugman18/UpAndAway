-- Shopkeeper

-- Maximum distance from the player for it to spawn a shopkeeper.
SHOPKEEPER_SPAWNER.MAX_DIST = 8

-- How long the shopkeeper spawner stays in the world after rain stops.
SHOPKEEPER_SPAWNER.REMOVE_DELAY = 30

-- Number of beans the Shopkeeper has.
-- (should we make it regen with time?)
SHOPKEEPER.NUMBEANS = 1

-- Defining functions in the cfg file should be limited for very simple things,
-- since the environment is very slim.
SHOPKEEPER.IS_A_COW = function(inst)
	return inst.prefab == "beefalo"
end

-- Maximum distance for a cow to be negotiated.
SHOPKEEPER.MAX_COW_DIST = 17

---------------------------------------

--Sheep / Storm Ram

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

-- Enable/disable sparks.
-- Set by the modinfo configuration.
--RAM.SPARKS = true

---------------------------------------

-- Owl

-- WIP

OWL.HEALTH = 250
OWL.DEFEND_DIST = 8
OWL.DAMAGE = 15
OWL.ATTACK_PERIOD = .7

---------------------------------------

-- Ball Lightning

-- WIP

BALL_LIGHTNING.HEALTH = 100
BALL_LIGHTNING.UNCHARGED_DAMAGE = 10
BALL_LIGHTNING.CHARGED_DAMAGE = 20
BALL_LIGHTNING.WALKSPEED = 7
BALL_LIGHTNING.RUNSPEED = 7
BALL_LIGHTNING.ATTACK_PERIOD = 2
BALL_LIGHTNING.CHARGE_DELAY = function() return 0.5 + 10*math.random() end
BALL_LIGHTNING.UNCHARGE_DELAY = BALL_LIGHTNING.CHARGE_DELAY

---------------------------------------

-- Goose

-- WIP

-- Minimum span between lays.
GOOSE.LAY_PERIOD = 120

-- Delay after static starts until an egg is laid. May be a function.
GOOSE.LAY_DELAY = function() return 5 + 5*math.random() end

---------------------------------------

-- Skyfly

-- Maximum range for flower hopping.
SKYFLY.HOP_RANGE = 16
-- Cooldown for a skyfly to switch flowers. Randomized between the two values.
SKYFLY.HOP_COOLDOWN = {2, 4}
-- The smaller this is, the closer skyflies will concentrate around the player. Must be positive.
SKYFLY.PLAYER_FARNESS = 2

---------------------------------------

-- Balloon Hound

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

---------------------------------------

-- Octocopter

OCTOCOPTER.TARGET_DIST = 15
OCTOCOPTER.RANGE = 5
OCTOCOPTER.HEALTH = 3000
OCTOCOPTER.ATTACK_PERIOD = 2
OCTOCOPTER.DAMAGE = 100
OCTOCOPTER.AREADAMAGE = 0.4

OCTOCOPTER.SLEEP_DIST_FROMHOME = 1
OCTOCOPTER.SLEEP_DIST_FROMTHREAT = 20
OCTOCOPTER.MAX_CHASEAWAY_DIST = 40
OCTOCOPTER.MAX_TARGET_SHARES = 5
OCTOCOPTER.SHARE_TARGET_DIST = 40

OCTOCOPTER.START_FACE_DIST = 15
OCTOCOPTER.KEEP_FACE_DIST = 15
OCTOCOPTER.GO_HOME_DIST = 1
OCTOCOPTER.MAX_CHASE_TIME = 10
OCTOCOPTER.MAX_CHASE_DIST = 20
OCTOCOPTER.RUN_AWAY_DIST = 5
OCTOCOPTER.STOP_RUN_AWAY_DIST = 8
OCTOCOPTER.FOLLOW_RADIUS = 1.5

OCTOCOPTER.PREFABS = {
	"trinket_12",
}

OCTOCOPTER.LOOT = {
	{'trinket_12', 1.00},
}

---------------------------------------

-- Beanlet / Beanlet Zealot

-- WIP

BEANLET.SCARE_RADIUS = 12

BEANLET_ZEALOT.GANG_UP_RADIUS = 15

---------------------------------------

-- Skytrap

SKYTRAP.ATTACK_PERIOD = 0
SKYTRAP.RANGE = 4
SKYTRAP.DAMAGE = 40
SKYTRAP.HEALTH = 50

SKYTRAP.PREFABS = {
    "ambrosia",
    "cloud_jelly",
    "cloud_cotton",
    "beanstalk_chunk",    
}

SKYTRAP.LOOT = {
    {'beanstalk_chunk', 1.00},
    {'beanstalk_chunk', 1.00},
    {'beanstalk_chunk', 0.50},
    {'cloud_cotton',    0.50},
    {'cloud_cotton',    0.50},
    {'cloud_cotton',    0.30},
    {'ambrosia',        0.30},
}

---------------------------------------
