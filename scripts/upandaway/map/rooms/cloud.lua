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

TheMod:AddRoom("GooseChase", {
	colour={r=.2,g=.2,b=.5,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			goose = 0.2,
		},
	},
})

TheMod:AddRoom("BushGarden", {
	colour={r=.2,g=.4,b=.5,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.2,
		distributeprefabs = {
			cloud_bush = 1,
		},
	},
})

TheMod:AddRoom("MarshmallowFields", {
	colour={r=.4,g=.2,b=.5,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			hive_marshmallow = 1,
			bee_marshmallow = 0.2,
		},
	},
})

TheMod:AddRoom("Aurora_Room", {
	colour={r=.4,g=.2,b=.5,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			hive_marshmallow = 1,
			bee_marshmallow = 0.2,
		},
	},
})

TheMod:AddRoom("CragLanding", {
	colour={r=.6,g=.7,b=.4,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			cloudcrag = 1,
			goose = 0.05
		},
	},
})