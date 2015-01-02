--[[
-- List of refining recipes.
--]]



-- Syntax conveniences.
BindModModule "lib.brewing"


--[[
-- You don't need to use verbal keys for the recipes, you could just
-- list them. I'm keeping them for organization, since the product
-- prefab doesn't exist yet.
--]]

local potions = {
    --tunnel = Recipe("potion_tunnel", Ingredient("rocks") + Ingredient("marble") + Ingredient("flint") + Ingredient("nightmarefuel"), 0, 1),
    dragon = Recipe("potion_dragon", Ingredient("dragonblood_log") + Ingredient("charcoal") + Ingredient("ash") + Ingredient("nightmarefuel"), 0, 1),
    doubles = Recipe("potion_doubles", Ingredient("redcap") + Ingredient("bluecap") + Ingredient("greencap") + Ingredient("nightmarefuel"), 0, 1),
    triples = Recipe("potion_triples", Ingredient("jellycap_red") + Ingredient("jellycap_blue") + Ingredient("jellycap_green") + Ingredient("nightmarefuel"), 0, 1),
    bearded = Recipe("potion_bearded", Ingredient("beardhair", 2) + Ingredient("berries") + Ingredient("nightmarefuel"), 0, 1),
}

local foods = {
    deadlyfeast = Recipe("deadlyfeast", Ingredient("bonestew", 1) + Ingredient("nightmarefuel", 3), 0, 1),
    jammyred = Recipe("jammypreserves", Ingredient("jellycap_red", 3) + Ingredient("cloud_jelly", 1), 0, 1),
    jammyblue = Recipe("jammypreserves", Ingredient("jellycap_blue", 3) + Ingredient("cloud_jelly", 1), 0, 1),
    jammygreen = Recipe("jammypreserves", Ingredient("jellycap_green", 3) + Ingredient("cloud_jelly", 1), 0, 1),		
}
--[[
-- Here you can list either individual recipes or tables of them. The RecipeBook
-- takes care of "flattening" the tables into a single list of recipes.
--]]
return RecipeBook {
    potions,
    foods,

    Recipe("wetgoop", Lambda.True, -math.huge)
}
