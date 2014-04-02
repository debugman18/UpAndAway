BindGlobal()

require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/follow"
require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local RUN_START_DIST = 5
local RUN_STOP_DIST = 15

local MAX_WANDER_DIST = 20
local MAX_CHASE_TIME = 10

local MIN_FOLLOW_DIST = 8
local MAX_FOLLOW_DIST = 15
local TARGET_FOLLOW_DIST = (MAX_FOLLOW_DIST+MIN_FOLLOW_DIST)/2
local MAX_PLAYER_STALK_DISTANCE = 20

local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 4
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER+MIN_FOLLOW_LEADER)/2

local START_FACE_DIST = MAX_FOLLOW_DIST
local KEEP_FACE_DIST = MAX_FOLLOW_DIST

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, START_FACE_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, KEEP_FACE_DIST)
end

local function GetLeader(inst)
    return inst.components.follower and inst.components.follower.leader
end

local function GetNoLeaderFollowTarget(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetClosestInstWithTag("player", inst, MAX_PLAYER_STALK_DISTANCE)
end

local function GetHome(inst)
    return inst.components.homeseeker and inst.components.homeseeker.home
end

local function ShouldRunAway(guy)
    return not guy:HasTag("gnome") and guy:HasTag("character") and not guy:HasTag("notarget")
end

local function GoHomeAction(inst)
    if GetHome(inst) and GetHome(inst):IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME, nil, inst.components.homeseeker:GetHomePos())
    end
end

local function GetHomeLocation(inst)
    return GetHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function CanAttackNow(inst)
    return inst.components.combat.target == nil or not inst.components.combat:InCooldown()
end

local LiveGnomeBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function LiveGnomeBrain:OnStart()
    local clock = GetClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health and self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

        RunAway(self.inst, ShouldRunAway, RUN_START_DIST, RUN_STOP_DIST),

        Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER, false),

        WhileNode(function() return CanAttackNow(self.inst) end, "AttackMomentarily", ChaseAndAttack(self.inst, MAX_CHASE_TIME) ),
        Follow(self.inst, function() return self.inst.components.combat.target end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true),

        Follow(self.inst, GetNoLeaderFollowTarget, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false),

        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        FaceEntity(self.inst, GetLeader, GetLeader),

        Wander(self.inst, GetHomeLocation, MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return LiveGnomeBrain