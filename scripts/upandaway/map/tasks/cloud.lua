--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

TheMod:AddTask("BeanstalkSpawn", {
	room_choices={
		["BeefalowPlain"] = 5,
	},
	room_bg=GROUND.MARSH,
	background_room="BGMarsh",
	colour={r=0.0,g=0,b=0.0,a=0.5},
})
