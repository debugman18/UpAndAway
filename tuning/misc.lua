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
NEW_TILES = {"poopcloud", "aurora", "snow", "rainbow"}

--[[
-- Defines the fire extinguish speed (relative to its total burn time)
-- within cloud levels. Indexed by the level height.
--
-- An infinite value means instant extinguishing.
--]]
FIRE.EXTINGUISH.SPEED = {
	[1] = 4,

	default = math.huge
}
