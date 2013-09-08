--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire 'paradigms.functional'


local assets = {}

local prefabs = {
		"mist",
}


local AddToNodeError = Lambda.Error("Mist entity already added to a node!")

local function AddToNode(inst, node)
	if node.area_emitter ~= nil then
			inst:Remove()
			return
	end

	require 'emitters'

	inst.Transform:SetPosition( node.cent[1], 0, node.cent[2] )
	inst.components.emitter.area_emitter = _G.CreateAreaEmitter( node.poly, node.cent )
						
	if node.area == nil then
		node.area = 1
	end

	inst.components.emitter.density_factor = node.area/30

	TheMod:DebugSay("adding mist! area=", node.area, "; density_factor=", inst.components.emitter.density_factor)

	if inst.AddToNode == AddToNode then
			inst.AddToNode = AddToNodeError
	end
end

local function fn()
	local inst = SpawnPrefab("mist")

	inst.components.emitter.ground_height = 0.8

	inst.AddToNode = AddToNode

	return inst
end

return Prefab( "common/fx/cloud_mist", fn, assets, prefabs )
