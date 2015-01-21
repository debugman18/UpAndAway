---
-- Main file. Run through modmain.lua
--
-- @author debugman18
-- @author simplex


BindModModule "modenv"
-- This just enables syntax conveniences.
BindTheMod()

assert(modenv.PrefabFiles)
if IsDST() then
    local excluded_prefab_files = {
        --Winnie is in progress to being ported to DST.
        --winnie = true,
    }

    local utils_table = wickerrequire "utils.table"
    utils_table.FilterArrayInPlace(modenv.PrefabFiles, function(file)
        return not excluded_prefab_files[file]
    end)
end

--[[
-- The following test checks if we are running the development branch (according to what modinfo.lua informs us).
--]]
if IsDevelopment() then
    -- This enables the prefab compiler (i.e., the automatic generation of files in scripts/prefabs).
    wickerrequire("plugins.prefab_compiler")

    -- This enables the asset compiler (i.e., the automatic generation of a file listing all of our assets).
    -- If the output filename is nil, disables it instead.
    wickerrequire("plugins.asset_compiler")(GetConfig("ASSET_COMPILER", "OUTPUT_FILE"))
end

-- This enables the save load-time check for U&A being enabled. The argument is how to call U&A
-- in the button for automatically enabling the mod. It should be short to fit in the button.
--wickerrequire('plugins.save_safeguard')("UA")


local Pred = wickerrequire "lib.predicates"
local Reflection = wickerrequire "game.reflection"

require "mainfunctions"

modrequire "api_abstractions"

modrequire "profiling"
modrequire "debugtools"
modrequire "strings"
modrequire "patches"
modrequire "postinits"
modrequire "actions"
modrequire "componentactions"
modrequire "replicas"
modrequire "rpcs"
modrequire "resources.recipes"
modrequire "resources.cooking_recipebook"

do
    local oldSpawnPrefab = _G.SpawnPrefab
    function _G.SpawnPrefab(name)
        if name == "cave" and Pred.IsCloudLevel() then
            name = "cloudrealm"
            _G.TheSim:LoadPrefabs {"cloudrealm"}
        end
        return oldSpawnPrefab(name)
    end
end


if not IsDedicated() then
	AddGamePostInit(function()
		local ground = GetWorld()
		if ground and Pred.IsCloudLevel() then
			for _, node in ipairs(ground.topology.nodes) do
				local mist = assert( SpawnPrefab("cloud_mist") )
				mist:AddToNode(node)
				if mist:IsValid() and mist.components.emitter then
					mist.components.emitter:Emit()
				end
			end
		end
	end)
end

--[[
-- This is just to prevent changes in our implementation breaking old saves.
--]]
AddSimPostInit(function()
    local LevelMeta = modrequire "lib.level_metadata"
    if LevelMeta.Get("height") == nil then
        local Climbing = modrequire "lib.climbing"
        LevelMeta.Set("height", Climbing.GetLevelHeight())
    end
end)


--[[
local function OnUnlockMound(inst)
    if not inst:IsValid() then return end

    local tree = SpawnPrefab("beanstalk_sapling")
    if tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    TheMod:DebugSay("[", inst, "] unlocked.")
    inst:Remove()
end
--]]
 

local function addmoundtag(inst)
        local function beanstalktest(inst, item)
            if item.prefab == "magic_beans" and not item:HasTag("cooked") then
                if not inst.components.workable then
                    return true
                end
            else return false end
        end

        local function beanstalkaccept(inst, giver, item)
            TheMod:DebugSay("Beans accepted.")
            local tree = SpawnPrefab("beanstalk_sapling") 
            if tree then 
                tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end 
        end

        local function beanstalkrefuse(inst, giver, item)
            TheMod:DebugSay("Dig a hole.")
            if giver.components.talker then
                giver.components.talker:Say("I need to dig a hole first.")
            end
        end

        if not inst.components.hole then
            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(beanstalktest)
            inst.components.trader.onaccept = beanstalkaccept
            inst.components.trader.onrefuse = beanstalkrefuse
            inst.components.trader:Enable()
        end

        inst:AddTag("mound")
end	

if IsHost() then
    AddPrefabPostInit("mound", addmoundtag)
end

-- This adds our minimap atlases.
AddMinimapAtlas("images/ua_minimap.xml")

-- Winnie is now compatible with both DS and DST.
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "winnie")
AddModCharacter("winnie")