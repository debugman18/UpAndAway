---------------------------------------

-- Winnie Staff

-- Max dist for a beefalo to become a follower.
WINNIE_STAFF.MAX_FOLLOWER_DIST = 20

-- Max beefalo followers.
WINNIE_STAFF.MAX_FOLLOWERS = 5

-- Sanity gain/loss per follower.
WINNIE_STAFF.SANITY_PER_FOLLOWER = -1

-- Keeps the follower(s) loyal.
WINNIE_STAFF.LOYALTY_TIME = 1.1

-- Rate of sanity gain/loss.
WINNIE_STAFF.UPDATE_RATE = 2.5

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
TEA_BUSH.REGROW_TIME = 3 * TUNING.TOTAL_DAY_TIME

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

AMBROSIA.HEALTH_VALUE = function() return math.random(-40,20) end
AMBROSIA.HUNGER_VALUE = function() return math.random(-40,20) end
AMBROSIA.SANITY_VALUE = function() return math.random(-40,20) end

---------------------------------------

-- Beanlet Armor

BEANLET_ARMOR.WALKMULTIPLIER = 1.3

BEANLET_ARMOR.ARMOR_HEALTH = 200
BEANLET_ARMOR.ARMOR_ABSORB = 0.5

---------------------------------------

-- Beanlet Lamp
-- Not to be confused with the Crystal Lamp

BEANLET_LAMP.RADIUS = 1.5
BEANLET_LAMP.FALLOFF = 1
BEANLET_LAMP.INTENSITY = 0.5

BEANLET_LAMP.WORK_TIME = 4

BEANLET_LAMP.PREFABS = {
    "lightning_rod_fx",
}

BEANLET_LAMP.LOOT = {

}

---------------------------------------

-- Beanlet Hut

BEANLET_HUT.RADIUS = 1
BEANLET_HUT.FALLOFF = 1
BEANLET_HUT.INTENSITY = 0.5

BEANLET_HUT.SCALE = 3

BEANLET_HUT.REGEN_PERIOD = 100
BEANLET_HUT.SPAWN_PERIOD = 20
BEANLET_HUT.MAX_CHILDREN = math.random(1,3)
BEANLET_HUT.CHILD = "beanlet"

BEANLET_HUT.WORK_TIME = 4

BEANLET_HUT.PROX_NEAR = 10
BEANLET_HUT.PROX_FAR = 13

-- Loot and Prefabs

BEANLET_HUT.PREFABS = {
    "beanlet",
    "boards",
    "petals",
}

BEANLET_HUT.LOOT = {
    {'boards',       1.0},
    {'boards',       1.0},    
    {'petals', 1.0},
    {'petals', 1.0},
    {'petals', 0.8},
    {'petals', 0.8},        
}

---------------------------------------

-- Beanstalk Chunk

BEANSTALK_CHUNK.MAX_SIZE = TUNING.STACK_SIZE_SMALLITEM

BEANSTALK_CHUNK.REPAIR_MATERIAL = "beanstalk"
BEANSTALK_CHUNK.REPAIR_VALUE = 5

BEANSTALK_CHUNK.FUEL_VALUE = 40

---------------------------------------

-- Beanstalk Wall

BEANSTALK_WALL.NUMRANDOMLOOT = 4

BEANSTALK_WALL.HEALTH = 20

BEANSTALK_WALL.BASE_GROW_TIME = 1.5*TUNING.TOTAL_DAY_TIME
BEANSTALK_WALL.SHORT_TIME_MODIFIER = 0.5*TUNING.TOTAL_DAY_TIME
BEANSTALK_WALL.NORMAL_TIME_MODIFIER = 0.8*TUNING.TOTAL_DAY_TIME
BEANSTALK_WALL.TALL_TIME_MODIFIER = 1.0*TUNING.TOTAL_DAY_TIME
BEANSTALK_WALL.OLD_TIME_MODIFIER = 1.0*TUNING.TOTAL_DAY_TIME

BEANSTALK_WALL.SCALE = 0.8

BEANSTALK_WALL.STACK_SIZE = TUNING.STACK_SIZE_MEDITEM

BEANSTALK_WALL.FUEL_VALUE = TUNING.SMALL_FUEL

