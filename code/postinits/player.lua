---
-- Postinits related to the player entity.
--

wickerrequire "plugins.addplayerprefabpostinit"


TheMod:AddPlayerPrefabPostInit(function(player)
	if not player.components.quester then
		player:AddComponent("quester")
	end
	if not player.components.beard then
		player:AddComponent("beardedlady")
	end
end)
