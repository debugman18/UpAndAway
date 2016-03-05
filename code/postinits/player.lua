---
-- Postinits related to the player entity.
--

--wickerrequire "plugins.addlocalplayerpostinit"

local function configure_skyflyspawner(player)
	player:AddComponent("skyflyspawner")
	local sfs = assert( player.components.skyflyspawner )

	local cfg = Configurable("SKYFLYSPAWNER")

	sfs:SetFlyPrefab("skyflies")
	sfs:SetMaxFlies( cfg "MAX_FLIES" )
	do
		local min, max = unpack(cfg "SPAWN_DELAY")
		local dt = max - min
		sfs:SetDelay( function() return min + dt*math.random() end )
	end
	do
		local min, max = unpack(cfg "PLAYER_DISTANCE")
		sfs:SetMinDistance(min)
		sfs:SetMaxDistance(max)
	end
	sfs:SetMinFlySpread(cfg "MIN_FLY2FLY_DISTANCE")
	sfs:SetPersistence( cfg "PERSISTENT" )

	sfs:SetShouldSpawnFn(function()
		local sgen = GetStaticGenerator()
		return sgen and sgen:IsCharged()
	end)

	player:DoTaskInTime(0.1, function(player)
		if player:IsValid() then
			assert( sfs == player.components.skyflyspawner )
			if Pred.IsCloudLevel() then
				sfs:Touch()
			end
		end
	end)
end

TheMod:AddPlayerPostInit(function(player)
    if IsHost() then
		player:AddComponent("climbingvoter")
        player:AddComponent("quester")
        --player:AddComponent("ua_camera")
        player:AddComponent("speechlistener")
        player:AddComponent("ambrosiarespawn")
        player:AddComponent("beanhated")
        player:AddComponent("ua_beardable")
        player:AddComponent("staticconductor")

		configure_skyflyspawner(player)
    end
end)
