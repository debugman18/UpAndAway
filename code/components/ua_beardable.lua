--[[
-- IMPORTANT:
--
-- If this component is to be added to a character with an innate beard
-- component, it should be added *after* the beard component.
--]]

local Beardable = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "UABeardable")

    self.is_naturally_bearded = (inst.components.beard ~= nil)
    self.active = false
end)

function Beardable:IsNaturallyBearded()
    return self.is_naturally_bearded
end

function Beardable:IsActive()
    return self.active
end

---

local BEARD_DAYS = {4, 8, 16}
local BEARD_BITS = {1, 3, 9}
local BEARD_SYMBOL_OVERRIDES = {"beard_short", "beard_medium", "beard_long"}

local BEARD_CALLBACKS = (function()
    local ret = {}
    for i, thresh_day in ipairs(BEARD_DAYS) do
        local bits = assert( BEARD_BITS[i] )
        local symbol_override = assert( BEARD_SYMBOL_OVERRIDES[i] )

        ret[i] = function(inst)
            local beard = inst.components.beard
            if not beard then return end

            inst.AnimState:OverrideSymbol("beard", "beard", symbol_override)
            beard.bits = bits
        end
    end
    return ret
end)()

---

local function OnResetBeard(inst)
    inst.AnimState:ClearOverrideSymbol("beard")

    local ua_beardable = inst.components.ua_beardable
    if not ua_beardable then return end

    ua_beardable:Deactivate()
end

--[[
-- Returns the beard component if it was newly added, and nil otherwise.
--]]
function Beardable:Activate()
    if self.inst.components.beard then return end
    self.active = true

    self.inst:AddComponent("beard")
    local beard = self.inst.components.beard

    beard.prize = "beardhair"
    beard.onreset = Lambda.BindFirst(OnResetBeard, self.inst)

    for i, thresh_day in ipairs(BEARD_DAYS) do
        local cb = Lambda.BindFirst(BEARD_CALLBACKS[i], self.inst)
        beard:AddCallback(thresh_day, cb)
    end

    return beard
end

function Beardable:Deactivate()
    self.active = false
    if not self:IsNaturallyBearded() then
        self.inst:RemoveComponent("beard")
        return true
    end
end

---

local function ShaveBeard(inst)
    local beard = inst.components.beard
    if not beard then return end

    beard:Shave()
end

local function FindNextCallback(inst)
    local beard = inst.components.beard
    if not beard then return end

    local days = assert( beard.daysgrowth )

    local lowest_thresh = nil
    for thresh_day, cb in pairs(beard.callbacks) do
        if thresh_day > days then
            if lowest_thresh == nil or thresh_day < lowest_thresh then
                lowest_thresh = thresh_day
            end
        end
    end

    if lowest_thresh ~= nil then
        return beard.callbacks[lowest_thresh], lowest_thresh
    else
        return ShaveBeard, 0
    end
end

function Beardable:Cycle()
    self:Activate()
    local beard = assert( self.inst.components.beard )

    local cb, days = FindNextCallback(self.inst)
    assert( cb )

    beard.daysgrowth = days
    cb(self.inst)
end

---

Beardable.OnRemoveFromEntity = Beardable.Deactivate

function Beardable:OnSave()
    if self:IsActive() then
        assert( self.inst.components.beard )
        return self.inst.components.beard:OnSave()
    end
end

function Beardable:OnLoad(data)
    if self:IsNaturallyBearded() then
        return
    end

    self:Activate()
    assert( self.inst.components.beard )

    self.inst.components.beard:OnLoad(data)
end

---

return Beardable	
