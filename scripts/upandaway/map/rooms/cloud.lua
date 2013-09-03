--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

TheMod:AddRoom("BGCloud", {
	colour={r=.6,g=.6,b=.7,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			skyflower = 1,
			--sheep = 0.1,
		},
	}
})

TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.7,g=.7,b=.8,a=1},
	value = GROUND.POOPCLOUD,
	tags = {"Town"},
	contents =  {
		distributepercent = 0.2,
		distributeprefabs = {
			skeleton = 0.1,
			skyflower = 5,
			--sheep = 0.3,
		}
	}
})

TheMod:AddRoom("SkyflowerGarden", {
	colour={r=.4,g=.7,b=.4,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.4,
		distributeprefabs = {
			skyflower = 1,
		},
	},
})

TheMod:AddRoom("SheepHerd", {
	colour={r=.7,g=.7,b=.5,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.08,
		distributeprefabs = {
			sheep = 1,
			skyflower = 0.1,
		},
	},
})
