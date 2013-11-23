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

teas.sweet_green = Recipe("sweet_greentea", teas.green:GetCondition() + Ingredient("honey"), 1)
teas.sweet_black = Recipe("sweet_blacktea", teas.black:GetCondition() + Ingredient("honey"), 1)


local function squash(...)
	local ret = {}
	for _, t in ipairs{...} do
		for _, v in pairs(t) do
			table.insert(ret, v)
		end
	end
	return ret
end

return RecipeBook(squash(
	teas,

	{Recipe(basic_cfg:GetConfig("SPOILED_PREFAB"), Lambda.True, -math.huge)}
))
