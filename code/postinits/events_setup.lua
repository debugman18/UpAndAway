local Game = wickerrequire "game"
local Math = wickerrequire "math"
local Pred = wickerrequire "lib.predicates"

local GameRoads = Game.Topology.Roads
local GROUND_ROAD = _G.GROUND.ROAD
local TILE_SCALE = _G.TILE_SCALE

local MAX_DISTANCE = 100
local MAX_RADIUS = 10

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

    local function GetTileCoordinates(x,y)  
        local world = GetWorld()  
        local tilex, tiley = world.Map:GetTileCoordsAtPoint(0,0,0)

        return Vector3((x-tilex) * _G.TILE_SCALE, 0, (y-tiley) * _G.TILE_SCALE)
    end

    local function CheckForPlayer(x,y)
        local player_pos = Vector3(ThePlayer.Transform:GetWorldPosition())
        TheMod:DebugSay("Player POS: "..ThePlayer.Transform:GetWorldPosition())

        local road_pos = GetTileCoordinates(x,y)
        TheMod:DebugSay("Road POS: "..x.." 0 "..z)

        TheMod:DebugSay("Distance from ROAD to PLAYER is "..math.sqrt(distsq(road_pos, player_pos)))

        if (road_pos and distsq(road_pos, player_pos)) < MAX_DISTANCE*MAX_DISTANCE then
            return true
        end 

        return false
    end

    local function FindRoad(pt, prefab)
        local spawner
        local world = GetWorld()
        local playerx, playery, playerz = pt.Transform:GetWorldPosition()

        TheMod:DebugSay("Finding Roads ".."near "..playerx.." "..playerz)

        local point1 = playerx - MAX_RADIUS
        local point2 = playerx + MAX_RADIUS
        local point3 = playerz - MAX_RADIUS
        local point4 = playerz + MAX_RADIUS

        local randX = math.random(-point1, point2)
        local randZ = math.random(-point3, point4)
 
        local place = _G.Vector3(randX, 0, randZ)    
        local tile = _G.GetWorld().Map:GetTileAtPoint(place.x, place.y, place.z)    
        local canspawn = tile == _G.GROUND.ROAD

        print(tile)
        print(place)

        if canspawn then     
            TheMod:DebugSay("Found a road!")
            spawner = SpawnPrefab(prefab)      
            spawner.Transform:SetPosition(randX, 0, randZ)   
        else
            TheMod:DebugSay("Invalid location. Trying again.")             
            FindRoad(pt,prefab)    
        end

        return spawner

    end
    -----

    local pt = ThePlayer

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
