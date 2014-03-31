BindGlobal()

local TryAttack = require "behaviours/tryattack"

local BalloonHoundBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function BalloonHoundBrain:OnStart()
    
    local root = PriorityNode(
    {
        TryAttack(self.inst),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return BalloonHoundBrain
