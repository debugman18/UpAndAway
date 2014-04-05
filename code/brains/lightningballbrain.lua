BindGlobal()

require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 4
local TARGET_FOLLOW_DIST = 4

local MAX_WANDER_DIST = 40

local LightningBallBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LightningBallBrain:OnStart()
    
    local root = 
        PriorityNode({
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
        }, .25)
    self.bt = BT(self.inst, root)
end

return LightningBallBrain