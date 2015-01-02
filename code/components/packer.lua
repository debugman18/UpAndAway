local Pred = wickerrequire "lib.predicates"
local Game = wickerrequire "game"
local table = wickerrequire "utils.table"

local Debuggable = wickerrequire "adjectives.debuggable"


local Packer = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "Packer", true)

    self.canpackfn = nil

    self.package = nil
end)


function Packer:HasPackage()
    return self.package ~= nil
end

function Packer:SetCanPackFn(fn)
    assert( Pred.IsCallable(fn) )
    self.canpackfn = fn
end

-- Note: does NOT take an object as 'self'.
function Packer.DefaultCanPackTest(target)
    return target
        and target:IsValid()
        and not target:IsInLimbo()
        and not (
            target:HasTag("teleportato")
            or target:HasTag("irreplaceable")
            or target:HasTag("player")
            or target:HasTag("nonpackable")
        )
end
Pred.IsPackable = Packer.DefaultCanPackTest

function Packer:CanPack(target)
    return self.inst:IsValid()
        and not self:HasPackage()
        and self.DefaultCanPackTest(target)
        and (not self.canpackfn or self.canpackfn(target, self.inst))
end


local function get_name(target)
    local name = target:GetDisplayName() or (target.components.named and target.components.named.name)

    if not name or name == "MISSING NAME" then return end

    local adj = target:GetAdjective()
    if adj then
        name = adj.." "..name
    end

    if target.components.stackable then
        local size = target.components.stackable:StackSize()
        if size > 1 then
            name = name.." x"..tostring(size)
        end
    end

    return name
end

function Packer:Pack(target)
    if not self:CanPack(target) then
        self:DebugSay("Refused to pack [", target, "].")
        return false
    end

    self:DebugSay("Packing [", target, "].")

    self.package = {
        prefab = target.prefab,
        name = get_name(target),
    }

    self.package.data, self.package.refs = target:GetPersistData()

    target:Remove()

    self:DebugSay("Packed.")

    return true
end

function Packer:GetName()
    return self.package and self.package.name
end


local function isValidGUID(guid)
    local inst = _G.Ents[guid]
    return inst and inst:IsValid()
end

local function freshen_refs(self)
    if self.package and self.package.refs then
        table.FilterArrayInPlace(self.package.refs, isValidGUID)
    end
end

function Packer:Unpack(pos)
    if not self.package then return end

    pos = pos and Game.ToPoint(pos) or self.inst:GetPosition()

    self:DebugSay("Unpacking a ", self.package.prefab, " at ", pos, ".")

    freshen_refs(self)

    local target = SpawnPrefab(self.package.prefab)
    if target then
        target.Transform:SetPosition( pos:Get() )

        local newents = {}
        if self.package.refs then
            for _, guid in ipairs(self.package.refs) do
                newents[guid] = {entity = _G.Ents[guid]}
            end
        end

        target:SetPersistData(self.package.data, newents)
        target:LoadPostPass(newents, self.package.data)

        target.Transform:SetPosition( pos:Get() ) -- insurance
        self.package = nil
        self:DebugSay("Unpacked.")
        return true
    end
end


function Packer:OnSave()
    if self.package then
        freshen_refs(self)
        return {package = self.package}, self.package.refs
    end
end

function Packer:OnLoad(data)
    if data and data.package then
        self.package = data.package
    end
end


return Packer
