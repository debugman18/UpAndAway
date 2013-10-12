--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


TheMod:AddTask("Cloud_Generic_Biome", {
	locks = LOCKS.NONE,
	keys_given = {KEYS.TIER1},

	room_choices={
		["SkyflowerGarden"] = math.random(1, 4),
		["SheepHerd"] = math.random(2, 3),
		["BushGarden"] = math.random(2, 4),	
		["CragLanding"] = math.random(1,1),
		["Vine_Room"] = math.random(1,1),
		["Beanlet_Den"] = math.random(1,1),
		["Bigbird_Nest"] = math.random(2,2),		
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGCloud",
	colour={r=.2,g=.2,b=.2,a=1},
})

TheMod:AddTask("Cloud_Snow_Biome", {
	locks = LOCKS.TIER1,
	keys_given = {KEYS.TIER1, KEYS.TIER2},

	room_choices={
		["Aurora_Room"] = math.random(4, 4),
		["Crystal_Fields"] = math.random(2,5),
		
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGSnow",
	colour={r=.8,g=.8,b=.8,a=1},
})

TheMod:AddTask("Cloud_Aurora_Biome", {
	locks = LOCKS.TIER2,
	keys_given = {KEYS.TIER1, KEYS.TIER2, KEYS.TIER3},

	room_choices={
		["Snow_Room"] = math.random(4, 4),
		["Fish_Fields"] = math.random(3,4),
		["Manta_Room"] = math.random(2,3),
		["Sea_Mimic"] = math.random(1,3),
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGAurora",
	colour={r=.8,g=.8,b=.8,a=1},
})

TheMod:AddTask("Cloud_Rainbow_Biome", {
	locks = LOCKS.TIER1,
	keys_given = {KEYS.TIER1, KEYS.TIER2},

	room_choices={
		["Rainbow_Room"] = math.random(4, 4),
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGRainbow",
	colour={r=.8,g=.8,b=.8,a=1},
})
