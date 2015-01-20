---------------------------------------

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
RAM.HEALTH = 250

SHEEP.DAMAGE = 5
RAM.DAMAGE = 35

SHEEP.WALKSPEED = 2
SHEEP.RUNSPEED = 7

-- Radius to find a new target.
RAM.TARGET_DIST= 6

-- Maximum distance to herd when chasing a target.
SHEEP.CHASE_DIST = 10
RAM.CHASE_DIST = 30

SHEEP.FOLLOW_TIME = 25

-- Delay for sheep -> ram transformation.
-- Can be a function.
SHEEP.CHARGE_DELAY = function() return 0.5 + 10*math.random() end
-- Opposite
SHEEP.UNCHARGE_DELAY = SHEEP.CHARGE_DELAY

-- Sheep Brain

SHEEP.STOP_RUN_DIST = 4
SHEEP.SEE_PLAYER_DIST = 10

SHEEP.AVOID_PLAYER_DIST = 2
SHEEP.AVOID_PLAYER_STOP = 5

SHEEP.SEE_BAIT_DIST = 20
SHEEP.MAX_WANDER_DIST = 35

-- Ram Brain

RAM.STOP_RUN_DIST = 0
RAM.SEE_PLAYER_DIST = 20

RAM.AVOID_PLAYER_DIST = 0
RAM.AVOID_PLAYER_STOP = 0

RAM.SEE_BAIT_DIST = 20
RAM.MAX_WANDER_DIST = 50

RAM.START_FACE_DIST = 10
RAM.KEEP_FACE_DIST = 16

RAM.GO_HOME_DIST = 35

RAM.MAX_CHASE_TIME = 8
RAM.MAX_CHASE_DIST = 40

RAM.MAX_CHARGE_DIST = 15
RAM.CHASE_GIVEUP_DIST = 10

RAM.RUN_AWAY_DIST = 4
RAM.STOP_RUN_AWAY_DIST = 5

-- Loot and Prefabs

SHEEP.PREFABS = {
	"meat",
	"skyflower",
	"cloud_cotton",
	"beefalowool",
}

SHEEP.PERIODICSPAWN_PREFAB = "skyflower"
SHEEP.MINIMUM_SPACING = 0

SHEEP.LOOT = {
	{'meat',	0.70},	
	{'meat',	0.70},
	{'meat',	0.70},
	{'cloud_cotton',	0.70},
	{'cloud_cotton',	0.70},
	{'cloud_cotton',	0.70},
}

RAM.LOOT = {
	{'meat',	1.00},	
	{'meat',	0.90},
	{'meat',	0.70},
	{'meat',	0.70},
	{'meat',	0.70},	
	{'beefalowool',	0.90},
	{'beefalowool',	0.80},
	{'beefalowool',	0.80},
}

SHEEP.SHAVE_BITS = 3
SHEEP.HAIR_GROWTH_DAYS = 3

-- Enable/disable sparks.
-- Set by the modinfo configuration.
--RAM.SPARKS = true

---------------------------------------

-- Owl

OWL.SCALE = 1.2
OWL.WHO_INTERVAL = math.random(1,4)

OWL.HEALTH = 180
OWL.DAMAGE = 15
OWL.ATTACK_PERIOD = 0.7
OWL.WALKSPEED = 5
OWL.RUNSPEED = 7

OWL.DEFEND_DIST = 8
OWL.MAX_TARGET_SHARES = 5
OWL.SHARE_TARGET_DIST = 10

-- Owl Brain

OWL.SEE_PLAYER_DIST = 5
OWL.SEE_FOOD_DIST = 10
OWL.MAX_WANDER_DIST = 15
OWL.MAX_CHASE_TIME = 5
OWL.MAX_CHASE_DIST = 10
OWL.RUN_AWAY_DIST = 5
OWL.STOP_RUN_AWAY_DIST = 8
OWL.START_FACE_DIST = 6

-- Loot and Prefabs

OWL.PREFABS = {
   --"owl_beak",
   --"owl_gizzard",
   --"owl_feather",
   --"black_crystal_amulet",
   "rope",
   "crystal_fragment_black",
}

OWL.LOOT = {
	{'crystal_fragment_black', 0.40},
	{'rope',                   0.40},
}

---------------------------------------

-- Ball Lightning

BALL_LIGHTNING.SCALE = 1.5

BALL_LIGHTNING.HEALTH = 100

