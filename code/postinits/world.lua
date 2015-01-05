if IsHost() then
	TheMod:AddPrefabPostInit(IfDST("world_network", "world"), function(inst)
		inst:AddComponent("climbingmanager")
	end)
end
