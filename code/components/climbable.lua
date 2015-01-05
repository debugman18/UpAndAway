--FIXME: not MP compatible

local Climbing = modrequire "lib.climbing"


local Pred = wickerrequire "lib.predicates"
local Debuggable = wickerrequire "gadgets.debuggable"


--[[
-- In what follows, "cave" has extended meaning, i.e., any cave level.
-- So it refers to either an actual cave or a cloud realm.
--]]

---
-- The Climbable component.
--
-- @author simplex
--
-- @class table
-- @name Climbable
--
local Climbable = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "Climbable")

    -- Target cave number, i.e. cave number of the world to be generated.
    -- This should never be set directly.
    self.cavenum = nil
end)


---
-- Destroys the associated cave, if any.
--
-- @param callback An optional callback to be called after completion.
function Climbable:DestroyCave(callback)
    local function actual_callback()
        self.cavenum = nil
        if callback then callback(self.inst) end
    end

    if self.cavenum then
        self:DebugSay("Destroying cave number ", self.cavenum, "...")

        -- This actually destroys it.
        SaveGameIndex:ResetCave(self.cavenum, actual_callback)
    else
        actual_callback()
    end
end

---
-- @description Local function dictating when a Climbable should have a cave number.
--
-- The below behaviour was changed, at least provisionally.
-- Otherwise, save files for higher levels would not be properly deleted
-- if a lower beanstalk is chopped (this issue also affects vanilla, with
-- ruins' save files being left behind).
-- <br /><br />
-- This will only return true if either:
-- <ol>
-- <li> The direction is up and we are not below ground. </li>
-- <li> The direction is down and we are not above ground. </li>
-- </ol>
--
-- @name should_have_cavenum
-- 
local function should_have_cavenum(self)
    --return self:GetDirection() and self:GetDirection()*Climbing.GetLevelHeight() >= 0
    return self:GetDirection() and Climbing.GetLevelHeight() == 0
end


---
-- @description Sets the climbing direction.
--
-- Performs cleanup, if needed, in case a previous direction was already set.
--
-- @param direction Should be either a number or a string ("up" or "down", case insensitive).
-- If it is a number, its sign will dictate the direction.
--]]
function Climbable:SetDirection(direction)
    if not Pred.IsNumber(direction) then
        if not Pred.IsWordable(direction) then
            return error("The climbing direction should either a number or a string.")
        end
        direction = tostring(direction)
        if direction:lower() == "up" then
            direction = 1
        elseif direction:lower() == "down" then
            direction = -1
        else
            return error(("Invalid climbing direction %q."):format(direction))
        end
    elseif direction == 0 then
        return error("The climbing direction can't be zero!")
    end

    if direction > 0 then
        direction = 1
    elseif direction < 0 then
        direction = -1
    end

	replica(self.inst).climbable:SetDirection(direction)

    if not should_have_cavenum(self) then
        self:DestroyCave()
    end
end

---
-- Returns the current climbing direction.
function Climbable:GetDirection()
    local ret = replica(self.inst).climbable:GetDirection()
	if ret ~= 0 then
		return ret
	end
end

---
-- Returns the current direction as a string.
--
-- @return "UP", "DOWN" or "".
function Climbable:GetDirectionString()
	return replica(self.inst).climbable:GetDirectionString()
end


---
-- Returns the current cave number, if any.
function Climbable:GetCaveNumber()
    return self.cavenum
end

---
-- @description Returns the effective cave number.
--
-- If the climbable prefab has a cave number, returns it. Otherwise, if we are in a cave level, returns its cave number. Otherwise, returns 0.
function Climbable:GetEffectiveCaveNumber()
    local n = self:GetCaveNumber()
    if n then
        return n
    elseif SaveGameIndex:GetCurrentMode() == "cave" then
        return SaveGameIndex:GetCurrentCaveNum()
    else
        return 0
    end
end


---
-- Climbs in the configured direction. Raises an error if there isn't any.
function Climbable:Climb()
    assert( self:GetDirection(), "Attempt to climb a climbable without a direction set." )
    local function doclimb()
        if self:Debug() then
            self:Say("Climbing ", self:GetDirectionString(), " into cave number ", self:GetEffectiveCaveNumber(), ". Current height: ", Climbing.GetLevelHeight(), ".")
        end
        Climbing.Climb(self:GetDirection(), self.cavenum)
    end

    if not self.cavenum and should_have_cavenum(self) then
        self.cavenum = SaveGameIndex:GetNumCaves() + 1
        SaveGameIndex:AddCave(nil, doclimb)
    else
        doclimb()
    end
end

---
-- Destroys the cave.
function Climbable:OnRemoveEntity()
    self:DestroyCave()
end

---
-- Destroys the cave.
function Climbable:OnRemoveFromEntity()
    self:DestroyCave()
end

---
-- Saves the cave number.
function Climbable:OnSave()
    return {
        cavenum = self.cavenum,
    }
end

---
-- Loads the cave number.
function Climbable:OnLoad(data)
    if data then
        self.cavenum = data.cavenum

        if self.cavenum then
            self.inst:DoTaskInTime(3 + 2*math.random(), function()
                if self.cavenum and not should_have_cavenum(self) then
                    self:DestroyCave()
                end
            end)
        end
    end
end

return Climbable
