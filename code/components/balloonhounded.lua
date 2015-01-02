--FIXME: not MP compatible

local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local Math = wickerrequire "math"

local GenericHounded = require "components/generichounded"


local BalloonHounded = HostClass(GenericHounded, function(self, inst)
    GenericHounded._ctor(self, inst, "BalloonHounded")
    self:SetConfigurationKey("BALLOON_HOUND")


    do
        local min_radius, max_radius = unpack( self:GetConfig("STILL_SPAWN_DIST") )

        -- Surface for hound spawning if the player is static.
        self.unbiased_spawn_object = Math.Geometry.Surfaces.Annulus(max_radius, min_radius)
    end

    do
        local min_radius, max_radius = unpack( self:GetConfig("MOVING_SPAWN_DIST") )
        local biased_spread = math.pi/3

        -- Surface for hound spawning if the player is moving. The point will be rotated according to the movement direction.
        self.biased_spawn_object = Math.Geometry.Surfaces.AnnularSector(max_radius, min_radius, biased_spread, -biased_spread/2)
    end
end)

-- This will be used only for warning sounds.
BalloonHounded:SetSpawnDistance(20)

function BalloonHounded:GetPrefabToSpawn()
    return "balloon_"..GenericHounded.GetPrefabToSpawn(self)
end

function BalloonHounded:GetSpawnPoint(center)
    local player = GetPlayer()
    if not player then return end

    local object

    local direction = Math.ToComplex(player.Physics:GetVelocity())

    if direction:AbsSq() > 0.2 then
        direction = direction/direction:Abs()
        object = self.biased_spawn_object*direction + center
    else
        object = self.unbiased_spawn_object + center
    end

    return Math.SearchSpace(object, 32)(Pred.IsValidPoint)
end

function BalloonHounded:SpawnHound(spawn_pt)
    TheMod:Say("spawn_pt: ", spawn_pt)
    TheMod:Say("dist to player: ", (spawn_pt - GetPlayer():GetPosition()):Length())

    local vert_offset = Point(0, self:GetConfig("INITIAL_HEIGHT"), 0)

    local hound = SpawnPrefab( self:GetPrefabToSpawn() )
    if hound then
        hound.Physics:Teleport( (spawn_pt + vert_offset):Get() )
        hound:FacePoint(GetPlayer():GetPosition())
        hound.components.combat:SuggestTarget(GetPlayer())
        return hound
    end
end

return BalloonHounded
