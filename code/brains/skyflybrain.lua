BindGlobal()

require "behaviours/follow"
require "behaviours/wander"


local SkyflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function GetFollowTarget(skyflies)
    if skyflies.brain.followtarget then
        if not skyflies.brain.followtarget:IsValid() or not skyflies.brain.followtarget.components.health or skyflies.brain.followtarget.components.health:IsDead() or
            skyflies:GetDistanceSqToInst(skyflies.brain.followtarget) > 20*8 then
            skyflies.brain.followtarget = nil
        end
    end
    
    if not skyflies.brain.followtarget then
        skyflies.brain.followtarget = FindEntity(skyflies, 20, function(target)
            return target:HasTag("character") and not (target.components.health and target.components.health:IsDead() )
        end)
    end
    
    return skyflies.brain.followtarget
end

function SkyflyBrain:OnStart()
    local clock = GetClock()
    
    local root = PriorityNode(
    {
        Follow(self.inst, function() return GetFollowTarget(self.inst) end, 20*.25, 20*.5, 20),
		Wander(self.inst),
    }, 1)
        
    self.bt = BT(self.inst, root)        
end

return SkyflyBrain
