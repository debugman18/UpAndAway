BindGlobal()

local RandomlyWaitNode = Class(BehaviourNode, function(self, mintime, maxtime)
    BehaviourNode._ctor(self, "Wait")
    self.min_wait_time = mintime
    self.max_wait_time = maxtime or mintime
end)

function RandomlyWaitNode:DBString()
    local w = self.wake_time - GetTime()
    return string.format("%2.2f", w)
end

function RandomlyWaitNode:Visit()
    local current_time = GetTime() 
    
    if self.status ~= RUNNING then
        self.wake_time = current_time + self.min_wait_time + (self.max_wait_time - self.min_wait_time)*math.random()
        self.status = RUNNING
    end
    
    if self.status == RUNNING then
        if current_time >= self.wake_time then
            self.status = SUCCESS
        else
            self:Sleep(current_time - self.wake_time)
        end
    end
end

return RandomlyWaitNode