BALL_LIGHTNING.UNCHARGED_DAMAGE = 10
BALL_LIGHTNING.CHARGED_DAMAGE = 20
BALL_LIGHTNING.ATTACK_PERIOD = 2

BALL_LIGHTNING.WALKSPEED = 7
BALL_LIGHTNING.RUNSPEED = 7

BALL_LIGHTNING.CHARGE_DELAY = function() return 0.5 + 10*math.random() end
BALL_LIGHTNING.UNCHARGE_DELAY = BALL_LIGHTNING.CHARGE_DELAY

BALL_LIGHTNING.MINTEMP = 80
BALL_LIGHTNING.MAXTEMP = 80
BALL_LIGHTNING.CURRENT_TEMP = 80

BALL_LIGHTNING.HEAT = 80

BALL_LIGHTNING.INSULATION = TUNING.INSULATION_MED  

BALL_LIGHTNING.SLOW_MODIFIER = 1

-- Ball Lightning Brain

BALL_LIGHTNING.MIN_FOLLOW_DIST = 0
BALL_LIGHTNING.MAX_FOLLOW_DIST = 4
BALL_LIGHTNING.TARGET_FOLLOW_DIST = 4

BALL_LIGHTNING.MAX_WANDER_DIST = 30

BALL_LIGHTNING.CHILD = "ball_lightning_fx"
BALL_LIGHTNING.FX = "lightning_rod_fx"

-- Loot and Prefabs

BALL_LIGHTNING.PREFABS = {
	"ball_lightning_fx",
}

BALL_LIGHTNING.FX_PREFABS = {
	"lightning_rod_fx",
}

BALL_LIGHTNING.LOOT = {
	
}

---------------------------------------

-- Goose

-- Minimum span between lays.
GOOSE.LAY_PERIOD = 120

-- Delay after static starts until an egg is laid. May be a function.
GOOSE.LAY_DELAY = function() return 5 + 5*math.random() end

GOOSE.WALKSPEED = 3
GOOSE.RUNSPEED = 8

GOOSE.HEALTH = 40

GOOSE.DAMAGE = 20
GOOSE.ATTACK_PERIOD = 3

GOOSE.SCALEX = 1.3
GOOSE.SCALEY = 1.4
GOOSE.SCALEZ = 1.1

-- Goose Brain

GOOSE.STOP_RUN_DIST = 10
GOOSE.SEE_PLAYER_DIST = 5
GOOSE.SEE_FOOD_DIST = 20
GOOSE.MAX_WANDER_DIST = 80

-- Loot and Prefabs

GOOSE.PREFABS = {
	"drumstick",
	"golden_egg",
}

GOOSE.LOOT = {
	{'drumstick', 	 1.00},	
	{'drumstick', 	 0.90},
	{'drumstick', 	 0.50},
	{'drumstick', 	 1.00},	
	{'feather_robin_winter', 1.00},
	{'feather_robin_winter', 0.90},	
	{'feather_robin_winter', 0.90},
	{'feather_robin_winter', 0.90},
	{'golden_egg',	 0.10},
}

-- This really shouldn't ever be changed.
GOOSE.EGG = "golden_egg"

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
OCTOCOPTER.RANGE = 6
OCTOCOPTER.HEALTH = 3000
OCTOCOPTER.ATTACK_PERIOD = 4
OCTOCOPTER.DAMAGE = 80
OCTOCOPTER.AREA_RANGE = 6
OCTOCOPTER.AREA_DAMAGE = 0.4

OCTOCOPTER.SLEEP_DIST_FROMHOME = 1
OCTOCOPTER.SLEEP_DIST_FROMTHREAT = 20
OCTOCOPTER.MAX_CHASEAWAY_DIST = 20
OCTOCOPTER.MAX_TARGET_SHARES = 5
OCTOCOPTER.SHARE_TARGET_DIST = 40

-- Octocopter Brain

OCTOCOPTER.START_FACE_DIST = 15
OCTOCOPTER.KEEP_FACE_DIST = 20
OCTOCOPTER.GO_HOME_DIST = 1
OCTOCOPTER.MAX_CHASE_TIME = 10
OCTOCOPTER.MAX_CHASE_DIST = 20
OCTOCOPTER.RUN_AWAY_DIST = 5
OCTOCOPTER.STOP_RUN_AWAY_DIST = 8
OCTOCOPTER.FOLLOW_RADIUS = 3

-- Loot and Prefabs

OCTOCOPTER.PREFABS = {
	"trinket_12",
}

OCTOCOPTER.LOOT = {
	{'trinket_12', 1.00},
	-- Good loot will be here.
}

