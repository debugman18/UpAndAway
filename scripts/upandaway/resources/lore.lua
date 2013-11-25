--[[
-- Adventure lore.
--]]

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local StoryTelling = modrequire 'lib.storytelling'


MercuriusJournal = StoryTelling.Book()

MercuriusJournal:Compile()
[=[

The humble messenger is always on time
The humble Mercurius bows his head
And behind his humble smile, they are none the wiser
Of the dark thoughts that storm his mind. 

]=][=[

This would be page 2.

]=]

