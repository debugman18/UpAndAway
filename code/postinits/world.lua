if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")

		--Reputation stuff is worldwide.
    	inst:AddComponent("reputation")

    	inst.components.reputation:AddFaction("bean", 100, 0, 100, true)
    	inst.components.reputation:AddStage(function() print("Testing: Stage 1 completed.") end, "bean", "beanhated_one", 50, true, true, 1)
	end)
end

--[[
-- This component also goes for clients.
--]]
TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
	inst:AddComponent("staticannouncer")
end)
