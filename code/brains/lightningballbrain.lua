BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"

local LightningBallBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LightningBallBrain:OnStart()
    
    local root = 
        PriorityNode({
            Follow(self.inst, function() return self.inst.components.follower.leader end, CFG.BALL_LIGHTNING.MIN_FOLLOW_DIST, CFG.BALL_LIGHTNING.TARGET_FOLLOW_DIST, CFG.BALL_LIGHTNING.MAX_FOLLOW_DIST),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, CFG.BALL_LIGHTNING.MAX_WANDER_DIST),
        }, .25)
    self.bt = BT(self.inst, root)
end

return LightningBallBrain