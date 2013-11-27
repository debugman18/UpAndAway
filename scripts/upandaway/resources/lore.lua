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

So peaceful. Such calm. It's very nice.
And so dreadfully BORING.
Mercurius's mind rebels against such stagnation.
How these 'gods' can remain sane in such static is beyond understanding
Static....Mercurius can feel a plan beginning to form.

]=]