BEANSTALK_WALL.FLAMMABILITY = 1

-- Loot and Prefabs

BEANSTALK_WALL.PREFABS = {
	"beanstalk_chunk",
	"beanstalk_wall_item",
}

BEANSTALK_WALL.STAGE0LOOT = {
	
}

BEANSTALK_WALL.STAGE1LOOT = {
	"beanstalk_chunk",
}	

BEANSTALK_WALL.STAGE2LOOT = {
	"beanstalk_chunk",		
}

BEANSTALK_WALL.STAGE3LOOT = {
	"beanstalk_chunk",
	"beanstalk_chunk",
}	

BEANSTALK_WALL.STAGE4LOOT = {
	"beanstalk_chunk",
	"beanstalk_chunk",
	"beanstalk_chunk",
	"beanstalk_chunk",			
}	

---------------------------------------

-- Cloud Algae

CLOUD_ALGAE.WORK_TIME = 1

CLOUD_ALGAE.SCALE = 1.5

-- Loot and Prefabs

CLOUD_ALGAE.PREFABS = {
	"cloud_algae_fragment",
}

CLOUD_ALGAE.LOOT = {
	"cloud_algae_fragment",
	"cloud_algae_fragment",
	"cloud_algae_fragment",
}

---------------------------------------

-- Cloud Algae Fragment 

CLOUD_ALGAE_FRAGMENT.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

CLOUD_ALGAE_FRAGMENT.FUEL_VALUE = 5

CLOUD_ALGAE_FRAGMENT.FOODTYPE = "VEGGIE"

CLOUD_ALGAE_FRAGMENT.HUNGER_VALUE = TUNING.CALORIES_SMALL
CLOUD_ALGAE_FRAGMENT.HEALTH_VALUE = 0
CLOUD_ALGAE_FRAGMENT.SANITY_VALUE = -TUNING.SANITY_TINY

CLOUD_ALGAE_FRAGMENT.PERISH_TIME = TUNING.PERISH_TWO_DAY
CLOUD_ALGAE_FRAGMENT.PERISH_ITEM = "spoiled_food"

---------------------------------------

-- Cloud Candy Bush

CLOUD_BUSH.COLOR = 0.5 + math.random() * 0.5

CLOUD_BUSH.GROW_TIME = TUNING.MARSHBUSH_REGROW_TIME

-- Loot and Prefabs

CLOUD_BUSH.PREFABS = {
    "cloud_cotton",
    "candy_fruit",
}

CLOUD_BUSH.CHARGED_DIG_LOOT = {
	"cloud_cotton",
	"cloud_cotton",
	"cloud_cotton",
	"candy_fruit",
}

CLOUD_BUSH.UNCHARGED_DIG_LOOT = {
	"cloud_cotton",
	"cloud_cotton",
	"cloud_cotton",
	"cloud_cotton",
}

CLOUD_BUSH.PICK_LOOT = "candy_fruit"
CLOUD_BUSH.PICK_QUANTITY = 2

---------------------------------------

-- Cloud Coral

CLOUD_CORAL.START_SCALE = math.random(1, 2)

CLOUD_CORAL.GROW_RATE = 0.7*TUNING.ROCKY_GROW_RATE

CLOUD_CORAL.WORK_TIME = 0.5*TUNING.ROCKS_MINE

-- Loot and Prefabs

CLOUD_CORAL.PREFABS = {
    "cloud_coral_fragment",
}

CLOUD_CORAL.DROP_RATE = 0.9

---------------------------------------

-- Cloud Coral Fragment

CLOUD_CORAL_FRAGMENT.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

---------------------------------------

-- Cauldron

-- This will be replaced by a unique FX.
CAULDRON.BURNFX = "campfirefire"
CAULDRON.BURNFX_POSX = 0
CAULDRON.BURNFX_POSY = 0.4
CAULDRON.BURNFX_POSZ = 0

CAULDRON.INGREDIENTS = {
    bonestew = true,
    cloud_jely = true,
    jellycap_red = true,
    jellycap_blue = true,
    jellycap_green = true,
    golden_petals = true,
    nightmarefuel = true,
    rocks = true,
    marble = true,
    poop = true,
    beardhair = true,
    dragonblood_log = true,
    charcoal = true,
    ash = true,	
}

