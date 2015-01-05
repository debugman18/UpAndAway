local WGEN_PARAMS_METADATA_KEY = "upandaway_cave_support_metadata"
local METADATA_FILE_SUFFIX = "cave_support_metadata"

---

if not IsDST() then return end

---

local Climbing = modrequire "lib.climbing"

---

if IsWorldgen() then
	wickerrequire "plugins.addgeneratenewpreinit"

	TheMod:AddGenerateNewPreInit(function(parameters)
		if not Climbing.IsCloudLevelNumber(parameters.current_level or 1) then return end

		local mdata = parameters[WGEN_PARAMS_METADATA_KEY]
		if not (mdata and mdata.last_session_id) then
			TheMod:Warn("Session id metadata wasn't found, custom cave support disabled.")
			return
		end

		local session_id = mdata.last_session_id

		TheMod:Say("Faking session identifier generation for cave support... (session_id = ", session_id, ")")

		local WorldSim = assert( _G.WorldSim )

		local worldsim_meta = assert( debug.getmetatable(WorldSim) )
		local worldsim_index = assert( rawget(worldsim_meta, "__index") )

		worldsim_index.GenerateSessionIdentifier = function()
			return session_id
		end
	end)
else
	wickerrequire "plugins.addworldgenparameterspostconstruct"
	--wickerrequire "plugins.addgamelogicpostload"
	
	local FileMetadata = wickerrequire "gadgets.persistentdata"(METADATA_FILE_SUFFIX, {})

	TheMod:AddGlobalClassPostConstruct("saveindex", "SaveIndex", function(self)
		self.Load = FileMetadata:HookLoad(self.Load)
	end)

	local function is_void_session_id(id)
		return type(id) ~= "string" or #id == 0
	end

	TheMod:AddWorldgenParametersPostConstruct(function(parameters)
		local session_id = _G.TheNet:GetSessionIdentifier()

		if is_void_session_id(session_id) then
			session_id = FileMetadata().last_session_id
		end

		if is_void_session_id(session_id) then
			TheMod:Warn("Unable to determine previous session id, custom cave support disabled.")
			return
		end

		TheMod:Say("Saving session metadata for custom cave support... (session_id = ", session_id, ")")

		local mdata = parameters[WGEN_PARAMS_METADATA_KEY]
		if mdata == nil then
			mdata = {}
			parameters[WGEN_PARAMS_METADATA_KEY] = mdata
		end

		mdata.last_session_id = session_id
	end)

	TheMod:AddSimPostInit(function()
		local md = FileMetadata()

		md.last_session_id = _G.TheNet:GetSessionIdentifier()
		assert(not is_void_session_id(md.last_session_id))

		FileMetadata:Save()
	end)

	if IsServer() then
		TheMod:AddPrefabPostInit("world", function(wrld)
			wrld:AddComponent("ua_playertracker")
		end)
	end
end
