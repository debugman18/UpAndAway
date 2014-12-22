---
-- Postinits related to the player entity.
--

--wickerrequire "plugins.addlocalplayerpostinit"


TheMod:AddPlayerPostInit(function(player)
	if IsHost() then
		player:AddComponent("quester")
		--player:AddComponent("ua_camera")
		player:AddComponent("speechlistener")
		player:AddComponent("ambrosiarespawn")
		player:AddComponent("beanhated")
	end
	--[[
	--FIXME: see components/beardlady.lua
	if not player.components.beard then
		player:AddComponent("beardedlady")
	end
	]]--
end)
