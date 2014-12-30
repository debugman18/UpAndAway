---------------------------------------

-- Brewed Tea

BEVERAGE.INHERENT_INSULATION = 60
BEVERAGE.SPOILED_PREFAB = "spoiledtea"

BEVERAGE.TEA.HEAT_CAPACITY = 0.15
BEVERAGE.TEA.PERISH_TIME = 1.5*TUNING.TOTAL_DAY_TIME

BREWER.BASE_BREW_TIME = 15

---------------------------------------

-- Tea Leaves

TEA_LEAF.SPOILED_PREFAB = "wetgoop"

---------------------------------------

-- Tea Bush

TEA_BUSH.CYCLES = 4
TEA_BUSH.REGROW_TIME = 3*TUNING.TOTAL_DAY_TIME

---------------------------------------

-- Black and White Staves

STAFF.BLACK.USES = 5
STAFF.WHITE.USES = 3

-- How long the forced static induced by it lasts.
STAFF.BLACK.EFFECT_DURATION = 120

---------------------------------------

-- Wind Axe

WIND_AXE.WEAPON_USES = 20
WIND_AXE.TOOL_USES = math.floor( 0.8*TUNING.AXE_USES )
WIND_AXE.TARGET_LIGHTNING_CHANCE = 1/4
WIND_AXE.OWNER_LIGHTNING_CHANCE = 1/4
WIND_AXE.WHIRLWIND_CHANCE = 1/30

---------------------------------------

-- Golden Egg

-- How long a golden egg lasts at 30 degrees.
GOLDEN_EGG.BASE_PERISH_TIME = 3*TUNING.TOTAL_DAY_TIME

-- Minimum and maximum temperature.
GOLDEN_EGG.MIN_TEMP = -10
GOLDEN_EGG.MAX_TEMP = 120

-- Initial temperature.
GOLDEN_EGG.INITIAL_TEMP = 0.75*GOLDEN_EGG.MAX_TEMP

-- How long it takes for the egg's temperature to increase 100 degrees
-- during static.
GOLDEN_EGG.BASE_CHARGE_TIME = TUNING.TOTAL_DAY_TIME/4

---------------------------------------

-- Mushroom Hat

MUSHROOM_HAT.DURABILITY = TUNING.PERISH_MED

-- Base value for the persistency in one hat state.
local BASE_MUSHHAT_PERSIST = 12 

-- Rates of the different states, in points of stat per second.
-- A single state may affect more than one stat, and their names are arbitrary.
-- The persistency function defines the average time spent in the state, taking
-- as its argument the current freshness of the hat.
MUSHROOM_HAT.STATES = {
	HEALTH_INCREASE = {
		effects = {
			health = 1
		},
		persistency = function(f)
			return 1 + 0.6*BASE_MUSHHAT_PERSIST*f
		end,
	},
	HEALTH_DECREASE = {
		effects = {
			health = -0.8
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.8*f)
		end,
	},
	HUNGER_INCREASE = {
		effects = {
			hunger = 1
		},
		persistency = function(f)
			return 1 + 0.7*BASE_MUSHHAT_PERSIST*f
		end,
	},
	HUNGER_DECREASE = {
		effects = {
			hunger = -0.8
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.6*f)
		end,
	},
	SANITY_INCREASE = {
		effects = {
			sanity = 0.5
		},
		persistency = function(f)
			return 1 + 0.8*BASE_MUSHHAT_PERSIST*f
		end,
	},
	SANITY_DECREASE = {
		effects = {
			sanity = -1.5
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.4*f)
		end,
	},
}

-- Period between widget announcements of stat change.
MUSHROOM_HAT.NAGGING_PERIOD = 3

---------------------------------------

-- Winnie Staff

-- Max dist for a beefalo to become a follower.
WINNIE_STAFF.MAX_FOLLOWER_DIST = 20

-- Max beefalo followers.
WINNIE_STAFF.MAX_FOLLOWERS = 5

---------------------------------------

-- Magnet

-- Attraction radius for ball_lightning from magnets.
MAGNET.ATTRACTION_RADIUS = 16

---------------------------------------

-- Flying Fish

FLYING_FISH.ONPERISH_ITEM = "spoiled_food"
FLYING_FISH.PROJECTILE_SPEED = 2

FLYING_FISH.RAW_PERISH_TIME = TUNING.PERISH_FAST
FLYING_FISH.DEAD_PERISH_TIME = TUNING.PERISH_SUPERFAST
FLYING_FISH.COOKED_PERISH_TIME = TUNING.PERISH_MED

FLYING_FISH.RAW_HEALTH_VALUE = TUNING.HEALING_TINY
FLYING_FISH.RAW_HUNGER_VALUE = TUNING.CALORIES_SMALL
FLYING_FISH.RAW_SANITY_VALUE = 0

FLYING_FISH.COOKED_HEALTH_VALUE = TUNING.HEALING_TINY
FLYING_FISH.COOKED_HUNGER_VALUE = TUNING.CALORIES_SMALL
FLYING_FISH.COOKED_SANITY_VALUE = 0

FLYING_FISH.DEAD_HEALTH_VALUE = TUNING.HEALING_TINY
FLYING_FISH.DEAD_HUNGER_VALUE = TUNING.CALORIES_SMALL
FLYING_FISH.DEAD_SANITY_VALUE = 0

FLYING_FISH.COOKED_PRODUCT = "flying_fish_cooked"

FLYING_FISH.DRY_TIME = TUNING.DRY_FAST
FLYING_FISH.DRIED_PRODUCT = "smallmeat_dried"

FLYING_FISH.GOLD_VALUE = TUNING.GOLD_VALUES.MEAT

FLYING_FISH.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

FLYING_FISH.WORK_TIME = 1

-- Loot and Prefabs

FLYING_FISH.PREFABS = {
    "flying_fish_cooked",
    "spoiled_food",
}

---------------------------------------

-- Ambrosia

AMBROSIA.FOODTYPE = "VEGGIE"

CFG.AMBROSIA.HEALTHVALUE = function() return math.random(-40,20) end
CFG.AMBROSIA.HUNGERVALUE = function() return math.random(-40,20) end
CFG.AMBROSIA.SANITYVALUE = function() return math.random(-40,20) end

---------------------------------------

-- Beanlet Armor

---------------------------------------

-- Beanlet Lamp

---------------------------------------

-- Beanstalk Chunk

---------------------------------------

-- Beanstalk Wall

---------------------------------------

-- Dragonblood Log

---------------------------------------