---------------------------------------

-- Cloud Cotton

CLOUD_COTTON.SCALE = 2

CLOUD_COTTON.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

CLOUD_COTTON.FUEL_VALUE = 8

CLOUD_COTTON.FOODTYPE = "VEGGIE"
CLOUD_COTTON.HEALTH_VALUE = -4
CLOUD_COTTON.HUNGER_VALUE = 2
CLOUD_COTTON.SANITY_VALUE = 2

CLOUD_COTTON.PERISH_TIME = TUNING.PERISH_FAST
CLOUD_COTTON.PERISH_ITEM = "spoiled_food"

CLOUD_COTTON.REPAIR_MATERIAL = "cloud"
CLOUD_COTTON.REPAIR_VALUE = 3

---------------------------------------

-- Cloud Fruit

CLOUD_FRUIT.STACK_SIZE = TUNING.STACK_SIZE_LARGEITEM

CLOUD_FRUIT.FOODTYPE = "VEGGIE"

CLOUD_FRUIT.UNCOOKED_HEALTH_VALUE = -5
CLOUD_FRUIT.UNCOOKED_HUNGER_VALUE = 15
CLOUD_FRUIT.UNCOOKED_SANITY_VALUE = -20

CLOUD_FRUIT.COOKED_HEALTH_VALUE = -10
CLOUD_FRUIT.COOKED_HUNGER_VALUE = 40
CLOUD_FRUIT.COOKED_SANITY_VALUE = -40

CLOUD_FRUIT.COOKED_PRODUCT = "cloud_fruit_cooked"

CLOUD_FRUIT.UNCOOKED_PERISH_TIME = 300
CLOUD_FRUIT.COOKED_PERISH_TIME = 0.5 * CLOUD_FRUIT.UNCOOKED_PERISH_TIME
CLOUD_FRUIT.PERISH_ITEM = "spoiled_food"

---------------------------------------

-- Cloud Fruit Tree

CLOUD_FRUIT.WORK_TIME = 6

CLOUD_FRUIT_TREE.PICK_LOOT = "cloud_fruit"
CLOUD_FRUIT_TREE.PICK_REGEN = 100
CLOUD_FRUIT_TREE.PICK_QUANTITY = 1

-- Loot and Prefabs

CLOUD_FRUIT_TREE.PREFABS = {
	"cloud_fruit",
}

CLOUD_FRUIT.LOOT = {
		"thunder_log",
        "thunder_log"
}

CLOUD_FRUIT.LOOT_WITH_FRUIT = {
    "thunder_log",
    "thunder_log",
    "cloud_fruit"
}

---------------------------------------

-- Cloud Jelly

CLOUD_JELLY.FUEL_VALUE = 5
CLOUD_JELLY.FUEL_CLOUD = "poopcloud"

CLOUD_JELLY.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

CLOUD_JELLY.FOODTYPE = "VEGGIE"
CLOUD_JELLY.HEALTH_VALUE = 0
CLOUD_JELLY.HUNGER_VALUE = 16
CLOUD_JELLY.SANITY_VALUE = -30

CLOUD_JELLY.PERISH_TIME = TUNING.PERISH_SLOW
CLOUD_JELLY.PERISH_ITEM = "ash"

---------------------------------------

-- Candy Fruit

CANDY_FRUIT.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

CANDY_FRUIT.FOODTYPE = "VEGGIE"
CANDY_FRUIT.HEALTH_VALUE = -2
CANDY_FRUIT.HUNGER_VALUE = 5
CANDY_FRUIT.SANITY_VALUE = 10

CANDY_FRUIT.PERISH_TIME = 700
CANDY_FRUIT.PERISH_ITEM = "honey"

CANDY_FRUIT.FUEL_VALUE = 5

---------------------------------------

-- Cotton Candy

COTTON_CANDY.SPEED_DEBUFF = 2
COTTON_CANDY.DEBUFF_TIME = 4

COTTON_CANDY.DAMAGE = 15

COTTON_CANDY.PERISH_TIME = 0.5 * TUNING.PERISH_MED
COTTON_CANDY.PERISH_ITEM = "cloud_cotton"

