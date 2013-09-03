--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

require 'emitters'

local function AddMist(node)
	if node.area_emitter ~= nil then return end

	TheSim:LoadPrefabs {"mist"}

	TheMod:Say("adding mist!")

	local mist = SpawnPrefab( "mist" )
	mist.Transform:SetPosition( node.cent[1], 0, node.cent[2] )
	mist.components.emitter.area_emitter = _G.CreateAreaEmitter( node.poly, node.cent )
						
	if node.area == nil then
		node.area = 1
	end
						
	mist.components.emitter.density_factor = math.ceil(node.area / 4)/31
	mist.components.emitter:Emit()
end


return AddMist
