BindGlobal()

require "behaviours/chaseandattack"
require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/follow"
require "behaviours/wander"

local START_FACE_DIST = 15
local KEEP_FACE_DIST = 15
local GO_HOME_DIST = 1
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 20
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local OctocopterBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    if homePos and 
       not inst.components.combat.target then
        return BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, 0.2)
    end
end

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST*KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function ShouldGoHome(inst)

    if (inst.components.follower and inst.components.follower.leader) then
        return false
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    return (homePos and distsq(homePos, myPos) > GO_HOME_DIST*GO_HOME_DIST)
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

    local clock = GetClock()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
        Follow(self.inst, function() return GetFollowTarget(self.inst) end, TUNING.GHOST_RADIUS*.25, TUNING.GHOST_RADIUS*.5, TUNING.GHOST_RADIUS),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true )),

        SequenceNode{
			ParallelNodeAny{
				WaitNode(3),
				Wander(self.inst),
			},
            ActionNode(function() self.inst.sg:GoToState("idle") end),
        }
    }, 1)
        
    self.bt = BT(self.inst, root)
         
end

return OctocopterBrain
