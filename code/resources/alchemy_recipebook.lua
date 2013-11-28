--[[
-- List of refining recipes.
--]]



-- Syntax conveniences.
BindModModule 'lib.brewing'


--[[
-- You don't need to use verbal keys for the recipes, you could just
-- list them. I'm keeping them for organization, since the product
-- prefab doesn't exist yet.
--]]

local potions = {
	sweet = Recipe("honey", Ingredient("taffy"), 0),
}

--[[
-- Here you can list either individual recipes or tables of them. The RecipeBook
-- takes care of "flattening" the tables into a single list of recipes.
--]]
return RecipeBook {
	potions,
}
