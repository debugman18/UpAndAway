local _G = GLOBAL

--[[
-- Receives the name of the new tech branch and its max level. The max level
-- is used to create entries in TECH. If, say, name == "SHENANIGANS", these
-- entries have the form TECH.SHENANIGANS_1, TECH_SHENANIGANS_2, ... with
-- the number going up to maxlevel.
--
-- For uniformity with the game's own tech trees, it's best to use an
-- uppercase name.
--]]
function AddTechBranch(name, maxlevel)
	-- Inserts the new branch in the TECH predef trees.
	for _, v in pairs(_G.TECH) do
		v[name] = v[name] or 0
	end

	-- The same, but for the prototyper trees.
	for _, v in pairs(_G.TUNING.PROTOTYPER_TREES) do
		v[name] = v[name] or 0
	end

	-- And now we create our own predefs.
	for i = 1, (maxlevel or 1) do
		local newtech = {[name] = i}
		for k, v in pairs(_G.TECH.NONE) do
			newtech[k] = newtech[k] or v
		end
		_G.TECH[("%s_%d"):format(name, i)] = newtech
	end

	--[[
	-- The following is needed to reset the custom tech level when
	-- leaving proximity. It is not needed for vanilla branches,
	-- but for custom ones it is (see Builder:EvaluateTechTrees() for
	-- details).
	--
	-- An alternative would be to do this resetting through the onturnoff
	-- callback of the Prototyper component, like Heavenfall does, but that
	-- requires assuming that the only builder entity in the game is the
	-- player, so I prefer this method. Neither of them are clean enough
	-- by my judgement, though: the Builder component has far too much
	-- hardcoded logic.
	--]]
	local Builder = _G.require "components/builder"
	Builder.EvaluateTechTrees = (function()
		local oldEval = Builder.EvaluateTechTrees

		return function(self)
			local had_prototyper = self.current_prototyper

			oldEval(self)

			if had_prototyper and not self.current_prototyper then
				-- If there is a prototyper, it'll take care of setting the
				-- values right.
				self.accessible_tech_trees[name] = 0
				self.inst:PushEvent("techtreechange", {level = self.accessile_tech_trees})
			end
		end
	end)()
end
