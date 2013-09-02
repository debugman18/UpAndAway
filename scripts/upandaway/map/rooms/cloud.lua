--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.010,g=.010,b=.10,a=.50},
	value = GROUND.MARSH,
	contents =  {
		distributepercent = 1,
		distributeprefabs = {
			skeleton = 1,
		}
	}
})
