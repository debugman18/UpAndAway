#!/usr/bin/lua

local TAB = (" "):rep(4)

--[[
-- Stuff that actually does the work.
--]]

local function new_key_sorter(minus_infinities, excluded_keys)
	local infinities_map = {}
	for i, n in ipairs(minus_infinities or {}) do
		infinities_map[n] = i
	end

	local excluded_map = {}
	for _, k in ipairs(excluded_keys or {}) do
		excluded_map[k] = true
	end

	local function key_sort(a, b)
		if infinities_map[a] then
			return not infinities_map[b] or infinities_map[a] < infinities_map[b]
		end
		if infinities_map[b] then
			return false
		end
		return a < b
	end

	return function(t)
		local u = {}
		for k in pairs(t) do
			if not excluded_map[k] then
				table.insert(u, k)
			end
		end
		table.sort(u, key_sort)
		return u
	end
end

local process_names_table
-- Maps internal prefab names to the STRINGS.NAMES value.
local names_map
-- Normalises a name into the internal prefab name.
local normalise_prefab_name
do
	local sort_names = new_key_sorter()

	names_map = setmetatable({}, {
		__tostring = function(self)
			local chunks = {"Add.Names {"}
			for _, internal in ipairs(sort_names(self)) do
				local external = self[internal]
				table.insert(chunks, TAB..("%s = %q,"):format(internal, external))
			end
			table.insert(chunks, "}")
			return table.concat(chunks, "\n")
		end,
	})

	-- Inverse of the above, but takes the contents of STRINGS.NAMES in lowercase,
	-- with spaces replaced by underscores.
	local inverse_names_map = {}

	normalise_prefab_name = function(name)
		local original_name = name

		name = name:lower():gsub(" ", "_")

		local suf
		do
			local pref
			pref, suf = name:match("^(.-)(%..+)$")
			if pref then
				name = pref
			else
				suf = ""
			end
		end

		if names_map[name] then
			return name..suf
		end
		
		local int = inverse_names_map[name]
		if not int then
			return error(("Invalid prefab name %q."):format(original_name), 0)
		end
		return int..suf
	end

	process_names_table = function(t)
		for internal, external in pairs(t) do
			local int_lc, ext_lc = internal:lower(), external:lower()
			ext_lc = ext_lc:gsub(" ", "_")
			names_map[int_lc] = external
			inverse_names_map[ext_lc] = int_lc
		end
	end
end

local quotesfor

local new_quoter, is_quoter
do
	local sort_keys = new_key_sorter({"ANY", "GENERIC"}, {1})

	local function normalise_char_name(name)
		if name == "ANY" or name == "GENERIC" then
			return name
		else
			return name:lower()
		end
	end

	local meta = {
		__index = function(self, k)
			return rawget(self, normalise_char_name(k))
		end,

		__newindex = function(self, k, v)
			rawset(self, normalise_char_name(k), v)
		end,

		__tostring = function(self)
			local chunks = {('Add.QuotesFor %q {'):format( assert(self[1]) )}

			local quotes = assert( quotesfor[self[1]] )

			for _, k in ipairs(sort_keys(quotes)) do
				local v = quotes[k]
				table.insert(chunks, TAB..("%s = %q,"):format(k, v))
			end

			table.insert(chunks, "}")
			return table.concat(chunks, "\n")
		end,
	}

	new_quoter = function(name)
		name = name:lower()
		local ret = setmetatable({name}, meta)
		quotesfor[name] = ret
		return ret
	end

	is_quoter = function(x)
		return getmetatable(x) == meta
	end
end

quotesfor = setmetatable({}, {
	__index = function(self, k)
		k = normalise_prefab_name(k)
		local v = rawget(self, k)
		if v == nil then
			return new_quoter(k)
		else
			return v
		end
	end,
	__newindex = function(self, k, v)
		rawset(self, normalise_prefab_name(k), v)
	end,
})

-- Receives the stuff between curly brackets.
local function parse_quotes(name, str)
	local ret = new_quoter(name)

	for _, qt in ipairs{'"', "'"} do
		for name, quote in str:gmatch('\n%s+(%S+)%s*=%s*'..qt..'(.-[^\\])'..qt..',?') do
			ret[name] = quote
		end
		for name in str:gmatch('\n%s+(%S+)%s*=%s*'..qt..qt..',?') do
			ret[name] = ""
		end
	end

	return ret
end


------------------------------------------------------------------------

--[[
-- File/string processing.
--]]

local function safe_run(str)
	local f
	local env = {}
	if _VERSION >= "Lua 5.2" then
		f = assert(load(str, nil, nil, env))
	else
		f = assert(loadstring(str))
		setfenv(f, env)
	end
	return f()
end

local function open_file(name, mode)
	mode = mode or "r"
	if not name or name == "-" then
		return mode == "r" and io.stdin or io.stdout
	else
		return assert( io.open(name, mode) )
	end
end

local function close_file(fh)
	if fh ~= io.stdin and fh ~= io.stdout then
		fh:close()
	end
end

local function printable_fname(fname, default)
	if fname and fname ~= "-" then
		return fname
	else
		return default
	end
