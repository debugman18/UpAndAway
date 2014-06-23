--[[
-- List of brewing recipes.
--]]



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
	white = Recipe("whitetea", Ingredient("tea_leaves", 2), 0),
}

local veggie_teas = {
	berry = Recipe("berrytea", Ingredient("berries") + Ingredient("tea_leaves"), 0),
	berrypulp = Recipe("berrypulptea", Ingredient("berries", 2), 0),	
	greengreen = Recipe("greengreentea", Ingredient("tea_leaves") + Ingredient("greenbean", 1), 0),	
}

local flower_teas = {
	petal = Recipe("petaltea", Ingredient("petals", 2), 0),
	evilpetal = Recipe("evilpetaltea", Ingredient("petals_evil", 2), 0),
	mixedpetal = Recipe("mixedpetaltea", Ingredient("petals_evil") + Ingredient("petals"), 0),
	floral = Recipe("floraltea", Ingredient("tea_leaves") + Ingredient("petals"), 0),
	skypetal = Recipe("skypetaltea", Ingredient("skyflower_petals", 2), 0),
	datura = Recipe("daturatea", Ingredient("datura_petals", 2), 0),	
}

local sweet_teas = {
	green = Recipe("sweet_greentea", teas.green:GetCondition() + Ingredient("honey"), 1),
	black = Recipe("sweet_blacktea", teas.black:GetCondition() + Ingredient("honey"), 1),
	white = Recipe("sweet_whitetea", teas.white:GetCondition() + Ingredient("honey"), 1),
}

return RecipeBook {
	teas,
	sweet_teas,
	flower_teas,
	veggie_teas,

	Recipe(basic_cfg:GetConfig("SPOILED_PREFAB"), Lambda.True, -math.huge),
}