COTTON_CANDY.FOODTYPE = "VEGGIE"
COTTON_CANDY.HEALTH_VALUE = -15
COTTON_CANDY.HUNGER_VALUE = 20
COTTON_CANDY.SANITY_VALUE = 25

COTTON_CANDY.REPAIR_MATERIAL = "cloud"
COTTON_CANDY.REPAIR_VALUE = 15

COTTON_CANDY.MELT_INTERVAL = 0.5
COTTON_CANDY.MELT_VALUE = 0.05

---------------------------------------
 
-- Cloud Crag

CLOUD_CRAG.WORK_TIME = 0.7 * TUNING.ROCKS_MINE

-- Loot and Prefabs

CLOUD_CRAG.PREFABS = {
    "cloud_cotton",
    "rocks",
}    

CLOUD_CRAG.LOOT = {
	{'cloud_cotton',	0.70},	
	{'cloud_cotton',	0.70},
	{'cloud_cotton',	0.50},
	{'rocks',	        0.70},
	{'rocks',	        0.70},
	{'rocks',	        0.50},
}

---------------------------------------

-- Cloud Wall

CLOUD_WALL.SCALE = 3.2

CLOUD_WALL.STACK_SIZE = TUNING.STACK_SIZE_MEDITEM

CLOUD_WALL.HEALTH = 30

CLOUD_WALL.REPAIR_MATERIAL = "cloud_cotton"
CLOUD_WALL.REPAIR_VALUE = CLOUD_WALL.HEALTH / 6
CLOUD_WALL.WORK_REPAIR = TUNING.REPAIR_THULECITE_WORK

CLOUD_WALL.WORK_TIME = 1

CLOUD_WALL.PROX_FAR = 6
CLOUD_WALL.PROX_NEAR = 2

CLOUD_WALL.ALPHA = 0.75

-- Loot and Prefabs

CLOUD_WALL.PREFABS = {
    "cloud_wall_item",
    "cloud_cotton",
}

CLOUD_WALL.LOOT = {
    {"cloud_cotton", 1.0},
    {"cloud_cotton", 1.0},
    {"cloud_cotton", 1.0},
}

CLOUD_WALL.NUMRANDOMLOOT = 4

---------------------------------------

-- Gem Corn

GEM_CORN.FOODTYPE = "VEGGIE"
GEM_CORN.HEALTH_VALUE = 15
GEM_CORN.HUNGER_VALUE = 60
GEM_CORN.SANITY_VALUE = 15

GEM_CORN.STACK_SIZE = TUNING.STACK_SIZE_LARGEITEM

---------------------------------------

-- Cotton Hat

COTTON_HAT.INSULATION = TUNING.INSULATION_LARGE * 1.2

COTTON_HAT.FUEL = TUNING.SWEATERVEST_PERISHTIME * 0.6

COTTON_HAT.MELT_INTERVAL = 0.5
COTTON_HAT.MELT_VALUE = -25

---------------------------------------

-- Cotton Vest

CLOUD_VEST.DAPPERNESS = TUNING.DAPPERNESS_TINY * 1.5

CLOUD_VEST.FUEL = TUNING.SWEATERVEST_PERISHTIME * 0.6

CLOUD_VEST.MELT_INTERVAL = 0.5
CLOUD_VEST.MELT_VALUE = -25

CLOUD_VEST.INSULATION = TUNING.INSULATION_LARGE * 1.1

---------------------------------------

-- Dragonblood Log

DRAGONBLOOD.STACK_SIZE = 10

DRAGONBLOOD.SPREAD_RANGE = 5

DRAGONBLOOD.HEAT = 300

DRAGONBLOOD.FUEL_VALUE = 30

DRAGONBLOOD.INSULATION = TUNING.INSULATION_MED
DRAGONBLOOD.TEMPERATURE = 2

-- Loot and Prefabs

DRAGONBLOOD.PREFABS = {
    "lavalight",
    "campfirefire_dragon",
}

---------------------------------------

-- Crystal Fragments

CRYSTAL_FRAGMENT.STACK_SIZE = TUNING.STACK_SIZE_SMALLITEM