---------------------------------------

-- Beanlet / Beanlet Zealot

BEANLET.SCALE = 1
BEANLET_ZEALOT.SCALE = 1.4

BEANLET.WALKSPEED = 4
BEANLET.RUNSPEED = 6

BEANLET_ZEALOT.WALKSPEED = 4
BEANLET_ZEALOT.RUNSPEED = 5

BEANLET.HEALTH = 80
BEANLET_ZEALOT.HEALTH = 150

BEANLET_ZEALOT.DAMAGE = 35
BEANLET_ZEALOT.ATTACK_PERIOD = 1.5

-- Beanlet Combat

BEANLET.SCARE_RADIUS = 12

BEANLET_ZEALOT.GANG_UP_RADIUS = 15

-- Beanlet Brain

BEANLET.STOP_RUN_DIST = 10
BEANLET.SEE_PLAYER_DIST = 10

BEANLET.AVOID_PLAYER_DIST = 6
BEANLET.AVOID_PLAYER_STOP = 10

BEANLET.MAX_WANDER_DIST = 200

-- Beanlet Zealot Brain

BEANLET_ZEALOT.STOP_RUN_DIST = 10
BEANLET_ZEALOT.SEE_PLAYER_DIST = 10

BEANLET_ZEALOT.AVOID_PLAYER_DIST = 6
BEANLET_ZEALOT.AVOID_PLAYER_STOP = 10

BEANLET_ZEALOT.RUN_AWAY_DIST = 4
BEANLET_ZEALOT.STOP_RUN_AWAY_DIST = 6

BEANLET_ZEALOT.MAX_CHASE_DIST = 25
BEANLET_ZEALOT.MAX_CHASE_TIME = 10

BEANLET_ZEALOT.MAX_WANDER_DIST = 200

BEANLET_ZEALOT.START_FACE_DIST = 4

-- Loot and Prefabs

BEANLET.PREFABS = {
   "greenbean",
   "beanlet_shell",
}

BEANLET.LOOT = {
    {'greenbean',       1.00},
    {'greenbean',       0.80},
    {'greenbean',       0.70},
    {'beanlet_shell',   0.20},
}

BEANLET_ZEALOT.LOOT = {
    {'greenbean',       1.00},
    {'greenbean',       0.90},
    {'greenbean',       0.80},
    {'beanlet_shell',   0.43},
}

---------------------------------------

-- Skytrap

SKYTRAP.ATTACK_PERIOD = 0.70
SKYTRAP.RANGE = 4
SKYTRAP.DAMAGE = 50
SKYTRAP.HEALTH = 40

-- Loot and Prefabs

SKYTRAP.PREFABS = {
    "ambrosia",
    "cloud_jelly",
    "cloud_cotton",
    "beanstalk_chunk",    
}

SKYTRAP.LOOT = {
    {'beanstalk_chunk', 1.00},
    {'beanstalk_chunk', 0.70},
    {'beanstalk_chunk', 0.50},
    {'cloud_cotton',    0.50},
    {'cloud_cotton',    0.25},
    {'cloud_cotton',    0.25},
    {'ambrosia',        0.30},
}

---------------------------------------

-- Live Gnome

LIVE_GNOME.WALKSPEED = 1
LIVE_GNOME.RUNSPEED = 3

LIVE_GNOME.SCALE = 3.8
LIVE_GNOME.ITEM_SCALE = 1.2

LIVE_GNOME.HEALTH = 200

LIVE_GNOME.DAMAGE = 10
LIVE_GNOME.RANGE = TUNING.WALRUS_ATTACK_DIST
LIVE_GNOME.ATTACK_PERIOD = 3

-- This projectile will likely be removed. Or changed into a hairball. 
LIVE_GNOME.PROJECTILE = "blowdart_walrus"

-- Live Gnome Brain

LIVE_GNOME.RUN_START_DIST = 5
LIVE_GNOME.RUN_STOP_DIST = 15

LIVE_GNOME.MAX_WANDER_DIST = 20
LIVE_GNOME.MAX_CHASE_TIME = 10

LIVE_GNOME.MIN_FOLLOW_DIST = 8
LIVE_GNOME.MAX_FOLLOW_DIST = 15
LIVE_GNOME.TARGET_FOLLOW_DIST = (15+8)/2
LIVE_GNOME.MAX_PLAYER_STALK_DISTANCE = 20

