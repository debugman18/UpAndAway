local _G = GLOBAL
local Builder = _G.require "components/builder"


Builder.KnowsRecipe = (function()
	local bonus_map = {
		ANCIENT = "ancient_bonus",
		MAGIC = "magic_bonus",
		SCIENCE = "science_bonus",
	}

	return function(self, recname)
		local recipe = _G.GetRecipe(recname)
	 
		if recipe then
			local is_intrinsic = true

			for k, v in pairs(recipe.level) do
				if not bonus_map[k] or self[bonus_map[k]] >= v then
					is_intrinsic = false
					break
				end
			end

			if is_intrinsic then
				return true
			end
		end
	 
		return self.freebuildmode or _G.table.contains(self.recipes, recname)
	end
end)()
