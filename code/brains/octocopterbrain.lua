BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/follow"
require "behaviours/wander"

local OctocopterBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, CFG.OCTOCOPTER.START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= CFG.OCTOCOPTER.KEEP_FACE_DIST*CFG.OCTOCOPTER.KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function GetFollowTarget(octocopter)
    if octocopter.brain.followtarget then
        if (not octocopter.brain.followtarget.components.health or octocopter.brain.followtarget.components.health:IsDead()) or
            octocopter:GetDistanceSqToInst(octocopter.brain.followtarget) > 15*15 then
            octocopter.brain.followtarget = nil
        end
    end
    
    if not octocopter.brain.followtarget then
        octocopter.brain.followtarget = FindEntity(octocopter, 15, function(target)
            return target:HasTag("character") and not (target.components.health and target.components.health:IsDead() )
        end)
    end
    
    return octocopter.brain.followtarget
end

function OctocopterBrain:OnStart()

    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, CFG.OCTOCOPTER.MAX_CHASE_TIME, CFG.OCTOCOPTER.MAX_CHASE_DIST),
        Follow(self.inst, function() return GetFollowTarget(self.inst) end, CFG.OCTOCOPTER.FOLLOW_RADIUS*.25, CFG.OCTOCOPTER.FOLLOW_RADIUS*.5, CFG.OCTOCOPTER.FOLLOW_RADIUS),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        SequenceNode{
            ParallelNodeAny{
                Wander(self.inst),
            },
            ActionNode(function() self.inst.sg:GoToState("idle") end),
        }
    }, 1)
        
    self.bt = BT(self.inst, root)
         
end

return OctocopterBrain
