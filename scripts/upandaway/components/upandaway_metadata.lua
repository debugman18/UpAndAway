--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

local Metadata = Class(function(self, inst)
	self.inst = inst

	self.data = {}
end)

function Metadata:Get(k)
	return self.data[k]
end

function Metadata:Set(k, v)
	self.data[k] = v
end

function Metadata:pairs()
	return pairs(self.data)
end

function Metadata:OnSave()
	local data = {}
	for k, v in self:pairs() do
		data[k] = v
	end
	return data
end

function Metadata:OnLoad(data)
	if data then
		for k, v in pairs(data) do
			self:Set(k, v)
		end
	end
end

return Metadata
