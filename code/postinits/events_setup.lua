local Game = wickerrequire "game"
local Math = wickerrequire "math"
local Pred = wickerrequire "lib.predicates"

local GameRoads = Game.Topology.Roads
local GROUND_ROAD = _G.GROUND.ROAD
local TILE_SCALE = _G.TILE_SCALE

local MAX_DISTANCE = 100
local MAX_RADIUS = 10

local road_pos_final = 0,0,0

local function FindTile(pt, prefab, tile)
    local spawner
    local world = GetWorld()
    local playerx, playery, playerz = pt.Transform:GetWorldPosition()

    TheMod:DebugSay("Finding Tiles ".."near "..playerx.." "..playerz)

    local point1 = playerx - MAX_RADIUS
    local point2 = playerx + MAX_RADIUS
    local point3 = playerz - MAX_RADIUS
    local point4 = playerz + MAX_RADIUS

    local randX = math.random(point1, point2)
    local randZ = math.random(point3, point4)

    local place = _G.Vector3(randX, 0, randZ)    
    local tileatpoint = _G.GetWorld().Map:GetTileAtPoint(place.x, place.y, place.z)    
    local canspawn = tileatpoint == tile

    print(tileatpoint)
    print(place)

    if canspawn then     
        TheMod:DebugSay("Found the specified tile!")
        spawner = SpawnPrefab(prefab)      
        spawner.Transform:SetPosition(randX, 0, randZ)   
    else
        TheMod:DebugSay("Invalid location. Trying again.")             
        FindTile(pt,prefab)    
    end

    return spawner

end

local function spawn_shopkeeper_spawner()
    local world = GetWorld()

    TheMod:DebugSay("Attempting to spawn shopkeeper_spawner...")

    do
        local leftovers = Game.FindSomeEntity(Point(), 2^13, nil, nil, nil, {"shopkeeper", "shopkeeper_spawner"})
        if leftovers then
            TheMod:DebugSay("Found existing entity [", leftovers, "], skipping spawn.")
            return
        end
    end

    -----

    local function FindRoad(pt, prefab)
        -- This is hacky, but otherwise it won't work since AddLazyVariable doesn't work correctly.
        local road = GameRoads.TheRoad
        road = _G.ShopkeeperRoad

        -- This way, the shopkeeper will still spawn in worlds without roads, as long as there are road tiles.
        if tostring(road) == "curve from (0.00, 0.00, 0.00) to (0.00, 0.00, 0.00)" then
            FindRoadTile(pt, prefab, _G.GROUND.ROAD)
        end

        local searcher = Math.SearchSpace(road, 64)
        local clear = searcher(Pred.IsUnblockedPoint)

        if clear then
            local spawner = SpawnPrefab(prefab)
            if spawner then
                TheMod:DebugSay("[", spawner, "] spawned at ", clear)
                Game.Move(spawner, clear)
            end
        end   
    end

    -----

    local pt = ThePlayer

    local road = FindRoad(pt, "shopkeeper_spawner")

    if road then
        TheMod:DebugSay("[", road, "] spawned at ", road_pos_final)
    end
end

local function spawn_shopkeeper_spawner_shipwrecked()
    local world = GetWorld()

    TheMod:DebugSay("Attempting to spawn shopkeeper_spawner...")

    do
        local leftovers = Game.FindSomeEntity(Point(), 2^13, nil, nil, nil, {"shopkeeper", "shopkeeper_spawner"})
        if leftovers then
            TheMod:DebugSay("Found existing entity [", leftovers, "], skipping spawn.")
            return
        end
    end

    -----

    FindTile(pt, prefab, GROUND.OCEAN_SHIPGRAVEYARD_SHORE)

end

local function spawn_shopkeeper_spawner_hamlet()
    local world = GetWorld()

    TheMod:DebugSay("Attempting to spawn shopkeeper_spawner...")

    do
        local leftovers = Game.FindSomeEntity(Point(), 2^13, nil, nil, nil, {"shopkeeper", "shopkeeper_spawner"})
        if leftovers then
            TheMod:DebugSay("Found existing entity [", leftovers, "], skipping spawn.")
            return
        end
    end

    -----

    FindTile(pt, prefab, GROUND.COBBLESTONE)

end

local function shopkeeper_spawner_setup()
    local world = GetWorld()

    TheMod:DebugSay(tostring(SaveGameIndex:GetCurrentMode()))

    if SaveGameIndex:GetCurrentMode() == "survival" then
        --Vanilla or Reign of Giants conditions.
        if world then
            world:ListenForEvent("rainstart", spawn_shopkeeper_spawner)
        end
    elseif SaveGameIndex:GetCurrentMode() == "shipwrecked" or SaveGameIndex:GetCurrentMode() == "volcano" then
        --Shipwrecked conditions.
        if world then
            world:ListenForEvent("rainstart", spawn_shopkeeper_spawner_shipwrecked)
        end
    elseif SaveGameIndex:GetCurrentMode() == "porkland" then
        --Hamlet conditions.
        if world then
            world:ListenForEvent("rainstart", spawn_shopkeeper_spawner_porkland)
        end        
    end
end

if IsHost() then
    --TheMod:AddSimPostInit(shopkeeper_spawner_setup)
    TheMod:AddPrefabPostInit("forest", shopkeeper_spawner_setup)
end
