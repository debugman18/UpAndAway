--[[
-- List of brewing recipes.
--]]

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire 'paradigms.functional'

local Configurable = wickerrequire 'adjectives.configurable'
local basic_cfg = Configurable("HOTBEVERAGE")
local tea_cfg = Configurable("HOTBEVERAGE", "TEA")


-- Syntax conveniences.
BindModModule 'lib.brewing'

--[[
-- Keep in mind that Recipe, Ingredient, etc. are not the vanilla ones,
-- but those defined in lib.brewing.
--]]

local teas = {
	green = Recipe("greentea", Ingredient("tea_leaves"), 0),
	black = Recipe("blacktea", Ingredient("blacktea_leaves"), 0),
}

local sweet_teas = {
	green = Recipe("sweet_greentea", teas.green:GetCondition() + Ingredient("honey"), 1),
	black = Recipe("sweet_blacktea", teas.black:GetCondition() + Ingredient("honey"), 1),
}

return RecipeBook {
	teas,
	sweet_teas,

	Recipe(basic_cfg:GetConfig("SPOILED_PREFAB"), Lambda.True, -math.huge),
}
