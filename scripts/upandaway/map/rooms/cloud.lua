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

--These are the biomes for cloud/generic.
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
		distributepercent = 0.6,
		distributeprefabs = {
			skyflower = 1,
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
			thunder_tree = 0.2,
			crystal_spire = .6
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
		},
	},
})

TheMod:AddRoom("Bigbird_Nest", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.25,
		distributeprefabs = {
			goose = 0.01,
			longbill = 0.7,
		},
	},
})


TheMod:AddRoom("Beanlet_Den", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.05,
		dsitributeprefabs = {
			beanlet = 0.1,
			skyflies = 0.7,
		},
	},
})
	
--These are the biomes for cloud/snow.
TheMod:AddRoom("BGSnow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 1,
		distributeprefabs = {
			thunder_tree = 0.2,
		},
	}
})

TheMod:AddRoom("Snow_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 1,
		distributeprefabs = {
			thunder_tree = 0.2,
			crystal_relic = 0.1,
		},
	}
})

--These are the biomes for cloud/generic.

TheMod:AddRoom("BGAurora", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents =  {
		distributepercent = 0.2,
		distributeprefabs = {
			skeleton = 0.1,
			manta = 5,
		}
	}
})

TheMod:AddRoom("BGRainbow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.6,
		distributeprefabs = {
			alien = 1,
		},
	},
})

TheMod:AddRoom("Sea_Mimic", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.10,
		distributeprefabs = {
			sky_algae = .8,
			sky_coral = .8,
			manta = .1,
		},
	},
})

TheMod:AddRoom("Manta_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.2,
		distributeprefabs = {
			cloud_bush = 1,
		},
	},
})

TheMod:AddRoom("Rainbow__Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			hive_marshmallow = 0.4,
			bee_marshmallow = 1,
		},
	},
})

TheMod:AddRoom("Crystal_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			crystal_spire = 0.6,
		},
	},
})

TheMod:AddRoom("Fish_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			cloudcrag = 1,
		},
	},
})
