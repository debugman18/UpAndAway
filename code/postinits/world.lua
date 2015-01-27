if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")

		-- Reputation stuff is worldwide.
    	inst:AddComponent("reputation")

    	-- Bean faction.
    	inst.components.reputation:AddFaction("bean", 100, 0, 100)
    	inst.components.reputation:SetDecay("bean", true)
    	inst.components.reputation:SetDecayRate("bean", false, 1)
    	inst.components.reputation:AddStage("bean", "beanhated_one", 80, function() --[[dummy]] end)

    	-- Gnomes faction.
    	inst.components.reputation:AddFaction("gnomes", 50, 0, 100)
    	inst.components.reputation:SetDecay("gnomes", false)
    	inst.components.reputation:AddStage("gnomes", "ally_one", 70, function () --[[dummy]] end)

    	-- Strix faction.
    	inst.components.reputation:AddFaction("strix", 20, 0, 100)
    	inst.components.reputation:SetDecay("strix", false)
    	inst.components.reputation:AddStage("strix", "ally_one", 50, function () --[[dummy]] end)

	end)
end

--[[
-- This component also goes for clients.
--]]
TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
	inst:AddComponent("staticannouncer")
end)
