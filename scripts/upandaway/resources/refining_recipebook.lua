--[[
-- List of refining recipes.
--]]

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


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
	refined_coral = Recipe("cutgrass", Ingredient("cloud_algae_fragment", 2), 0),
	refined_beans = Recipe("twigs", Ingredient("beanstalk_chunk", 2), 0),
	refined_sugar = Recipe("honey", Ingredient("candy_fruit", 4), 0),
	refined_silk = Recipe("silk", Ingredient("cloud_cotton", 4), 0),
}
