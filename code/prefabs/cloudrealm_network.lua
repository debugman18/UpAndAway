if not IsDST() then return {} end

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
		-- inst:AddComponent("climbingmanager")

		-- Reputation stuff is worldwide.
		inst:AddComponent("reputation")
		do
			-- Bean faction.
			inst.components.reputation:AddFaction("bean", 100, 0, 100)
			inst.components.reputation:SetDecay("bean", true)
			inst.components.reputation:SetDecayRate("bean", false, 1)
			inst.components.reputation:AddStage("bean", "beanhated_one", 80, function() --[[dummy]] end)

			-- Gnomes faction.
			inst.components.reputation:AddFaction("gnomes", 50, 0, 100)
			inst.components.reputation:SetDecay("gnomes", false)
			inst.components.reputation:AddStage("gnomes", "ally_one", 70, function () --[[dummy]] end)

			-- Strix faction.
			inst.components.reputation:AddFaction("strix", 20, 0, 100)
			inst.components.reputation:SetDecay("strix", false)
			inst.components.reputation:AddStage("strix", "ally_one", 50, function () --[[dummy]] end)
		end
	end
end

return MakeWorldNetwork("cloudrealm_network", prefabs, assets, custom_postinit)
