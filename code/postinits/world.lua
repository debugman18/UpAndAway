if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")

		--Reputation stuff is worldwide.
    	inst:AddComponent("reputation")

    	inst.components.reputation:AddFaction("bean", 50, 0, 100)
    	inst.components.reputation:AddStage(function() print("Testing: Stage 1 completed.") end, "bean", "one", 50)
    	inst.components.reputation:AddStage(function() print("Testing: Stage 2 completed.") end, "bean", "two", 100)
	end)
end

--[[
-- This component also goes for clients.
--]]
TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
	inst:AddComponent("staticannouncer")
end)
