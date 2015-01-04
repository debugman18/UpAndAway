local WGEN_PARAMS_METADATA_KEY = "upandaway_cave_support_metadata"
local UA_SERVER_SAVE_FILE_SUFFIX = "_upandaway"

---

if not IsDST() then return end

---

local Storage = pkgrequire "cave_support.storage"

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

	TheMod:AddGlobalClassPostConstruct("saveindex", "SaveIndex", function(self)
		local Load = self.Load
		self.Load = function(self, ...)
			local args = {...}
			Storage.LoadMetadata(function()
				return Load(self, unpack(args))
			end)
		end
	end)

	local function is_void_session_id(id)
		return type(id) ~= "string" or #id == 0
	end

	TheMod:AddWorldgenParametersPostConstruct(function(parameters)
		local session_id = _G.TheNet:GetSessionIdentifier()

		if is_void_session_id(session_id) then
			local file_mdata = Storage.LoadMetadata()
			session_id = file_mdata.last_session_id
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
		local file_mdata = Storage.LoadMetadata()
		
		file_mdata.last_session_id = _G.TheNet:GetSessionIdentifier()
		assert(not is_void_session_id(file_mdata.last_session_id))

		Storage.SaveMetadata(file_mdata)
	end)

	--[[
	--TODO: DEFAULT_SERVER_SAVE_FILE
	TheMod:AddGameLogicPostLoad(function()
		local Settings = assert( _G.Settings )

		if Settings.reset_action ~= _G.RESET_ACTION.LOAD_SLOT then
			return
		end

		local saveslot
		local level_type = _G.SaveGameIndex:GetCurrentMode(saveslot)

		if level_type ~= "cave" then
			return
		end

		local level_number = _G.SaveGameIndex:GetCurrentCaveLevel(saveslot)

		if not Climbing.IsCloudLevelNumber(level_number or 1) then
			return
		end

		local DEFAULT_SERVER_SAVE_FILE = assert( _G.DEFAULT_SERVER_SAVE_FILE )

		local SERVER_SAVE_FILE = DEFAULT_SERVER_SAVE_FILE..UA_SERVER_SAVE_FILE_SUFFIX
	end)
	]]--
end
