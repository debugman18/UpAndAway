#!/usr/bin/lua

local function usage(fh)
	fh:write( ("%s: <prefix> <file>\n"):format(arg[0]) )
	fh:write( "\n" )
	fh:write( "Normalizes the intra-mod require calls to '.' as a separator.\n" )
	fh:write( "the 'prefix' parameter is the name of the mod's private scripts/ subdirectory.\n" )
end

local prefix, file = ...

if not (prefix and file) then
	usage(io.stderr)
	os.exit(1)
end

assert( prefix )
assert( file )

local function slurpFile()
	local lines = {}

	local fh = assert( io.open(file, "r") )
	for l in fh:lines() do
		table.insert(lines, l)
	end
	fh:close()

	return lines
end

local function writeFile(lines)
	local fh = assert( io.open(file, "wb") )

	for _, l in ipairs(lines) do
		fh:write(l, "\n")
	end

	fh:close()
end

local SEP = "./\\"
local function processString(str)
	local pieces = {}
	for m in str:gmatch("[^"..SEP.."]+") do
		table.insert(pieces, m)
	end
	assert(#pieces > 0)

	local MYSEP = "/"

	if pieces[1] == prefix then
		MYSEP = "."
	end

	return table.concat(pieces, MYSEP)
end

local function processLine(l)
	return l:gsub([=[require ["'](.-)["']]=], function(str)
		local ret = 'require "'..processString(str)..'"'
		print(ret)
		return ret
	end)
end

local lines = slurpFile()
for i, l in ipairs(lines) do
	lines[i] = processLine(l)
end
writeFile(lines)
