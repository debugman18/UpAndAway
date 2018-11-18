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

    -----

    -- Thanks, boat!
    local function FindRoad(pt, prefab)
        local world = GetWorld()

        local findtile = function(checkFn, x, y, radius)
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

        local findtileradius = function(checkFn, px, py, pz, max_radius)
            local x, y = world.Map:GetTileXYAtPoint(px, py, pz)

            for i=1, max_radius, 1 do
                local bx, by = findtile(checkFn, x, y, i)
                if bx and by then
                    return bx, by
                end
            end
            return nil, nil
        end

        local spawner
        local px, py, pz = pt.Transform:GetWorldPosition()
        local shorex, shorey = findtileradius(function(tile) return tile == _G.GROUND.ROAD end, px, py, pz, 50)
        if shorex and shorey then
            spawner = SpawnPrefab(prefab)
            if spawner then
                local width, height = world.Map:GetSize()
                local tx = (shorex - width/2.0)*_G.TILE_SCALE
                local tz = (shorey - height/2.0)*_G.TILE_SCALE

                local shalx, shaly = findtileradius(function(tile) return tile == _G.GROUND.ROAD end, tx, 0, tz, 1)

                if shalx and shaly then
                    --offset slightly
                    local tx2 = (shalx - width/2.0)*_G.TILE_SCALE
                    local tz2 = (shaly - height/2.0)*_G.TILE_SCALE

                    tx = _G.Lerp(tx, tx2, 0.5)
                    tz = _G.Lerp(tz, tz2, 0.5)
                end

                spawner.Transform:SetPosition(tx, 0, tz)
            end
        end

        return spawner
    end
    -----

    local pt = ThePlayer

    local spawner = FindRoad(pt, "shopkeeper_spawner")
    if spawner then
        TheMod:DebugSay("[", spawner, "] spawned at ", pt)
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
