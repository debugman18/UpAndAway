---
-- Utility functions for filling STRINGS.
--
-- @author simplex
--


---
-- Table returned by the module. All its functions are case insensitive in respect to prefab and character names.
--
-- @class table
-- @name Add
--
local Add = {}

---
-- Returns all characters. To be used as an iterator.
local all_characters = (function()
	local lists = {rawget(_G, "MAIN_CHARACTERLIST") or rawget(_G, "CHARACTERLIST"), _G.MODCHARACTERLIST}
	local dlc_list = rawget(_G, "ROG_CHARACTERLIST")
	if dlc_list then
		table.insert(lists, dlc_list)
	end

	return function()
		return coroutine.wrap(function()
			coroutine.yield("GENERIC")
			for _, list in ipairs(lists) do
				for _, character in ipairs(list) do
					coroutine.yield(character)
				end
			end
		end)
	end
end)()

---
-- Adds names to a set of prefabs.
--
-- @param names Table mapping a prefab name to its user visible name.
function Add.Names(names)
	for ks, v in pairs(names) do
		if type(ks) ~= "table" then ks = {ks} end
		for _, k in ipairs(ks) do
			local ku = k:upper()
			local real_v = v
			if type(v) == "function" then
				real_v = v(ku)
			end
			STRINGS.NAMES[ku] = real_v
		end
	end
end

local function add_quote(prefab, character_upper, quote)
	if not STRINGS.CHARACTERS[character_upper] then return end

	local t = STRINGS.CHARACTERS[character_upper].DESCRIBE

	local pieces = prefab:split(".")
	local npieces = #pieces

	for i = 1, npieces - 1 do
		pieces[i] = pieces[i]:upper()
		local piece = pieces[i]
		if type(t[piece]) == "string" then
			t[piece] = {GENERIC = t[piece]}
		elseif not t[piece] then
			t[piece] = {}
		else
			assert( type(t[piece]) == "table" )
		end
		t = t[piece]
	end
	pieces[npieces] = pieces[npieces]:upper()

	local real_quote = quote
	if type(quote) == "function" then
		real_quote = quote(character_upper, unpack(pieces))
	end

	t[pieces[npieces]] = real_quote
end

---
-- Adds a set of quotes for a prefab.
--
-- @param prefab Prefab name. If containing a period, the left part is taken as the actual prefab name and the right part as its status name.
--
-- @return A function receiving a set of quotes, in the form of a table mapping a character name to a quote.
function Add.QuotesFor(prefabs)
	if type(prefabs) ~= "table" then
		prefabs = {prefabs}
	end

	return function(quotes)
		for _, prefab in ipairs(prefabs) do
			local anyquote = quotes.any or quotes.ANY or quotes.Any
			if anyquote then
				for character in all_characters() do
					add_quote(prefab, character:upper(), anyquote)
				end
			end

			for characters, quote in pairs(quotes) do
				if type(characters) ~= "table" then characters = {characters} end
				for _, character in ipairs(characters) do
					local character_upper = character:upper()
					if character_upper ~= "ANY" then
						add_quote(prefab, character_upper, quote)
					end
				end
			end
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
	local character_upper = character:upper()
	return function(quotes)
		for prefabs, quote in pairs(quotes) do
			if type(prefabs) ~= "table" then prefabs = {prefabs} end
			for _, prefab in ipairs(prefabs) do
				add_quote(prefab, character_upper, quote)
			end
		end
	end
end


return Add
