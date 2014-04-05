
--Generic Biome Rooms

--Generic BG
TheMod:AddRoom("BGCloud", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			skyflower = 1.6,
			tea_bush = 0.05,
			crystal_light = 0.065,
			sheep = 0.03,
			cloud_fruit_tree = 0.04,
		},
	    countprefabs = {
	        lionblob = 1,
	        golden_sunflower = 6,
	    }		
	}
})

--Generic Spawnzone
TheMod:AddRoom("BeanstalkSpawn", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents =  {
		distributepercent = 0.4,
		distributeprefabs = {
			skeleton = 0.03,
			tea_bush = 0.06,
			skyflower = 1.3,
		}
	}
})

--Skyflowers
TheMod:AddRoom("SkyflowerGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			skyflower = 0.3,
			skytrap = 0.3,
			golden_rose = 0.1,
			sheep = 0.4,
			cloud_bush = 0.02,
		},
	    countprefabs= {
	        weavernest = 4,
	    }			
	},
})

--Sheep
TheMod:AddRoom("SheepHerd", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			sheep = 0.4,
			skyflower = 0.6,
		},
	},
})

--Cloudbushes
TheMod:AddRoom("BushGarden", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.POOPCLOUD,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			cloud_bush = 0.04,
			tea_bush = 0.02,
			skyflower = 0.5,
			frog = 0.01,
		},
	    countprefabs= {
	        weavernest = 4,
	    }		
	},
})


---------

--Aurora Biome Rooms

--Aurora BG
TheMod:AddRoom("BGAurora", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents =  {
		distributepercent = 0.3,
		distributeprefabs = {
			alien = 0.09,		
			skeleton = 0.004,
			manta = 0.07,
			gustflower = 0.09,
			dragonblood_tree = 0.09,
			skyflower = 1.0,
			cloudcrag = 0.04,
		}
	}
})

--Vines
TheMod:AddRoom("Vine_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			vine = 0.3,
			dragonblood_tree = 0.4,
			beanlet = 0.5,
			gustflower = 0.2,
			skeleton = 0.3,
		},
	},
})

--Cloudcrags
TheMod:AddRoom("CragLanding", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.AURORA,
	contents = {
		distributepercent = 0.4,
		distributeprefabs = {
			sky_lemur = 0.005,
			beanlet = 0.005,
			cloud_fruit_tree = 0.01,
		},
	    countprefabs = {
	        goose = 1,
	        beanlet = 1,
	    }	
	},
})

--Longbills
TheMod:AddRoom("Bigbird_Nest", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.AURORA,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			goose = 0.00006,
			longbill = 0.00002,
			dragonblood_tree = 0.0001,
			beanlet = 0.00001,
			skyflower = 0.1,
		},
	    countprefabs = {
	        goose = 6,
	    }		
	},
})

--Beanlets
TheMod:AddRoom("Beanlet_Den", {
	coulour={r=.2,g=.2,b=.2,a=.2},
	value = GROUND.AURORA,
	contents = {
		distributepercent = 0.5,
		dsitributeprefabs = {
			beanlet = 0.009,
			skyflower = 0.1,
			dragonblood_tree = 0.01,
		},
	    countprefabs = {
	        goose = 1,
	    }
	},
})


----------
	
--Snow Biome Rooms

--Snow BG
TheMod:AddRoom("BGSnow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = 0.7,
		distributeprefabs = {
			thunder_tree = 0.008,
			ball_lightning = 0.001,
			frog = 0.002,
			skyflower = 0.1,
			owl = 0.001,
			skyflower = 0.1,
		},
	}
})

--Thunder Trees
TheMod:AddRoom("Thunder_Forest", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = 0.6,
		distributeprefabs = {
			thunder_tree = 0.0009,
			crystal_quartz = 0.0009,
			owl = 0.004,
			live_gnome = 0.0002,
			skyflower = 0.1,
		},
	    countprefabs= {
	        weavernest = 4,
	    }
	}
})

TheMod:AddRoom("Sea_Mimic", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			cloud_algae = 0.15,
			cloud_coral = 0.15,
			manta = 0.12,
			thunder_tree = 0.09,
			skyflower = 0.2,
		},
	},
})

TheMod:AddRoom("Manta_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.SNOW,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			cloud_bush = 0.03,
			manta = 0.02,
			cloud_fruit_tree = 0.02,
			colored_corn = 0.02,
			jellyshroom_blue = 0.08,
			owl = 0.004,
			skyflower = 0.1,
		},
	},
})

----------


--Rainbow Biome Rooms

--Rainbow BG
TheMod:AddRoom("BGRainbow", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = 0.6,
		distributeprefabs = {
			jellyshroom_red = 0.04,
			jellyshroom_blue = 0.04,
			jellyshroom_green = 0.04,
			skyflower = 0.1,
		},
	},
})

--Marshmallows
TheMod:AddRoom("Rainbow_Room", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			hive_marshmallow = 0.03,
			jellyshroom_red = 0.02,
			bee_marshmallow = 0.1,
			skyflower = 0.1,			
		},
	    countprefabs= {
	        crystal_white = 4,
	    }
	},
})

--Crystals
TheMod:AddRoom("Crystal_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			crystal_spire = 0.09,
			rainbowcoon = 0.05,
			jellyshroom_green = 0.05,
			skyflower = 0.1,
		},
		countprefabs= {
	        crystal_black = 4,
	    }
	},
})

--Flying Fish
TheMod:AddRoom("Fish_Fields", {
	colour={r=.2,g=.2,b=.2,a=1},
	value = GROUND.RAINBOW,
	contents = {
		distributepercent = 0.3,
		distributeprefabs = {
			cloudcrag = 0.03,
			crystal_water = 0.01,
			golden_sunflower = 0.02,
			jellyshroom_blue = 0.05,
			skyflower = 0.1,
			weavernest = 0.01,
		},
	},
})
