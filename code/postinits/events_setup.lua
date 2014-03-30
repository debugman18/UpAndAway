local Game = wickerrequire "game"
local Math = wickerrequire "math"
local Pred = wickerrequire "lib.predicates"

-- This needs to be require'd to build road info on game post init.
wickerrequire "game.topology"

local function spawn_shopkeeper_spawner()
	TheMod:DebugSay("Attempting to spawn shopkeeper_spawner...")

	do
		local leftovers = Game.FindSomeEntity(Point(), 2^13, nil, nil, nil, {"shopkeeper", "shopkeeper_spawner"})
		if leftovers then
			TheMod:DebugSay("Found existing entity [", leftovers, "], skipping spawn.")
			return
		end
	end

	-- 64 is the number of tries.
	local searcher = Math.SearchSpace( Game.Topology.TheRoad, 64 )

	local pt = searcher( Pred.IsUnblockedPoint )
	if pt then
		local spawner = SpawnPrefab("shopkeeper_spawner")
		if spawner then
			TheMod:DebugSay("[", spawner, "] spawned at ", pt)
			Game.Move(spawner, pt)
		end
	end
end

TheMod:AddSimPostInit(function()
	if SaveGameIndex:GetCurrentMode() == "survival" then
		local world = GetWorld()
		if world then
			world:ListenForEvent("rainstart", spawn_shopkeeper_spawner)
		end
	end
end)
