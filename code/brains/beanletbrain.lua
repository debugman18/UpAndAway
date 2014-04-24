BindGlobal()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/faceentity"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 10

local AVOID_PLAYER_DIST = 6
local AVOID_PLAYER_STOP = 10

local MAX_WANDER_DIST = 200

local BeanletBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

function BeanletBrain:OnStart()
    local clock = GetClock()
    
    local root = PriorityNode(
    {
        RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST, nil, true),
        EventNode(self.inst, "gohome", 
            DoAction(self.inst, GoHomeAction, "go home", true )),
        Wander(self.inst, function() return self.inst:GetPosition() end, MAX_WANDER_DIST),   
    }, .25)
    self.bt = BT(self.inst, root)
end

return BeanletBrain