LIVE_GNOME.MIN_FOLLOW_LEADER = 2
LIVE_GNOME.MAX_FOLLOW_LEADER = 4
LIVE_GNOME.TARGET_FOLLOW_LEADER = (4+2)/2

LIVE_GNOME.START_FACE_DIST = 15
LIVE_GNOME.KEEP_FACE_DIST = 15

-- Loot and Prefabs

LIVE_GNOME.PREFABS = {
	"rubber",
}

LIVE_GNOME.LOOT = {
	
}

LIVE_GNOME.COOKED_PRODUCT = "rubber"

---------------------------------------

-- Gummybear

GUMMYBEAR.SCALE = 0.9

GUMMYBEAR.COLOR = function() return 0.1 + math.random() * 0.9 end

GUMMYBEAR.ALPHA = function() return 0.75 + math.random() end

GUMMYBEAR.WALKSPEED = 2
GUMMYBEAR.RUNSPEED = 5

GUMMYBEAR.HEALTH = 310

GUMMYBEAR.DAMAGE = 30
GUMMYBEAR.ATTACK_PERIOD = 2.20
GUMMYBEAR.RANGE = 2.05

-- Gummybear Brain

GUMMYBEAR.RUN_AWAY_DIST = 10
GUMMYBEAR.SEE_FOOD_DIST = 10
GUMMYBEAR.SEE_TARGET_DIST = 6

GUMMYBEAR.MIN_FOLLOW_DIST = 2
GUMMYBEAR.TARGET_FOLLOW_DIST = 3
GUMMYBEAR.MAX_FOLLOW_DIST = 8

GUMMYBEAR.MAX_CHASE_DIST = 7
GUMMYBEAR.MAX_CHASE_TIME = 8
GUMMYBEAR.MAX_WANDER_DIST = 32

GUMMYBEAR.START_RUN_DIST = 8
GUMMYBEAR.STOP_RUN_DIST = 12

GUMMYBEAR.DAMAGE_UNTIL_SHIELD = 50
GUMMYBEAR.SHIELD_TIME = 3
GUMMYBEAR.AVOID_PROJECTILE_ATTACKS = false

-- Loot and Prefabs

GUMMYBEAR.PREFABS = {
	"nightmarefuel",
}

GUMMYBEAR.LOOT = {
	{'nightmarefuel', 1.00},
	{'nightmarefuel', 1.00},
	{'nightmarefuel', 0.50},
}

---------------------------------------

-- Bean Giant

BEAN_GIANT.TAGS = {
	"epic",
	"monster",
	"hostile",
	"scarytoprey",
	"beanmonster",
	"largecreature",
}

BEAN_GIANT.HEALTH = 1300
BEAN_GIANT.HEALTH_PERIOD = 60
BEAN_GIANT.HEAL_PERCENT = 0.4

BEAN_GIANT.WALKSPEED = 3
BEAN_GIANT.RUNSPEED = 3

BEAN_GIANT.DAMAGE = 130
BEAN_GIANT.RANGE = 4
BEAN_GIANT.ATTACK_PERIOD = 3

BEAN_GIANT.TRANSFORM_BUFFER = 0.5

BEAN_GIANT.SHAKE_DIST = 40

BEAN_GIANT.SCALE = 2

BEAN_GIANT.PLAYER_DAMAGE_PERCENT = 0.8

BEAN_GIANT.AREA_RANGE = 4
BEAN_GIANT.AREA_DAMAGE = 0.8

BEAN_GIANT.CHILD = "vine"
BEAN_GIANT.RARECHILD = "beanlet_zealot"
BEAN_GIANT.RARECHILD_CHANCE = 0.2
BEAN_GIANT.SPAWN_PERIOD = 0.3
BEAN_GIANT.REGEN_MODIFER = 0.1
BEAN_GIANT.MAX_CHILDREN = 10

BEAN_GIANT.TARGET_DIST = 30

BEAN_GIANT.HOSTILE_SANITY_AURA = TUNING.SANITYAURA_LARGE
BEAN_GIANT.CALM_SANITY_AURA = TUNING.SANITYAURA_HUGE

-- Bean Giant Brain

BEAN_GIANT.SEE_DIST = 40

BEAN_GIANT.CHASE_DIST = 30
BEAN_GIANT.CHASE_TIME = 30

-- Loot and Prefabs

BEAN_GIANT.PREFABS = {
    "beanstalk_chunk",
    "vine",
    "beanlet_zealot",
    "greenbean",   
    "bean_brain",
}

