BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/chattynode"
require "behaviours/doaction"

local OwlBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, CFG.OWL.SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end)
        if target then
            --check for scary things near the food
            local predator = GetClosestInstWithTag("epic", target, CFG.OWL.SEE_PLAYER_DIST)
            if predator then target = nil end
        end
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end

local function GetNearbyThreatFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, CFG.OWL.DEFEND_DIST, function(guy)
        if guy:HasTag("player") then 
            return guy.components.reputation 
            and guy.components.reputation:GetReputation("strix") <= CFG.OWL.REPUTATION.ENEMY_THRESHOLD
        else
            return guy.components.health
            and not guy:HasTag("owl") 
            and not guy:HasTag("epic")
            and not guy:HasTag("beanmonster")
            and not guy:HasTag("beanprotector")
            and not guy:HasTag("cloudneutral")
            and not guy:HasTag("beanlet")
            and not guy:HasTag("smallcreature")
            and not guy:HasTag("gumbear")
        end
    end)
    return invader
end

local function DefendHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
       not inst.components.combat.target then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetFaceTargetFn(inst)
    target = GetClosestInstWithTag("player", inst, CFG.OWL.SEE_PLAYER_DIST)
    if not target then
        target = GetClosestInstWithTag("gnome", inst, CFG.OWL.SEE_PLAYER_DIST)
    end    
    --print(target)
    return target
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= 10*10
end

local function ShouldGoHome(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker:HasHome() then 
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.WALKTO, nil, nil, nil, 0.2)
    end
end

function OwlBrain:OnStart()
    local root = PriorityNode(
    {
        ChattyNode(self.inst, "Whoo?",
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, CFG.OWL.MAX_CHASE_TIME, CFG.OWL.MAX_CHASE_DIST) ),
        WhileNode(function() return self.inst.components.homeseeker and self.inst.components.homeseeker:HasHome() and GetNearbyThreatFn(self.inst.components.homeseeker.home) end),
            DoAction(self.inst, function() return DefendHomeAction(self.inst) end, "GoHome", true)
        ),        
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, CFG.OWL.MAX_CHASE_TIME, CFG.OWL.MAX_CHASE_DIST) ),
        WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, CFG.OWL.RUN_AWAY_DIST, CFG.OWL.STOP_RUN_AWAY_DIST) ),
        DoAction(self.inst, EatFoodAction, "Eat Food"),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, CFG.OWL.MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)

end

function OwlBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end

return OwlBrain