--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Debuggable = wickerrequire 'adjectives.debuggable'


---
-- Simple component for handling static state transitions.
--
-- @author simplex
--
-- @class table
-- @name StaticChargeable
local StaticChargeable = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self)

	self.charged = false

	inst:ListenForEvent("upandaway_charge", function()
		local c = inst.components.staticchargeable
		if inst:IsValid() and c then
			c:Charge()
		end
	end, GetWorld())

	inst:ListenForEvent("upandaway_uncharge", function()
		local c = inst.components.staticchargeable
		if inst:IsValid() and c then
			c:Uncharge()
		end
	end, GetWorld())
end)


---
-- Returns whether it is charged.
function StaticChargeable:IsCharged()
	return self.charged
end


--
-- Lists aliases of methods.
--
-- These are implemented both for convenience and to avoid crashes due to
-- simple typos.
--
local aliases = {
	OnCharged = {
		"OnCharge",
		"Charged",
		"Charge",
	},
	OnUncharged = {
		"OnUncharge",
		"Uncharged",
		"Uncharge",
	},
}


---
-- Returns the oncharge callback.
--
function StaticChargeable:GetOnChargedFn(fn)
	return self.onchargedfn
end

---
-- Sets the oncharge callback.
--
function StaticChargeable:SetOnChargedFn(fn)
	self.onchargedfn = fn
end

---
-- Returns the onuncharge callback.
--
function StaticChargeable:GetOnUnchargedFn(fn)
	return self.onunchargedfn
end

---
-- Sets the onuncharge callback.
--
function StaticChargeable:SetOnUnchargedFn(fn)
	self.onunchargedfn = fn
end


for basic_infix, tbl in pairs(aliases) do
	for _, access in ipairs{"Get", "Set"} do
		local primitive = assert( StaticChargeable[access .. basic_infix .. "Fn"] )
		for _, alias in ipairs(tbl) do
			StaticChargeable[access .. alias .. "Fn"] = primitive
		end
	end
end


---
-- Charges if not already.
--
-- @param force Forces the charging, even if already charged.
function StaticChargeable:Charge(force)
	if not self.charged or force then
		self:DebugSay("Charge()")
		if self.onchargedfn then
			self.onchargedfn(self.inst)
		end
		self.charged = true
	end
end

---
-- Uncharges if not already.
--
-- @param force Forces the uncharging, even if already uncharged.
function StaticChargeable:Uncharge(force)
	if (self.charged or force) then
		self:DebugSay("Uncharge()")
		if self.onunchargedfn then
			self.onunchargedfn(self.inst)
		end
		self.charged = false
	end
end

---
-- Toggles the state. Main for testing.
function StaticChargeable:Toggle()
	if self.charged then
		self:Uncharge()
	else
		self:Charge()
	end
end


---
-- @description Saves the charged state.
--
-- Tries to use as little savedata as possible, since we'll have a lot of
-- entities with this component.
function StaticChargeable:OnSave()
	return {
		c = self.charged and 1 or nil,
	}
end

---
-- @description Loads the charged state.
--
-- Calls Charge() or Uncharge() appropriately.
function StaticChargeable:OnLoad(data)
	if data then
		self.charged = data.c and true or false
		if self.charged then
			self:Charge()
		else
			self:Uncharge()
		end
	end
end


return StaticChargeable
