--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

TheMod:AddRoom("BGCloud", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			skyflower = 1,
		},
	}
})

TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents =  {
		distributepercent = 0.2,
		distributeprefabs = {
			skeleton = 0.1,
			skyflower = 5,
		}
	}
})

TheMod:AddRoom("SkyflowerGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.5,
		distributeprefabs = {
			skyflower = 1,
			thunder_tree = 0.5,
			crystal_relic = 0.01,
		},
	},
})

TheMod:AddRoom("SheepHerd", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.25,
		distributeprefabs = {
			sheep = 1,
			skyflower = 0.1,
		},
	},
})

TheMod:AddRoom("BushGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.2,
		distributeprefabs = {
			thunder_tree = 0.3,
			cloud_bush = 1,
		},
	},
})

TheMod:AddRoom("Aurora_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			hive_marshmallow = 1,
			bee_marshmallow = 0.2,
		},
	},
})

TheMod:AddRoom("Vine_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			vine = 0.6,
		},
	},
})

TheMod:AddRoom("CragLanding", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			cloudcrag = 1,
			goose = 0.01
		},
	},
})