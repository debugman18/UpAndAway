--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local function OnCreate(inst, scenariorunner)

	--make all of the spider dens scary!
	for k,v in pairs(Ents) do
		if v:HasTag("spiderden") and v.components.growable then
			print "This effects the level as a whole."
			--v.components.growable:SetStage(math.random() < .25 and 3 or 2)
		end
	end
	
end

return 
{
	OnCreate = OnCreate
}
