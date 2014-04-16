---
-- Postinits related to the player entity.
--

wickerrequire "plugins.addplayerprefabpostinit"


TheMod:AddPlayerPrefabPostInit(function(player)
	if not player.components.quester then
		player:AddComponent("quester")
	end
end)
