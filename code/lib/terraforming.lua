local GROUND = assert( GROUND )
local Game = assert( Game )


local undiggable_tiles = {
    [GROUND.IMPASSABLE] = true,
    [GROUND.DIRT] = true,
}


function IsDiggableTile(tile)
    return tile and not undiggable_tiles[tile] and tile < GROUND.UNDERGROUND
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
end
