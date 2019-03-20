-- Do some lazy stuff here.

local AllRecipes = _G.GetAllRecipes
local builder = _G.require "components/builder"
local hardKnowsRecipe = builder.KnowsRecipe

local function KnowsRecipe(recname)
	local result = hardKnowsRecipe(recname)

	if result then
		if self.freebuildmode or table.contains(self.recipes, recname) then
			return true
		end

		local recipe = AllRecipes[recname]

		if recipe.level[FABLE] > 0 then
			return false
		end
	end

	return result
end

TheMod:AddClassPostConstruct("components/builder", KnowsRecipe)