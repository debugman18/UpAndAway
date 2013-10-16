---
-- @author simplex

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local submodules = {
	"entity_creation",
}


local Configurable = wickerrequire "adjectives.configurable"

local cfg = Configurable "PROFILING"


for _, m in ipairs(submodules) do
	if cfg:GetConfig(m:upper(), "ENABLED") then
		modrequire("profiling." .. m:lower())
	end
end
