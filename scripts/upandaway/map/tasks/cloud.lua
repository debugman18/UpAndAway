--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


TheMod:AddTask("BeanstalkSpawn", {
	locks = LOCKS.NONE,
	keys_given = KEYS.TIER1,

	room_choices={
		["BeenstalkSpawn"] = 1,
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGCloud",
	colour={r=.6,g=.7,b=.6,a=1},
})

TheMod:AddTask("Disbrave the Sky", {
	locks = LOCKS.TIER1,
	keys_given = KEYS.TIER2,

	room_choices={
		["SkyflowerGarden"] = math.random(3),
		["SheepHerd"] = math.random(2),
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGCloud",
	colour={r=.8,g=.8,b=.8,a=1},
})
