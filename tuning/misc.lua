---------------------------------------

--[[
-- List here the new tile names, in lowercase.
--
-- All the asset insertion, tile adding, etc. is done automagically by
-- inserting a new entry. Each entry is assumed to have a tile texture, a tile
-- atlas, a noise texture and a minimap noise texture.
--
-- For now, avoid removing entries and/or reordering them, otherwise savedata
-- for new tiles will get messed up (creating a new save will fix it, though).
--]]
NEW_TILES = {
	"poopcloud", 
	"aurora", 
	"snow", 
	"rainbow", 
	"cloudswirl", 
	"cloudland", 
	"snowtwo", 
	"auroratwo",
	"rainbowtwo"
}

---------------------------------------

--[[
-- Defines the fire extinguish speed (relative to its total burn time)
-- within cloud levels. Indexed by the level height.
--
-- An infinite value means instant extinguishing.
--]]
FIRE.EXTINGUISH.SPEED = {
	[1] = 3,

	default = math.huge
}

---------------------------------------

-- The level of bean hate to spawn a bean giant.
BEANHATED.THRESHOLD = 10
-- How long it takes (seconds) to reduce the bean hate level in 1 unit.
BEANHATED.DECAY_DELAY = 120

---------------------------------------

-- Static Conductor component.

STATIC_CONDUCTOR.SHOCK_RANGE = 5
STATIC_CONDUCTOR.SHOCK_DAMAGE = 5
STATIC_CONDUCTOR.RATE = 3
