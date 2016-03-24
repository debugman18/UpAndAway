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

        --Ambrosia respawning. Let's ditch the component in favor of a simpler solution.
        --player:AddComponent("ambrosiarespawn")
        player:ListenForEvent("minhealth", function() 
   			if player:HasTag("ambrosiarespawn") then
   				player.components.health:SetInvincible(true)
   				player.components.health:SetPercent(1)
   				player.components.sanity:SetPercent(1)
   				player.components.hunger:SetPercent(1)
		        local announcement_string = _G.GetNewRezAnnouncementString(inst, "Ambrosia magic")
		        _G.TheNet:Announce(announcement_string, player.entity, nil, "resurrect")
		        player.components.health.minhealth = nil
		        player.components.health:SetInvincible(false)

		        --Permanent? I think maybe it's a bit much.
		        player.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
   			end		
   		end, player)

        player:AddComponent("beanhated")
        player:AddComponent("ua_beardable")
        player:AddComponent("staticconductor")

		configure_skyflyspawner(player)
    end
end)
