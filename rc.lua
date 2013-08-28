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
NEW_TILES = {"poopcloud"}

SHOPKEEPER = {}

-- Number of beans the Shopkeeper has.
-- (should we make it regen with time?)
SHOPKEEPER.NUMBEANS = 3

-- Defining functions in the cfg file should be limited for very simple things,
-- since the environment is very slim.
SHOPKEEPER.IS_A_COW = function(inst)
	return inst.prefab == "beefalo"
end

-- Maximum distance for a cow to be negotiated.
SHOPKEEPER.MAX_COW_DIST = 12

DEBUG = true
