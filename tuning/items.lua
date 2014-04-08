HOTBEVERAGE.INHERENT_INSULATION = 60
HOTBEVERAGE.SPOILED_PREFAB = "wetgoop"

--[[
-- The following refers to *brewed* tea.
--]]
HOTBEVERAGE.TEA.HEAT_CAPACITY = 0.15
HOTBEVERAGE.TEA.PERISH_TIME = 1.5*TUNING.TOTAL_DAY_TIME

BREWER.BASE_BREW_TIME = 15

--[[
-- The following refers to tea *leaves*.
--]]
TEA_LEAF.SPOILED_PREFAB = "wetgoop"

--[[
-- The following refers to tea *bushes".
--]]
TEA_BUSH.CYCLES = 5
TEA_BUSH.REGROW_TIME = 5*TUNING.TOTAL_DAY_TIME

--[[
-- Staves.
--]]
STAFF.BLACK.USES = 5
-- How long the forced static induced by it lasts.
STAFF.BLACK.EFFECT_DURATION = 120

--[[
-- Golden egg.
--]]
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

--[[
-- Mushroom hat.
--]]
MUSHROOM_HAT.DURABILITY = TUNING.PERISH_MED
-- Average time spent in a single status effect state.
MUSHROOM_HAT.PERSISTENCY = 20
-- Rates of the different states, in points of stat per second.
-- A single state may affect more than one stat, and their names are arbitrary.
MUSHROOM_HAT.STATES = {
	HEALTH_INCREASE = {health = 1},
	HEALTH_DECREASE = {health = -0.8},
	HUNGER_INCREASE = {hunger = 1},
	HUNGER_DECREASE = {hunger = -0.8},
	SANITY_INCREASE = {sanity = 0.5},
	SANITY_DECREASE = {sanity = -1.5},
}
-- Period between widget announcements of stat change.
MUSHROOM_HAT.NAGGING_PERIOD = 3
