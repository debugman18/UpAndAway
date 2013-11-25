--[[
-- Utilities for lore organization and manipulation.
--]]

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Pred = wickerrequire 'lib.predicates'

local Debuggable = wickerrequire 'adjectives.debuggable'


--[[
-- For now, this just wraps a table. It is used instead of a bare table
-- to make it easier to extend its functionality later on without touching
-- the rest of the code.
--]]
Book = Class(Debuggable, function(self)
	self.pages = {}
end)

Pred.IsBook = Pred.IsInstanceOf(Book)
local IsBook = Pred.IsBook

function Book:AddPage(p)
	assert( IsBook(self) )
	assert( Pred.IsWordable(p) )
	table.insert( self.pages, tostring(p):gsub("^%s+", ""):gsub("%s+$", "") )
end

--[[
-- Returns a function which gathers its (string) arguments in the table
-- book, 
--]]
function Book:Compiler()
	local function compiler(page)
		self:AddPage(page)
		return compiler
	end
	return compiler
end
