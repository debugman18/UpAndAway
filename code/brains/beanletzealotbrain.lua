BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/faceentity"

local BeanletZealotBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, CFG.BEANLET_ZEALOT.START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST*KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

function BeanletZealotBrain:OnStart()
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily", ChaseAndAttack(self.inst, CFG.BEANLET_ZEALOT.MAX_CHASE_TIME, CFG.BEANLET_ZEALOT.MAX_CHASE_DIST) ),
        WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge", RunAway(self.inst, function() return self.inst.components.combat.target end, CFG.BEANLET_ZEALOT.RUN_AWAY_DIST, CFG.BEANLET_ZEALOT.STOP_RUN_AWAY_DIST) ),
        --FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        RunAway(self.inst, "scarytoprey", CFG.BEANLET_ZEALOT.AVOID_PLAYER_DIST, CFG.BEANLET_ZEALOT.AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", CFG.BEANLET_ZEALOT.SEE_PLAYER_DIST, CFG.BEANLET_ZEALOT.STOP_RUN_DIST, nil, true),
        EventNode(self.inst, "gohome", 
            DoAction(self.inst, GoHomeAction, "go home", true )),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, CFG.BEANLET_ZEALOT.MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return BeanletZealotBrain
