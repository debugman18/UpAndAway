local Game = wickerrequire "game"
local Math = wickerrequire "math"
local Pred = wickerrequire "lib.predicates"

local GameRoads = Game.Topology.Roads
local GROUND_ROAD = _G.GROUND.ROAD
local TILE_SCALE = _G.TILE_SCALE

local MAX_DISTANCE = 100
local MAX_RADIUS = 9001

local road_pos_final = 0,0,0

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

    local function CheckForPlayer(x,z)
        local player_pos = Vector3(ThePlayer.Transform:GetWorldPosition())
        TheMod:DebugSay("Player POS: "..ThePlayer.Transform:GetWorldPosition())

        local road_pos = Vector3(x,0,z)
        TheMod:DebugSay("Road POS: "..x.." 0 "..z)

        TheMod:DebugSay("Distance from ROAD to PLAYER is "..math.sqrt(distsq(road_pos, player_pos)))

        if (road_pos and distsq(road_pos, player_pos)) < MAX_DISTANCE*MAX_DISTANCE then
            return true
        end 

        return false
    end

    local function FindTile(checkFn, x, y, radius)
        local world = GetWorld()
        TheMod:DebugSay("Finding Tile")

        for i = -radius, radius, 1 do
            if checkFn(world.Map:GetTile(x - radius, y + i)) then
                return x - radius, y + i
            end

            if checkFn(world.Map:GetTile(x + radius, y + i)) then
                return x + radius, y + i
            end
        end

        for i = -(radius - 1), radius - 1, 1 do
            if checkFn(world.Map:GetTile(x + i, y - radius)) then
                return x + i, y - radius
            end

            if checkFn(world.Map:GetTile(x + i, y + radius)) then
                return x + i, y + radius
            end
        end

        return nil, nil
    end

    local function FindTileRadius(checkFn, px, py, pz, max_radius)
        local x, y = world.Map:GetTileXYAtPoint(px, py, pz)

        TheMod:DebugSay("Finding Tiles In Radius")

        for i=1, max_radius, 1 do
            local gridx, gridy = FindTile(checkFn, x, y, i)

            if gridx and gridy then
                return gridx, gridy
            end
        end

        return nil, nil
    end

    local function FindRoad(pt, prefab)
        local spawner
        local world = GetWorld()
        local px, py, pz = pt.Transform:GetWorldPosition()

        TheMod:DebugSay("Finding Roads ".."near "..px.." "..py.." "..pz)

        local roadx, roady = FindTileRadius(function(tile) 
            return _G.GROUND.ROAD
        end, px, py, pz, MAX_RADIUS)

        if roadx and roady then
            spawner = SpawnPrefab(prefab)

            if spawner then
                local width, height = world.Map:GetSize()
                local spawnerx = (roadx - width/2.0)*_G.TILE_SCALE
                local spawnerz = (roady - height/2.0)*_G.TILE_SCALE

                TheMod:DebugSay("Spawning Shopkeeper At "..spawnerx.." "..spawnerz)
                road_pos_final = ""..spawnerx.." "..spawnerz..""
                spawner.Transform:SetPosition(spawnerx,0,spawnerz) 
            end
        end

        return spawner

    end
    -----

    local pt = ThePlayer

    -- We don't use this currently.
    local onroad = RoadManager ~= nil and RoadManager:IsOnRoad(pt.Transform:GetWorldPosition())

    local road = FindRoad(pt, "shopkeeper_spawner")

    if road then
        TheMod:DebugSay("[", road, "] spawned at ", road_pos_final)
    end
end

local function shopkeeper_spawner_setup()
    local world = GetWorld()

    if SaveGameIndex:GetCurrentMode() == "survival" then
        if world then
            world:ListenForEvent("rainstart", spawn_shopkeeper_spawner)
        end
    end
end

if IsHost() then
    --TheMod:AddSimPostInit(shopkeeper_spawner_setup)
    TheMod:AddPrefabPostInit("forest", shopkeeper_spawner_setup)
end
