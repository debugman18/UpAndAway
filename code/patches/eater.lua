---
-- Extends the eater component in DST to support DS methods.
--
-- @author simplex


local Eater = require "components/eater"

if IsDST() then
	local FT = assert(_G.FOODTYPE)

	local diets = {
		Vegetarian = FT.VEGGIE,
		Carnivore = FT.MEAT,
		Insectivore = FT.INSECT,
		Bird = FT.SEEDS,
		Beaver = FT.WOOD,
		Elemental = FT.ELEMENTAL,
	}

	for diet, prefs in pairs(diets) do
		if type(prefs) ~= "table" then
			prefs = {{prefs}, {prefs}}
		end
		local mname = "Set"..diet
		if Eater[mname] == nil then
			Eater[mname] = function(self)
				self:SetDiet(unpack(prefs))
			end
		end
	end
end
