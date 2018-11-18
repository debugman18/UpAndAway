BindGlobal()

require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/minperiod"
require "behaviours/follow"

local MIN_FOLLOW = 10
local MED_FOLLOW = 15
local MAX_FOLLOW = 20

local AuroraBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function AuroraBrain:OnStart()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, 200),
        Follow(self.inst, function() return ThePlayer end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW),
        Wander(self.inst, function() local player = ThePlayer if player then return Vector3(player.Transform:GetWorldPosition()) end end, 100)
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return AuroraBrain