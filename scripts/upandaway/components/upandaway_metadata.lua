--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

---
-- Simple component for storing arbitrary data as savedata.
--
-- @class table
-- @name Metadata
local Metadata = Class(function(self, inst)
	self.inst = inst

	self.data = {}
end)

---
-- Gets a field previously set/saved.
function Metadata:Get(k)
	return self.data[k]
end

---
-- Sets a field.
function Metadata:Set(k, v)
	self.data[k] = v
end

---
-- Returns an iterator triple over the existing fields.
function Metadata:pairs()
	return pairs(self.data)
end

---
-- Saves all fields.
function Metadata:OnSave()
	local data = {}
	for k, v in self:pairs() do
		data[k] = v
	end
	return data
end

---
-- Loads the fields from savedata.
function Metadata:OnLoad(data)
	if data then
		for k, v in pairs(data) do
			self:Set(k, v)
		end
	end
end

return Metadata
