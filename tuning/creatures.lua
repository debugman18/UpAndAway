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
OWL.DEFEND_DIST = 3
OWL.DAMAGE = 6
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
