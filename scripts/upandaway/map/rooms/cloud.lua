--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

--Generic Biome Rooms

--Generic BG
TheMod:AddRoom("BGCloud", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.01,
		distributeprefabs = {
			skyflower = 1,
		},
	}
})

--Generic Spawnzone
TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents =  {
		distributepercent = 0.02,
		distributeprefabs = {
			skeleton = 0.1,
			skyflower = 1,
		}
	}
})

--Skyflowers
TheMod:AddRoom("SkyflowerGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.06,
		distributeprefabs = {
			skyflower = 1,
		},
	},
})

--Sheep
TheMod:AddRoom("SheepHerd", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.25,
		distributeprefabs = {
			sheep = 0.001,
			skyflower = 1,
		},
	},
})

--Cloudbushes
TheMod:AddRoom("BushGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.02,
		distributeprefabs = {
			cloud_bush = 0.020,
			skyflower = 0.5
		},
	},
})


---------

--Aurora Biome Rooms

--Aurora BG
TheMod:AddRoom("BGAurora", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.GRASS,
	contents =  {
		distributepercent = 0.002,
		distributeprefabs = {
			alien = 0.06,		
			skeleton = 0.001,
			manta = 0.02,
		}
	}
})

--Vines
TheMod:AddRoom("Vine_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.01,
		distributeprefabs = {
			vine = 0.05,
		},
	},
})

--Cloudcrags
TheMod:AddRoom("CragLanding", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.01,
		distributeprefabs = {
			cloudcrag = 1,
		},
	},
})

--Longbills
TheMod:AddRoom("Bigbird_Nest", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.05,
		distributeprefabs = {
			goose = 0.001,
			longbill = 0.007,
		},
	},
})

--Beanlets
TheMod:AddRoom("Beanlet_Den", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.GRASS,
	contents = {
		distributepercent = 0.05,
		dsitributeprefabs = {
			beanlet = 0.01,
			skyflies = 0.07,
		},
	},
})


----------
	
--Snow Biome Rooms

--Snow BG
TheMod:AddRoom("BGSnow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.FUNGUS,
	contents = {
		distributepercent = 0.4,
		distributeprefabs = {
			thunder_tree = 0.002,
		},
	}
})

--Thunder Trees
TheMod:AddRoom("Thunder_Forest", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.FUNGUS,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			thunder_tree = 0.002,
		},
	}
})

TheMod:AddRoom("Sea_Mimic", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.FUNGUS,
	contents = {
		distributepercent = 0.10,
		distributeprefabs = {
			cloud_algae = 0.008,
			cloud_coral = 0.008,
			manta = 0.001,
		},
	},
})

TheMod:AddRoom("Manta_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.FUNGUS,
	contents = {
		distributepercent = 0.02,
		distributeprefabs = {
			cloud_bush = 0.010,
			manta = 0.010
		},
	},
})

----------


--Rainbow Biome Rooms

--Rainbow BG
TheMod:AddRoom("BGRainbow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.06,
		distributeprefabs = {
			jellyshroom = 0.0002,
		},
	},
})

--Marshmallows
TheMod:AddRoom("Rainbow_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.02,
		distributeprefabs = {
			hive_marshmallow = 0.05,
			bee_marshmallow = 0.06,
		},
	},
})

--Crystals
TheMod:AddRoom("Crystal_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.01,
		distributeprefabs = {
			crystal_spire = 0.06,
			crystal_black = 0.005,
			crystal_white = 0.005,
		},
	},
})

--Flying Fish
TheMod:AddRoom("Fish_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.MARSH,
	contents = {
		distributepercent = 0.1,
		distributeprefabs = {
			cloudcrag = 0.03,
			flying_fish_pond = 0.001
		},
	},
})
