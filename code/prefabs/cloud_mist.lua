

local Lambda = wickerrequire "paradigms.functional"

local Configurable = wickerrequire "adjectives.configurable"


local cfg = Configurable("CLOUD_MIST")


local assets = {}

local prefabs = {
        "mist",
}


local ENABLED = cfg:GetConfig "ENABLED"
local DENSITY = cfg:GetConfig "DENSITY"
local GROUND_HEIGHT = cfg:GetConfig "GROUND_HEIGHT"


local AddToNodeError = Lambda.Error("Mist entity already added to a node!")

local function AddToNode(inst, node)
    if not ENABLED or DENSITY <= 0 or node.area_emitter ~= nil then
            inst:Remove()
            return
    end

    require "emitters"

    inst.Transform:SetPosition( node.cent[1], 0, node.cent[2] )
    inst.components.emitter.area_emitter = _G.CreateAreaEmitter( node.poly, node.cent )
                        
    if node.area == nil then
        node.area = 1
    end

    inst.components.emitter.density_factor = node.area*DENSITY

    inst.AddToNode = AddToNodeError
end

local function fn()
	--[[ Non-networked entity ]]--
    local inst = SpawnPrefab("mist")

    inst.components.emitter.ground_height = GROUND_HEIGHT

    inst.AddToNode = AddToNode

    return inst
end

return Prefab( "common/fx/cloud_mist", fn, assets, prefabs )