BEAN_GIANT.LOOT = {
	{'beanstalk_chunk', 1.00},
	{'beanstalk_chunk', 1.00},
	{'beanstalk_chunk', 1.00},
	{'beanstalk_chunk', 1.00},
	{'beanstalk_chunk', 1.00},
	{'beanstalk_chunk', 0.70},
	{'beanstalk_chunk', 0.70},
	{'beanstalk_chunk', 0.70},
	{'beanstalk_chunk', 0.60},
	{'beanstalk_chunk', 0.60},
	{'greenbean',       1.00},
	{'greenbean',       1.00},
	{'greenbean',       1.00},
	{'greenbean',       1.00},
	{'greenbean',       0.70},
	{'greenbean',       0.70},
	{'greenbean',       0.60},
	{'greenbean',       0.60},
	{'greenbean',       0.60},	
	{'bean_brain',      1.00},
}

---------------------------------------

-- Vine

VINE.HEALTH = 30
VINE.RANGE = 2
VINE.DAMAGE = 6
VINE.ATTACK_PERIOD = 5

VINE.SANITY_AURA = TUNING.SANITYAURA_LARGE * 0.5

VINE.WALKSPEED = 6.3
VINE.RUNSPEED = 6.3

-- Vine Brain

VINE.MAX_CHASE_TIME = 9
VINE.MAX_CHASE_DIST = 12

VINE.MAX_WANDER_DIST = 12

VINE.START_FACE_DIST = 8
VINE.KEEP_FACE_DIST = 10

VINE.MAX_CHARGE_DIST = 8
VINE.CHASE_GIVEUP_DIST = 10

-- Loot and Prefabs

VINE.PREFABS = {
    "beanstalk_chunk",
}

VINE.LOOT = {
	{'beanstalk_chunk',	0.80},
	{'beanstalk_chunk',	0.70},
	{'beanstalk_chunk',	0.50},
}

---------------------------------------

---------------------------------------

-- Alien

ALIEN.HEALTH = 30

ALIEN.WALKSPEED = 3.2

ALIEN.DAMAGE = 50
ALIEN.ATTACK_PERIOD = 5

ALIEN.SCALE = 0.6

ALIEN.COLOURS = {
    {198/255,43/255,43/255},
    {79/255,153/255,68/255},
    {35/255,105/255,235/255},
    {233/255,208/255,69/255},
    {109/255,50/255,163/255},
    {222/255,126/255,39/255},
}

-- Loot and Prefabs

ALIEN.PREFABS = {
    "nightmarefuel",
    "crystal_fragment_relic",
    "crystal_fragment_light",
    "crystal_fragment_spire",
    "crystal_fragment_water",
}

ALIEN.LOOT = {
    {'nightmarefuel', 0.80}
}

ALIEN.FRAGMENTS = {
    "crystal_fragment_relic",
    "crystal_fragment_light",
    "crystal_fragment_spire",
    "crystal_fragment_water",
}

--Chance for a fragment to drop.
ALIEN.RARECHANCE = 0.20

---------------------------------------

-- Marshmallow Bee

BEE_MARSHMALLOW.UNCHARGED_HEALTH = TUNING.BEE_HEALTH
BEE_MARSHMALLOW.CHARGED_HEALTH = TUNING.BEE_HEALTH

BEE_MARSHMALLOW.UNCHARGED_DAMAGE = 0
BEE_MARSHMALLOW.CHARGED_DAMAGE = TUNING.BEE_DAMAGE

BEE_MARSHMALLOW.UNCHARGED_ATTACK_PERIOD = TUNING.BEE_ATTACK_PERIOD
BEE_MARSHMALLOW.CHARGED_ATTACK_PERIOD = TUNING.BEE_ATTACK_PERIOD

BEE_MARSHMALLOW.UNCHARGED_SCALE = 1
BEE_MARSHMALLOW.CHARGED_SCALE = 2

BEE_MARSHMALLOW.FOODTYPE = "MEAT"
BEE_MARSHMALLOW.HEALTHVALUE = 0
BEE_MARSHMALLOW.HUNGERVALUE = 10
BEE_MARSHMALLOW.SANITYVALUE = -10

-- Loot and Prefabs

BEE_MARSHMALLOW.PREFABS = {
	"marshmallow",
	"bee_stinger",
}

BEE_MARSHMALLOW.LOOT = {
	{'marshmallow',	0.80},
	{'bee_stinger',	0.70},
}

BEE_MARSHMALLOW.NUMRANDOMLOOT = 1

---------------------------------------