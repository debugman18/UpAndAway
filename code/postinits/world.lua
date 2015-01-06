if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")
	end)
end

--[[
-- This component also goes for clients.
--]]
TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
	inst:AddComponent("staticannouncer")
end)
