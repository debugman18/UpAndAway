if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")

		--Reputation stuff is worldwide.
    	inst:AddComponent("reputation")

    	inst.components.reputation:AddFaction("bean", 100, 0, 100)
    	inst.components.reputation:SetDecay("bean", true)
    	inst.components.reputation:SetDecayRate("bean", false, 1)
    	inst.components.reputation:AddStage("bean", "beanhated_one", 50, function() print("Testing succeeded!") end)
	end)
end

--[[
-- This component also goes for clients.
--]]
TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
	inst:AddComponent("staticannouncer")
end)
