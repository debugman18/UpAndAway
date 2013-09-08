--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

local Add = {}


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

function Add.QuotesFor(prefab)
	return function(quotes)
		for character, quote in pairs(quotes) do
			add_quote(prefab, character, quote)
		end
	end
end

function Add.QuotesBy(character)
	return function(quotes)
		for prefab, quote in pairs(quotes) do
			add_quote(prefab, character, quote)
		end
	end
end


return Add
