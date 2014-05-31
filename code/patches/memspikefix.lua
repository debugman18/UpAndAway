local _G = GLOBAL
local assert, error = _G.assert, _G.error
local getmetatable, setmetatable = _G.getmetatable, _G.setmetatable


--[[
-- Receives a Prefab object, and tweaks its entity constructor ("fn") to
-- make the prefab be loaded before it is spawned.
--]]
local function MakeLazyLoader(prefab)
	local fn = assert(prefab.fn)

	local current_fn

	local function new_fn(...)
		_G.TheSim:LoadPrefabs {prefab.name}

		-- Ensures this only runs once, for efficiency.
		current_fn = fn

		return fn(...)
	end

	current_fn = new_fn

	--[[
	-- This extra layer of indirection ensures greater mod friendliness.
	--
	-- If we just set prefab.fn to new_fn, and later back to fn, we could
	-- end up overriding an fn patch done by another mod. By switching between
	-- the two internally, via the current_fn upvalue, we preserve any such
	-- patching.
	--]]
	prefab.fn = function(...)
		return current_fn(...)
	end
end


local memfix_modfilter

local function generic_modfilter(modwrangler_object, moddir)
	return modwrangler_object:GetMod(moddir) ~= nil
end

local function selfish_modfilter(modwrangler_object, moddir)
	return moddir == modname
end

memfix_modfilter = selfish_modfilter

function ApplyMemFixGlobally()
	memfix_modfilter = generic_modfilter
end


local ModWrangler = assert( _G.ModWrangler )
ModWrangler.RegisterPrefabs = (function()
	local ModRegisterPrefabs = assert( ModWrangler.RegisterPrefabs )

	return function(self, ...)
		local ModWrangler_self = self

		local MainRegisterPrefabs = assert( _G.RegisterPrefabs )


		local mod_prefabnames = {}

		_G.RegisterPrefabs = function(...)
			for _, prefab in ipairs{...} do
				local moddir = prefab.name:match("^MOD_(.+)$")
				if moddir and memfix_modfilter(ModWrangler_self, moddir) then
					print("MEMFIXING "..moddir)
					for _, name in ipairs(prefab.deps) do
						table.insert(mod_prefabnames, name)
					end

					prefab.deps = {}
					--print("Purged deps from "..prefab.name)
				end
			end
			return MainRegisterPrefabs(...)
		end

		ModRegisterPrefabs(self, ...)

		_G.RegisterPrefabs = MainRegisterPrefabs

		for _, prefabname in ipairs(mod_prefabnames) do
			--print("Registering "..prefabname)
			
			local prefab = assert(_G.Prefabs[prefabname])

			MainRegisterPrefabs( prefab )

			MakeLazyLoader(prefab)

			-- This also takes care of the unloading, so there's no need to patch ModWrangler:UnloadPrefabs.
			table.insert(self.loadedprefabs, prefabname)
		end
	end
end)()
