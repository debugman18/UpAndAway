--[[
-- List of refining recipes.
--]]



-- Syntax conveniences.
BindModModule 'lib.brewing'

--[[
-- You don't need to use verbal keys for the recipes, you could just
-- list them. I'm just keeping them for organization.
--
-- The keys below are discarded, only the recipe values matter.
--]]
return RecipeBook {
	refined_rocks = Recipe("rocks", Ingredient("cloud_coral_fragment", 2), 0),
	refined_grass = Recipe("cutgrass", Ingredient("cloud_algae_fragment", 2), 0),
	refined_twigs = Recipe("twigs", Ingredient("beanstalk_chunk", 2), 0),
	refined_honey = Recipe("honey", Ingredient("candy_fruit", 4), 0),
	refined_silk = Recipe("silk", Ingredient("cloud_cotton", 4), 0),
	refined_petals = Recipe("petals", Ingredient("golden_petals", 1), 0),
	refined_jelly1 = Recipe("jammypreserves", Ingredient("jellycap_red", 3), 0),
	refined_jelly2 = Recipe("jammypreserves", Ingredient("jellycap_blue", 3), 0),
	refined_jelly3 = Recipe("jammypreserves", Ingredient("jellycap_green", 3), 0),
	refined_gold = Recipe("goldnugget", Ingredient("golden_petals", 4), 1),
	refined_ash = Recipe("ash", Ingredient("cloud_jelly", 1), 1),
	refined_feast = Recipe("deadlyfeast", Ingredient("bonestew", 1), 1)
}
