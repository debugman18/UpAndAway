BindGlobal()

require "behaviours/wander"

local WhirlwindBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function WhirlwindBrain:OnStart()
    local root = PriorityNode({
        Wander(self.inst),
    }, 1)

    self.bt = BT(self.inst, root)
end

return WhirlwindBrain
