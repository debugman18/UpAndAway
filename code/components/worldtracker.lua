BindGlobal()

local WorldTracker = Class(function(self, inst)
    self.world = "survival"
    self.lastworld = "survival"
    self.inst = inst
end)

function WorldTracker:GetLastWorld()
    return self.lastworld
end

function WorldTracker:OnSave()
    return {
        world = self.world or nil,
        lastworld = self.lastworld or "survival",
    }
end

function WorldTracker:SetLastWorld(lastworld)
    self.lastworld = lastworld
    WorldTracker:OnSave()
end

function WorldTracker:OnLoad(data)
    if data and data.world then
        self.world = data.world
    end

    if data and data.lastworld then
        self.lastworld = data.lastworld
    end
end

return WorldTracker	