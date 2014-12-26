BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/faceentity"

local BeanletBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

function BeanletBrain:OnStart()
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        RunAway(self.inst, "scarytoprey", CFG.BEANLET.AVOID_PLAYER_DIST, CFG.BEANLET.AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", CFG.BEANLET.SEE_PLAYER_DIST, CFG.BEANLET.STOP_RUN_DIST, nil, true),
        EventNode(self.inst, "gohome", 
            DoAction(self.inst, GoHomeAction, "go home", true )),
        Wander(self.inst, function() return self.inst:GetPosition() end, CFG.BEANLET.MAX_WANDER_DIST),   
    }, .25)
    self.bt = BT(self.inst, root)
end

return BeanletBrain
