---
-- Utility functions for filling STRINGS.
--
-- @author simplex
--

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

---
-- Table returned by the module. All its functions are case insensitive in respect to prefab and character names.
--
-- @class table
-- @name Add
--
local Add = {}


---
-- Adds names to a set of prefabs.
--
-- @param names Table mapping a prefab name to its user visible name.
function Add.Names(names)
	for k, v in pairs(names) do
		STRINGS.NAMES[k:upper()] = v
	end
end

local function add_quote(prefab, character, quote)
	local t = STRINGS.CHARACTERS[character:upper()].DESCRIBE

	local pieces = prefab:split(".")
	local npieces = #pieces

	for i = 1, npieces - 1 do
		local piece = pieces[i]:upper()
		if type(t[piece]) == "string" then
			t[piece] = {GENERIC = t[piece]}
		elseif not t[piece] then
			t[piece] = {}
		else
			assert( type(t[piece]) == "table" )
		end
		t = t[piece]
	end

	t[pieces[npieces]:upper()] = quote
end

---
-- Adds a set of quotes for a prefab.
--
-- @param prefab Prefab name. If containing a period, the left part is taken as the actual prefab name and the right part as its status name.
--
-- @return A function receiving a set of quotes, in the form of a table mapping a character name to a quote.
function Add.QuotesFor(prefab)
	return function(quotes)
		for character, quote in pairs(quotes) do
			add_quote(prefab, character, quote)
		end
	end
end

---
-- Adds a set of quotes for a character.
--
-- @param character Character name.
--
-- @return A function receiving a set of quotes, in the form of a table mapping a prefab name to a quote.
function Add.QuotesBy(character)
	return function(quotes)
		for prefab, quote in pairs(quotes) do
			add_quote(prefab, character, quote)
		end
	end
end


return Add
