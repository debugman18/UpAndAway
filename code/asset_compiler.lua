---
-- Generates the file with the prefab asset list.
--
-- @author simplex



local Configurable = wickerrequire 'adjectives.configurable'
local cfg = Configurable "ASSET_COMPILER"


local output_file = cfg:GetConfig "OUTPUT_FILE"
if not output_file then return end
assert( type(output_file) == "string", "String or nil expected as ASSET_COMPILER.OUTPUT_FILE configuration value." )

local DEBUG = cfg:GetConfig "DEBUG"


local function CompilePrefabAssets()
	local mod = assert( _G.ModManager:GetMod(modenv.modname), "Unable to find self in the ModManager!" )


	local process_assetlist = (function()
		local file_cache = {}

		return function(assets)
			local ret = {}
			for _, A in ipairs(assets) do
				assert( type(A.type) == "string" and type(A.file) == "string", "Invalid asset." )

				local file = A.file

				local match_start, match_end = file:find(MODROOT, 1, true)
				if match_start == 1 then
					if not file_cache[file] then
						table.insert(ret, {A.type, file:sub(match_end + 1)})
						file_cache[file] = true
					end
				end
			end
			return ret
		end
	end)()


	local assets_map = {}

	for prefab_name, prefab in pairs( mod.Prefabs ) do
		assets_map[prefab_name] = process_assetlist( prefab.assets )
	end

	assets_map["modbaseprefabs/MOD_"..modenv.modname] = process_assetlist( mod.Assets )

	return assets_map
end

---
-- @param fh The file handler to which write the asset list.
local function WritePrefabAssets(assets_map, fh)
	fh:write("return {\n")
	for prefab_name, assets in pairs(assets_map) do
		fh:write("\t-- ", prefab_name, "\n")
		for _, A in ipairs(assets) do
			fh:write("\tAsset", ("(%q, %q)"):format(unpack(A)), ",\n")
		end
		--fh:write("\n")
	end
	fh:write("}\n")
end

TheMod:AddClassPostConstruct("screens/mainscreen", function()
	local fh = assert( io.open(MODROOT..output_file, "w") )
	WritePrefabAssets(CompilePrefabAssets(), fh)
	fh:close()
end)
