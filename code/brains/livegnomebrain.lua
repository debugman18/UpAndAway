BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/follow"
require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, CFG.LIVE_GNOME.START_FACE_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, CFG.LIVE_GNOME.KEEP_FACE_DIST)
end

local function GetLeader(inst)
    return inst.components.follower and inst.components.follower.leader
end

local function GetNoLeaderFollowTarget(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetClosestInstWithTag("player", inst, CFG.LIVE_GNOME.MAX_PLAYER_STALK_DISTANCE)
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
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health and self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

        RunAway(self.inst, ShouldRunAway, CFG.LIVE_GNOME.RUN_START_DIST, CFG.LIVE_GNOME.RUN_STOP_DIST),

        Follow(self.inst, GetLeader, CFG.LIVE_GNOME.MIN_FOLLOW_LEADER, CFG.LIVE_GNOME.TARGET_FOLLOW_LEADER, CFG.LIVE_GNOME.MAX_FOLLOW_LEADER, false),

        WhileNode(function() return CanAttackNow(self.inst) end, "AttackMomentarily", ChaseAndAttack(self.inst, CFG.LIVE_GNOME.MAX_CHASE_TIME) ),
        Follow(self.inst, function() return self.inst.components.combat.target end, CFG.LIVE_GNOME.MIN_FOLLOW_DIST, CFG.LIVE_GNOME.TARGET_FOLLOW_DIST, CFG.LIVE_GNOME.MAX_FOLLOW_DIST, true),

        Follow(self.inst, GetNoLeaderFollowTarget, CFG.LIVE_GNOME.MIN_FOLLOW_DIST, CFG.LIVE_GNOME.TARGET_FOLLOW_DIST, CFG.LIVE_GNOME.MAX_FOLLOW_DIST, false),

        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        FaceEntity(self.inst, GetLeader, GetLeader),

        Wander(self.inst, GetHomeLocation, CFG.LIVE_GNOME.MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return LiveGnomeBrain