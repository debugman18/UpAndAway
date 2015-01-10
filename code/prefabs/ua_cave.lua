local cave_prefabs =
{
	"world",
	"forest",
}

local assets =
{
    Asset("IMAGE", "images/colour_cubes/caves_default.tex"),

	Asset("IMAGE", "images/colour_cubes/fungus_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/sinkhole_cc.tex"),
}

local function setup_ambient_sound(inst, preset)
	preset = preset or "default"

    local TUNING_OVERRIDES = require "tuning_override"
    if not IsDST() then
        TUNING_OVERRIDES = TUNING_OVERRIDES.OVERRIDES
    end

    TUNING_OVERRIDES.areaambientdefault = (function()
        local oldfn = TUNING_OVERRIDES.areaambientdefault
        local function newfn(...)
            TheSim:SetReverbPreset(preset)
            return oldfn(...)
        end
        if IsDST() then
            return newfn
        else
            oldfn = assert( oldfn.doit )
            return { doit = newfn }
        end
    end)()
end

local cc_override_data = setmetatable({}, {__mode = "k"})
local function setup_colourcube_override(inst, cc)
	if cc ~= nil and (type(cc) ~= "string" or not _G.kleifileexists(cc)) then
		return error("Invalid colourcube override '"..tostring(cc).."'.", 2)
	end

	if not IsDST() then
		local ccman = assert( inst.components.colourcubemanager )

		ccman:SetOverrideColourCube(cc)
    else
        assert(inst.components.colourcube)

		local data = cc_override_data[inst]
		if data == nil then
			data = {}
			cc_override_data[inst] = data
		end

		data.cc = cc

		local dooverride = data.dooverride
		if dooverride == nil then
			dooverride = function()
				inst:PushEvent("overridecolourcube", data.cc)
			end
			data.dooverride = dooverride
		end

        dooverride()

		local callback = data.callback
		if callback and cc == nil then
			inst:RemoveEventCallback("overridecolourcube", callback)
		elseif not callback and cc ~= nil then
			-- This is for the mess caused by inst:SetGhostMode(), where inst is a player.
			callback = function(inst, new_cc)
				if not new_cc and data.cc ~= nil then
					data.dooverride()
				end
			end
			data.callback = callback
			inst:ListenForEvent("overridecolourcube", callback)
		end
    end
end

local function addcmp(inst, cmpname)
	local cmp = inst.components[cmpname]
	if cmp == nil then
		inst:AddComponent(cmpname)
		cmp = inst.components[cmpname]
	end
	return cmp
end

local function fn()
	local inst = SpawnPrefab("world")
	--inst:AddTag("cave")

	inst.prefab = "cave"

	if IsSingleplayer() then
		addcmp(inst, "clock")
		--inst:AddComponent("quaker")
		addcmp(inst, "seasonmanager")
		--inst:DoTaskInTime(0, function(inst) inst.components.seasonmanager:SetCaves() end)
		addcmp(inst, "colourcubemanager")
	end

	if IsRoG() then
		addcmp(inst, "bigfooter")
	end

	---
	
	if IsDST() and IsMasterSimulation() then
		addcmp(inst, "playerspawner")
		addcmp(inst, "shadowcreaturespawner")
		addcmp(inst, "shadowhandspawner")
    end

	---
	
	if IsDST() then
		addcmp(inst, "ambientlighting")
		if not IsDedicated() then
			addcmp(inst, "dynamicmusic")
			addcmp(inst, "ambientsound")
			addcmp(inst, "colourcube")
			addcmp(inst, "hallucinations")
		end
	end

	---

	setup_ambient_sound(inst)

	inst.SetReverbPreset = setup_ambient_sound
	inst.SetOverrideColourCube = setup_colourcube_override

    return inst
end

return Prefab("worlds/ua_cave", fn, assets, cave_prefabs) 
