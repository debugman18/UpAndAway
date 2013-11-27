---
-- Generates the file with the prefab asset list.
--
-- @author simplex

--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Configurable = wickerrequire 'adjectives.configurable'
local cfg = Configurable "PREFAB_ASSET_COMPILER"


local output_file = cfg:GetConfig "OUTPUT_FILE"
if not output_file then return end
assert( type(output_file) == "string", "String or nil expected as PREFAB_ASSET_COMPILER.OUTPUT_FILE configuration value." )

local DEBUG = cfg:GetConfig "DEBUG"


local function CompilePrefabAssets()
	assert( modenv.PrefabFiles, "The mod's PrefabFiles table is not defined!" )

	local assets_map = {}
	local file_cache = {}

	for _, prefab_file in ipairs(modenv.PrefabFiles) do
		assert( type(prefab_file) == "string", "Non-string entry in PrefabFiles!" )
		local assets = {}

		for _, prefab in ipairs{domodfile("scripts/prefabs/"..prefab_file..".lua")} do
			for _, A in ipairs(prefab.assets) do
				assert( type(A.type) == "string" and type(A.file) == "string", "Invalid asset." )

				local file = A.file

				local match_start, match_end = file:find(MODROOT, 1, true)
				if match_start == 1 then
					if not file_cache[file] then
						table.insert(assets, {A.type, file:sub(match_end + 1)})
						file_cache[file] = true
					end
				end
			end
		end

		assets_map[prefab_file] = assets
	end

	return assets_map
end

---
-- @param fh The file handler to which write the asset list.
local function WritePrefabAssets(assets_map, fh)
	fh:write("return {\n")
	for prefab_file, assets in pairs(assets_map) do
		fh:write("\t-- ", prefab_file, ".lua\n")
		for _, A in ipairs(assets) do
			fh:write("\tAsset", ("(%q, %q)"):format(unpack(A)), ",\n")
		end
		fh:write("\n")
	end
	fh:write("}\n")
end

TheMod:AddClassPostConstruct("screens/mainscreen", function()
	local fh = assert( io.open(MODROOT..output_file, "w") )
	WritePrefabAssets(CompilePrefabAssets(), fh)
	fh:close()
end)
