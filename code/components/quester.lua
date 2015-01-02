local Tree = wickerrequire "utils.table.tree"


local Quester = HostClass(Debuggable, function(self, inst)
    self.inst = inst

    Debuggable._ctor(self, "Quester")
    self:SetConfigurationKey("QUESTER")

    -- Maps quest names to quest data.
    self.quests = {}
end)

local function new_quest_datatable()
    return {
        started = nil,
        flags = {},
        attr = {},
    }
end

local function get_quest_data(self, name)
    return self.quests[name]
end

local function require_quest_data(self, name)
    local data = get_quest_data(self, name)
    if data == nil then
        return error("Quest "..tostring(name).." has not been added.", 2)
    end
    return data
end


function Quester:AddQuest(name)
    if not get_quest_data(self, name) then
        self:DebugSay("Adding quest \"", name, "\".")
        self.quests[name] = new_quest_datatable()
    end
end

function Quester:HasQuest(name)
    return get_quest_data(self, name) ~= nil
end

function Quester:ClearQuest(name)
    self.quests[name] = nil
end

function Quester:StartQuest(name)
    if not self:HasQuest(name) then
        self:AddQuest(name)
    end
    local data = get_quest_data(self, name)
    if not data.started then
        self:DebugSay("Starting quest \"", name, "\".")
        data.started = true
    end
end

function Quester:StartedQuest(name)
    local data = get_quest_data(self, name)
    return data and data.started or false
end

function Quester:GetFlag(name, flagname)
    local data = get_quest_data(self, name)
    return data and data.flags[flagname] or false
end
Quester.HasFlag = Quester.GetFlag

function Quester:SetFlag(name, flagname, value)
    self:DebugSay("Setting flag \"", flagname, "\" of quest \"", name, "\" to ", value)
    local data = require_quest_data(self, name)
    data.flags[flagname] = value or nil
end

function Quester:GetAttribute(name, attrname)
    local data = get_quest_data(self, name)
    return data and data.attr[attrname]
end

function Quester:HasAttribute(name, attrname)
    return self:GetAttribute(name, attrname) ~= nil
end

function Quester:SetAttribute(name, attrname, value)
    self:DebugSay("Setting attribute \"", attrname, "\" of quest \"", name, "\" to ", value)
    local data = require_quest_data(self, name)
    data.attr[attrname] = value
end

function Quester:OnSave()
    return { questdata = self.quests }
end

function Quester:OnLoad(data)
    if not data then return end

    if data.questdata then
        Tree.InjectInto(self.quests, data.questdata)
    end
end


return Quester
