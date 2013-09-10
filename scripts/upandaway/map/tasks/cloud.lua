--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


TheMod:AddTask("Explore the Realm", {
	locks = LOCKS.NONE,
	keys_given = {KEYS.TIER1, KEYS.TIER2},

	room_choices={
		--["BGCloud"] = math.random(2),
		["SkyflowerGarden"] = math.random(2, 4),
		["SheepHerd"] = math.random(2, 3),
		["BushGarden"] = math.random(2, 4),
		["GooseChase"] = math.random(2, 3),		
		["MarshmallowFields"] = math.random(2, 3),
		["CragLanding"] = math.random(2,4),
	},

	room_bg=GROUND.POOPCLOUD,
	background_room="BGCloud",
	colour={r=.8,g=.8,b=.8,a=1},
})
