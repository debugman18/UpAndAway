BindGlobal()

require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/minperiod"
require "behaviours/follow"

local MIN_FOLLOW = 8
local MED_FOLLOW = 12
local MAX_FOLLOW = 24

local DuckraptorBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DuckraptorBrain:OnStart()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, 100),
        Follow(self.inst, function() return Game.FindClosestPlayer(self.inst) end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return DuckraptorBrain
