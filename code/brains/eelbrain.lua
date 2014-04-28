BindGlobal()

require "behaviours/chaseandattack"
require "behaviours/chaseandram"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/faceentity"

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 20

local MAX_WANDER_DIST = 20

local START_FACE_DIST = 20
local KEEP_FACE_DIST = 20

local MAX_CHARGE_DIST = 20
local CHASE_GIVEUP_DIST = 21

local EelBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
	   inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetFaceTargetFn(inst)

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > MAX_CHASE_DIST*MAX_CHASE_DIST) then
        return
    end

    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > MAX_CHASE_DIST*MAX_CHASE_DIST) then
        return false
    end

    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST*KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function GetNearbyThreatFn(inst)
    return FindEntity(inst, START_FACE_DIST, function(guy)
        return (guy:HasTag("character") or guy:HasTag("animal") ) and not guy:HasTag("eel") and not guy:HasTag("notarget")
    end)
end

function EelBrain:OnStart()

    local clock = GetClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.combat.target == nil end,
            "RamAttack",
            ChaseAndRam(self.inst, MAX_CHASE_TIME, CHASE_GIVEUP_DIST, MAX_CHARGE_DIST) ),		
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),		
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst),
    }, 1)
        
    self.bt = BT(self.inst, root)
         
end

return EelBrain
