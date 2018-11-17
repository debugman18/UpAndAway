local Game = wickerrequire "game"
local Math = wickerrequire "math"
local Pred = wickerrequire "lib.predicates"

local GameRoads = Game.Topology.Roads


local function spawn_shopkeeper_spawner()
    TheMod:DebugSay("Attempting to spawn shopkeeper_spawner...")

    do
        local leftovers = Game.FindSomeEntity(Point(), 2^13, nil, nil, nil, {"shopkeeper", "shopkeeper_spawner"})
        if leftovers then
            TheMod:DebugSay("Found existing entity [", leftovers, "], skipping spawn.")
            return
        end
    end

    --TEMP, will improve later.
    local base = _G.GetClosestInstWithTag("structure", ThePlayer, 500)

    local pt = base:GetPosition()
    print(pt)

    pt.x = pt.x + 3
    pt.z = pt.z + 3

    local spawner = SpawnPrefab("shopkeeper_spawner")
    if spawner then
        TheMod:DebugSay("[", spawner, "] spawned at ", pt)
        Game.Move(spawner, pt)
    end
end

local function shopkeeper_spawner_setup()
    if SaveGameIndex:GetCurrentMode() == "survival" then
        local world = GetWorld()

        if world then
            world:ListenForEvent("rainstart", spawn_shopkeeper_spawner)
        end
    end
end

if IsHost() then
    --TheMod:AddSimPostInit(shopkeeper_spawner_setup)
    TheMod:AddPrefabPostInit("forest", shopkeeper_spawner_setup)
end
