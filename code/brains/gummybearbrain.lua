BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

local GummyBearBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    local target = FindEntity(inst, CFG.GUMMYBEAR.SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnValidGround() end)
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
        inst.components.homeseeker.home and 
        inst.components.homeseeker.home:IsValid() and 
        inst.components.homeseeker.home.components.childspawner then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function InvestigateAction(inst)
    local investigatePos = inst.components.knownlocations and inst.components.knownlocations:GetLocation("investigate")
    if investigatePos then
        return BufferedAction(inst, nil, ACTIONS.INVESTIGATE, nil, investigatePos, nil, 1)
    end
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

function GummyBearBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            IfNode(function() return self.inst:HasTag("spider_hider") end, "IsHider", 
            UseShield(self.inst, CFG.GUMMYBEAR.DAMAGE_UNTIL_SHIELD, CFG.GUMMYBEAR.SHIELD_TIME, CFG.GUMMYBEAR.AVOID_PROJECTILE_ATTACKS)),
            AttackWall(self.inst),
            ChaseAndAttack(self.inst, CFG.GUMMYBEAR.MAX_CHASE_TIME),
            DoAction(self.inst, function() return EatFoodAction(self.inst) end ),
            Follow(self.inst, function() return self.inst.components.follower.leader end, CFG.GUMMYBEAR.MIN_FOLLOW_DIST, CFG.GUMMYBEAR.TARGET_FOLLOW_DIST, CFG.GUMMYBEAR.MAX_FOLLOW_DIST),
            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),            
            DoAction(self.inst, function() return InvestigateAction(self.inst) end ),
            -- WhileNode(function() return not GetPseudoClock():IsDay() end, "IsDay",
            --DoAction(self.inst, function() return GoHomeAction(self.inst) end ) ),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, CFG.GUMMYBEAR.MAX_WANDER_DIST)            
        },1)
    
    
    self.bt = BT(self.inst, root)
end

function GummyBearBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end

return GummyBearBrain
