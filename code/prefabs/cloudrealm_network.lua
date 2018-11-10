if not IsDST() then return Prefab("common/dummies/cloudrealm_network", CreateEntity) end

local MakeWorldNetwork = require("prefabs/world_network")

local assets = {
    Asset("SCRIPT", "scripts/prefabs/world_network.lua"),
}

local prefabs =
{
    "thunder_close",
    "thunder_far",
    "lightning",
}

local function custom_postinit(inst)
    inst:AddComponent("weather")
    inst:AddComponent("staticannouncer")

	if IsHost() then
		inst:AddComponent("climbingmanager")
	end
end

return MakeWorldNetwork("cloudrealm_network", prefabs, assets, custom_postinit)
