BindGlobal()

local ConditionEventNode = Class(BehaviourNode, function(self, inst, event)
    BehaviourNode._ctor(self, "ConditionEvent("..event..")")
    self.inst = inst
    self.event = event

    self.eventfn = function(inst, data) self:OnEvent(data) end
    self.inst:ListenForEvent(self.event, self.eventfn)
end)

function ConditionEventNode:OnStop()
    if self.eventfn then
        self.inst:RemoveEventCallback(self.event, self.eventfn)
        self.eventfn = nil
    end
end

function ConditionEventNode:OnEvent(data)
    self.triggered = true
    self.data = data
    
    if self.inst.brain then
        self.inst.brain:ForceUpdate()
    end
    
    self:DoToParents(function(node) if node:is_a(PriorityNode) then node.lasttime = nil end end)
end

function ConditionEventNode:Step()
    self._base.Step(self)
    self.triggered = false
end

function ConditionEventNode:Reset()
    self.triggered = false
    self._base.Reset(self)
end

function ConditionEventNode:Visit()
    
    if self.status == READY then
        self.status = RUNNING
    end

    if self.status == RUNNING and self.triggered then
        self.status = SUCCESS
    end
    
end

return ConditionEventNode
