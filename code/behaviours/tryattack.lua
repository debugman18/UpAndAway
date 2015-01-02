BindGlobal()

local TryAttack = Class(BehaviourNode, function(self, inst, findnewtargetfn)
    BehaviourNode._ctor(self, "SimplyAttack")
    self.inst = inst
    self.findnewtargetfn = findnewtargetfn

    --[[
    local function success()
        self.status = SUCCESS
    end

    self.inst:ListenForEvent("onattackother", success)
    self.inst:ListenForEvent("onmissother", success)
    ]]--
end)

function TryAttack:__tostring()
    return string.format("target %s", tostring(self.inst.components.combat.target))
end

function TryAttack:Visit()
    local combat = self.inst.components.combat
    if self.status == READY then
        combat:ValidateTarget()
        
        if not combat.target and self.findnewtargetfn then
            combat.target = self.findnewtargetfn(self.inst)
        end
        
        if combat.target then
            self.status = RUNNING
        else
            self.status = FAILED
        end
        
    end

    if self.status == RUNNING then
        if not combat.target or not combat.target.entity:IsValid() then
            self.status = FAILED
            combat:SetTarget(nil)
        elseif combat.target.components.health and combat.target.components.health:IsDead() then
            self.status = SUCCESS
            combat:SetTarget(nil)
        else
            local hp = Point(combat.target.Transform:GetWorldPosition())
            local pt = Point(self.inst.Transform:GetWorldPosition())
            local dsq = distsq(hp, pt)
            local rangesq = combat:CalcAttackRangeSq()
            
            if dsq <= rangesq and not (self.inst.sg and self.inst.sg:HasStateTag("jumping")) then
                self.inst.components.locomotor:Stop()
                if self.inst.sg:HasStateTag("canrotate") then
                    self.inst:FacePoint(hp)
                end                
            end
                
            if combat:TryAttack() then
                self.status = SUCCESS
            else
                self.status = FAILED
            end
            
            self:Sleep(.125)
        end
    end
end

return TryAttack