CRYSTAL_FRAGMENT.FUEL_VALUE = 15
CRYSTAL_FRAGMENT.FUEL_TYPE = "CRYSTAL"

CRYSTAL_FRAGMENT.REPAIR_VALUE = 5
CRYSTAL_FRAGMENT.REPAIR_MATERIAL = "crystal"

---------------------------------------

-- Crystal Lamp

CRYSTAL_LAMP.FUEL = 100
CRYSTAL_LAMP.START_FUEL = 60
CRYSTAL_LAMP.FUEL_RATE = 0.7
CRYSTAL_LAMP.FUEL_TYPE = "CRYSTAL"

CRYSTAL_LAMP.WORK_TIME = 4

CRYSTAL_LAMP.FALLOFF = 5
CRYSTAL_LAMP.INTENSITY = 0.7

CRYSTAL_LAMP.RADIUS_MODIFIER = 20

CRYSTAL_LAMP.EMPTY_VALUE = 2

---------------------------------------

-- Crystals

CRYSTAL.WORK_TIME = TUNING.ROCKS_MINE * 1.1

CRYSTAL.SCALE = function() return math.random(3,4) end

CRYSTAL_BLACK.SCALE = 2.4
CRYSTAL_BLACK.CHILD = "owl"
CRYSTAL_BLACK.REGEN_PERIOD = TUNING.TOTAL_DAY_TIME * 7
CRYSTAL_BLACK.SPAWN_PERIOD = 10
CRYSTAL_BLACK.MAX_CHILDREN = 2

CRYSTAL_LIGHT.FALLOFF = 0.5
CRYSTAL_LIGHT.INTENSITY = 0.8
CRYSTAL_LIGHT.RADIUS = 1.5

CRYSTAL_RELIC.CHILD = "owl"
CRYSTAL_RELIC.DENSITY_A = 5
CRYSTAL_RELIC.DENSITY_B = 3
CRYSTAL_RELIC.SPACING = 5 

-- Loot and Prefabs

CRYSTAL.PREFABS = {
    "owl",
    "flying_fish",
    "crystal_fragment_relic",
	"crystal_fragment_black",
	"crystal_fragment_light",
	"crystal_fragment_quartz",
	"crystal_fragment_spire",
	"crystal_fragment_water",
	"crystal_fragment_white",
}

CRYSTAL_WATER.LOOT = {
    {"crystal_fragment_water", 1.0},
}

CRYSTAL_SPIRE.LOOT = {
    {"crystal_fragment_spire", 1.0},
}

CRYSTAL_WHITE.LOOT = {
    {"crystal_fragment_white", 1.0},
    {"crystal_fragment_white", 1.0},
    {"crystal_fragment_white", 0.9},
    {"crystal_fragment_white", 0.8},
    {"crystal_fragment_white", 0.7},
}

CRYSTAL_QUARTZ.LOOT = {
    {"crystal_fragment_quartz", 1.0},
    {"crystal_fragment_quartz", 1.0},
    {"crystal_fragment_quartz", 1.0},
}

CRYSTAL_LIGHT.LOOT = {
    {"crystal_fragment_light", 1.0},
    {"crystal_fragment_light", 1.0},
    {"crystal_fragment_light", 1.0},
}

CRYSTAL_BLACK.LOOT = {
    {"crystal_fragment_black", 1.0},
    {"crystal_fragment_black", 1.0},
    {"crystal_fragment_black", 0.9},
    {"crystal_fragment_black", 0.5},
}

CRYSTAL_RELIC.LOOT = {
    {"crystal_fragment_relic", 1.0},
    {"crystal_fragment_relic", 1.0},
    {"crystal_fragment_relic", 1.0},
}

---------------------------------------

-- Dragonblood Sap

DRAGONBLOOD_SAP.STACK_SIZE = 20

DRAGONBLOOD_SAP.HEALTH_VALUE = 15
DRAGONBLOOD_SAP.HUNGER_VALUE = 7
DRAGONBLOOD_SAP.SANITY_VALUE = 0

DRAGONBLOOD_SAP.PERISH_TIME = TUNING.PERISH_FAST
DRAGONBLOOD_SAP.PERISH_ITEM = "spoiled_food"

