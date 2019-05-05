local GROUND = assert(GROUND)
local Game = assert(Game)


local undiggable_tiles = {
    [GROUND.IMPASSABLE] = true,
    [GROUND.DIRT] = true,
}

function IsDiggableTile(tile)
    return tile and not undiggable_tiles[tile]
    -- We need a newer way of deciding this. and tile < GROUND.UNDERGROUND
end
local IsDiggableTile = IsDiggableTile

function IsDiggablePoint(x, y, z)
    local pt = Game.ToPoint(x, y, z)
    local world = GetWorld()
    if world then
        return IsDiggableTile(world.Map:GetTileAtPoint(pt:Get()))
    end
end
local IsDiggablePoint = IsDiggablePoint

local function SpawnCloudTurf(turf,pt)
    if turf then
        local loot = _G.SpawnPrefab(turf)
        loot.Transform:SetPosition(pt.x, pt.y, pt.z)
        if loot.Physics then
            local angle = math.random()*2*_G.PI
            loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))
        end
    end
end

function MakeTileUndiggable(tile)
    assert( Pred.IsNumber(tile), "Number expected as tile parameter." )
    undiggable_tiles[tile] = true
end
local MakeTileUndiggable = MakeTileUndiggable


do
    local Terraformer = require "components/terraformer"

    Terraformer.CanTerraformPoint = (function()
        local CanTerraformPoint = Terraformer.CanTerraformPoint

        return function(self, pt, ...)
            return CanTerraformPoint(self, pt, ...) and IsDiggablePoint(pt)
        end
    end)()

    Terraformer.Terraform = (function()
        local Terraform = Terraformer.Terraform

        return function(self, pt, ...)
            local ground = TheWorld
            local mod_tiles = {
                [GROUND.POOPCLOUD]  = "turf_poopcloud",
                [GROUND.AURORA]     = "turf_aurora",    
                [GROUND.SNOW]       = "turf_snow",
                [GROUND.RAINBOW]    = "turf_rainbow",
                [GROUND.CLOUDSWIRL] = "turf_cloudswirl",
                [GROUND.CLOUDLAND]  = "turf_cloudland",
                [GROUND.SNOWTWO]    = "turf_snowtwo",
                [GROUND.AURORATWO]  = "turf_auroratwo",
                [GROUND.RAINBOWTWO] = "turf_rainbowtwo",
            }

            if ground then
                local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
                TheMod:DebugSay("Digging tile "..tile)
                if mod_tiles[tile] then
                    TheMod:DebugSay("Successfully dug tile "..tile)
                    SpawnCloudTurf(mod_tiles[tile], pt)
                end
            end

            Terraform(self, pt)
        end
    end)()
end
