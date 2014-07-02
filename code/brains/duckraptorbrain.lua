BindGlobal()

require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/minperiod"
require "behaviours/follow"

local MIN_FOLLOW = 10
local MED_FOLLOW = 20
local MAX_FOLLOW = 40

local DuckraptorBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DuckraptorBrain:OnStart()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, 100),
        Follow(self.inst, function() return GetPlayer() end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW),
        Wander(self.inst, function() local player = GetPlayer() if player then return Vector3(player.Transform:GetWorldPosition()) end end, 10)
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return DuckraptorBrain