DRAGONBLOOD_SAP.HEAT_CAPACITY = 0.15

---------------------------------------

-- Dragonblood Tree

DRAGONBLOOD_TREE.WORK_TIME = 3

DRAGONBLOOD_TREE.SHORT_SCALE = 0.75
DRAGONBLOOD_TREE.NORMAL_SCALE = 0.9
DRAGONBLOOD_TREE.TALL_SCALE = 1

DRAGONBLOOD_TREE.BASE_GROW_TIME = TUNING.EVERGREEN_GROW_TIME[2].base
DRAGONBLOOD_TREE.RAND_GROW_TIME = TUNING.EVERGREEN_GROW_TIME[2].random

-- Loot and Prefabs

DRAGONBLOOD_TREE.PREFABS = {
	"dragonblood_log",
	"dragonblood_sap",
}

DRAGONBLOOD_TREE.DUG_LOOT = {
	"dragonblood_log",
	"dragonblood_log",
	"dragonblood_sap",
}

DRAGONBLOOD_TREE.SHORT_LOOT = {
	"dragonblood_log",
	"dragonblood_log",	
}

DRAGONBLOOD_TREE.NORMAL_LOOT = {
	"dragonblood_log",
	"dragonblood_log",
	"dragonblood_log",	
}

DRAGONBLOOD_TREE.TALL_LOOT = {
	"dragonblood_log",
	"dragonblood_log",
	"dragonblood_log",
	"dragonblood_log",	
	"dragonblood_sap",	
}

---------------------------------------

-- Cumulostone

CUMULOSTONE.STACK_SIZE = TUNING.STACK_SIZE_LARGEITEM

---------------------------------------

-- Skyflower and Datura

SKYFLOWER.PICK_SANITY = TUNING.SANITY_TINY - 1
DATURA.PICK_SANITY = TUNING.SANITY_TINY + 1

SKYFLOWER.REGEN_PERIOD = 40

SKYFLOWER.SANITY_AURA = SKYFLOWER.PICK_SANITY / 6
DATURA.SANITY_AURA = DATURA.PICK_SANITY / 6

-- Loot and Prefabs

SKYFLOWER.PREFABS = {
    "skyflower_petals",
    "datura_petals",
}  

---------------------------------------

-- Skyflower Petals

---------------------------------------

-- Cookpot Foods

COOKEDJELLY.COOK_TIME = 0.75
COOKEDJELLY.PERISH_TIME = TUNING.PERISH_MED

GREENJELLY.HEALTH_VALUE = 20
GREENJELLY.HUNGER_VALUE = 20
GREENJELLY.SANITY_VALUE = -60

REDJELLY.HEALTH_VALUE = 10
REDJELLY.HUNGER_VALUE = 40
REDJELLY.SANITY_VALUE = -50

---------------------------------------

-- Rubber

RUBBER.FOODTYPE = "VEGGIE"
RUBBER.HEALTH_VALUE = 0
RUBBER.HUNGER_VALUE = -40
RUBBER.SANITY_VALUE = -80

---------------------------------------

-- Golden Petals

GOLD_PETALS.STACK_SIZE = 10

GOLD_PETALS.FUEL_VALUE = 30

GOLD_PETALS.FOODTYPE = "VEGGIE"
GOLD_PETALS.HEALTH_VALUE = 0
GOLD_PETALS.HUNGER_VALUE = 5
GOLD_PETALS.SANITY_VALUE = 5

---------------------------------------

-- Golden Rose

---------------------------------------

-- Golden Sunflower

---------------------------------------

-- Golden Sunflower Seeds

---------------------------------------

-- Marhsmallow Hive

---------------------------------------

-- Jellyshrooms

---------------------------------------

-- Kettle

---------------------------------------

-- Gustflower

---------------------------------------

-- Gustflower Seeds

---------------------------------------

-- Marshmallow

---------------------------------------

-- Pineapple

---------------------------------------

-- Shopkeeper Umbrella

---------------------------------------

-- Smores

---------------------------------------

-- Thunder Pinecone

---------------------------------------

-- Thunder Tree

---------------------------------------

-- Weavernest

---------------------------------------

-- Wind Axe

---------------------------------------
