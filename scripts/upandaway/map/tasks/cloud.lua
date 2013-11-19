--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

--Generic Biome
TheMod:AddTask("Cloud_Generic_Biome", {
	locks = LOCKS.NONE,
	keys_given = {KEYS.TIER1},

	room_choices={
		["SkyflowerGarden"] = math.random(1, 4),
		["SheepHerd"] = math.random(2, 2),
		["BushGarden"] = math.random(2, 4),
		["Bigbird_Nest"] = math.random(2,2),	
		["BGCloud"] = math.random(2,2),				
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGCloud",
	colour={r=.2,g=.2,b=.2,a=1},
  	-- The number of neighbors beyond the first that each node links to
  	crosslink_factor = 5,
  	-- Whether or not to connect the last node to the first
  	make_loop = false,	
})


--Snow Biome
TheMod:AddTask("Cloud_Snow_Biome", {
	locks = LOCKS.TIER1,
	keys_given = {KEYS.TIER1, KEYS.TIER2},

	room_choices={
		["Thunder_Forest"] = math.random(4, 4),
		["Manta_Room"] = math.random(2,3),
		["Sea_Mimic"] = math.random(1,3),	
		["CragLanding"] = math.random(2,2),	
		["BGSnow"] = math.random(2,2),	
	},

	room_bg=GROUND.FUNGUS,
	background_room="BGSnow",
	colour={r=.8,g=.8,b=.8,a=1},
  	-- The number of neighbors beyond the first that each node links to
  	crosslink_factor = 4,
  	-- Whether or not to connect the last node to the first
  	make_loop = false,	
})


--Aurora Biome
TheMod:AddTask("Cloud_Aurora_Biome", {
	locks = LOCKS.TIER1,
	keys_given = {KEYS.TIER1, KEYS.TIER2, KEYS.TIER3},

	room_choices={
		["CragLanding"] = math.random(1,2),
		["Vine_Room"] = math.random(1,2),
		["Beanlet_Den"] = math.random(1,1),		
		["Crystal_Fields"] = math.random(2,2),		
		["BGAurora"] = math.random(2,2),
	},

	room_bg=GROUND.GRASS,
	background_room="BGAurora",
	colour={r=.8,g=.8,b=.8,a=1},
	-- The number of neighbors beyond the first that each node links to
  	crosslink_factor = 0,
  	-- Whether or not to connect the last node to the first
  	make_loop = false,	
})


--Rainbow Biome
TheMod:AddTask("Cloud_Rainbow_Biome", {
	locks = LOCKS.TIER1,
	keys_given = {KEYS.TIER1, KEYS.TIER2},

	room_choices={
		["Rainbow_Room"] = math.random(2, 4),
		["Fish_Fields"] = math.random(2,4),
		["Crystal_Fields"] = math.random(2,5),	
		["Sea_Mimic"] = math.random(2,2),	
		["BGRainbow"] = math.random(2,2),
	},

	room_bg=GROUND.MARSH,
	background_room="BGRainbow",
	colour={r=.8,g=.8,b=.8,a=1},
	-- The number of neighbors beyond the first that each node links to
  	crosslink_factor = 2,
  	-- Whether or not to connect the last node to the first
  	make_loop = true,	
})
