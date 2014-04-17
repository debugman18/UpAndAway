#!/usr/bin/lua

local modinfo_path = assert(arg[1], "Path to modinfo expected as argument.")

local fn
local env = {}
if _VERSION >= "Lua 5.2" then
	fn = assert(loadfile(modinfo_path, nil, env))
else
	fn = assert(loadfile(modinfo_path))
	setfenv(fn, env)
end

fn()

io.write(env.version)