end

local function printable_in_fname(fname)
	return printable_fname(fname, "from standard input")
end

local function printable_out_fname(fname)
	return printable_fname(fname, "standard output")
end

local function chomp(str)
	if str then
		return str:gsub("^%s+", ""):gsub("%s+$", "")
	end
end

local function process_strings_script(fname)
	io.stderr:write("Processing strings script ", printable_in_fname(fname), "...\n")
	local fh = open_file(fname)

	local contents = fh:read("*a")
	close_file(fh)

	do
		local pattern = "\n[^%S\n]*Add%.Names%s*(%b{})"

		local found_names_table = false
		for names_table_str in contents:gmatch(pattern) do
			found_names_table = true
			process_names_table( safe_run("return "..names_table_str) )
		end
		assert( found_names_table, "Add.Names block expected in strings script." )

		found_names_table = false
		contents = contents:gsub(pattern, function(str)
			if found_names_table then return "" end
			found_names_table = true

			return "\n"..tostring(names_map)
		end)
	end

	local chunks = {}
	local status, err = pcall(function()
		local which_quote = 1
		local last_pos = 1
		for begin_pos, prefab, quoteblock, end_pos in contents:gmatch('\n%s*()Add%.QuotesFor%s*"(.-)"%s*(%b{})()') do
			table.insert(chunks, contents:sub(last_pos, begin_pos - 1))

			parse_quotes(prefab, quoteblock)
			table.insert(chunks, which_quote)
			which_quote = which_quote + 1

			last_pos = end_pos
		end
		table.insert(chunks, contents:sub(last_pos))
	end)
	if not status then
		io.stderr:write("FATAL ERROR:\n", err, "\n(did you forget to give it a name in Add.Names?)\nAborted.\n")
		os.exit(1)
	end

	io.stderr:write("Processed strings script.\n")
	return chunks
end

local function process_new_strings_file(fname, chunks)
	io.stderr:write("Processing new strings file ", printable_in_fname(fname), "...\n")
	local fh = open_file(fname)

	local linecnt = 0

	io.stderr:write("Waiting for character name...\n")

	local charname
	repeat
		linecnt = linecnt + 1
		charname = chomp(fh:read())
	until charname == nil or #charname > 0

	if charname == nil then
		io.stderr:write("Empty new strings file, skipping...\n")
		return chunks
	end

	io.stderr:write("Got character name: ", charname, "\n")

	io.stderr:write("Processing new quotes for ", charname, "...\n")
	local status, err = pcall(function()
		for line in fh:lines() do
			linecnt = linecnt + 1
			if not line:match("^%s*$") then
				local prefab, quote = line:match("^%s*(.-):(.+)$")
				if not prefab or #prefab == 0 then
					io.stderr:write("Invalid line:\n", " => ", line, "\nAborted.\n")
					os.exit(1)
				end
				quotesfor[chomp(prefab)][charname] = chomp(quote)
			end
		end
	end)
	close_file(fh)
	if not status then
		io.stderr:write("ERROR at line ", linecnt, " of ", printable_fname(fname, "standard input"), ":\n", err, "\nAborted.\n")
		os.exit(1)
	end
	io.stderr:write("Finished processing new quotes.\n")

	io.stderr:write("Processed new strings file.\n")
	return chunks
end

local function print_resulting_strings_script(fname, chunks)
	io.stderr:write("Writing resulting strings script to ", printable_out_fname(fname), "...\n")
	local fh = open_file(fname, "w")

	local quotesfor_keys = new_key_sorter()(quotesfor)
	local last_key_idx_used = 0

	local final_strings_file_chunks = {}
	for i, v in ipairs(chunks) do
		if type(v) == "number" then
			last_key_idx_used = v
			v = quotesfor[quotesfor_keys[v]]
		end
		final_strings_file_chunks[i] = tostring(v)
	end

	for v = last_key_idx_used + 1, #quotesfor_keys do
		table.insert(final_strings_file_chunks, "\n"..tostring(quotesfor[quotesfor_keys[v]]).."\n")
	end

	fh:write(table.concat(final_strings_file_chunks))
	io.stderr:write("Finished writing resulting strings script.\n")
end


------------------------------------------------------------------------

--[[
-- Program arguments handling. Actual execution.
--]]

local function print_usage()
	io.stderr:write("Usage: "..arg[0]..[[ <STRINGS-SCRIPT> [NEW-STRINGS-FILE]

Embeds the new quotes in NEW-STRINGS-FILE into STRINGS-SCRIPT, printing
the new script to standard output.

The first line of NEW-STRINGS-FILE must consist of the name of the
character whose quotes are being added. The remaining lines must be either
blank or have the form
prefab: quote
where prefab may be either the internal prefab name or its name in
STRINGS.NAMES.

NEW-STRINGS-FILE defaults to standard input.
]])
end

local strings_script_name, new_strings_file_name = ...

if not strings_script_name then
	print_usage()
	os.exit(1)
end

local chunks = process_strings_script(strings_script_name)
chunks = process_new_strings_file(new_strings_file_name, chunks)
print_resulting_strings_script(nil, chunks)
