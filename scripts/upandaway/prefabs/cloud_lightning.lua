--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire 'paradigms.functional'


local assets = {
}

local prefabs = {
	"sparks_fx",
}


local LIFETIME = 0.6
local RADIUS = 2
local LIGHT_INTENSITY = 0.9

local UPDATE_PERIOD = 0.05


local INTENSITY_DROP_RATE = LIGHT_INTENSITY/LIFETIME
local INTENSITY_DROP_STEP = INTENSITY_DROP_RATE*UPDATE_PERIOD


local function perform(inst)
	local sound = inst.SoundEmitter
	local light = inst.Light

	--sound:SetParameter("rain", "intensity", 1)
	
	--[[
	local spark = SpawnPrefab("sparks_fx")
	spark.Transform:SetPosition(inst:GetPosition():Get())
	]]--

	sound:PlaySound("dontstarve/rain/thunder_close")

	light:Enable(true)
	light:SetRadius(RADIUS)
	light:SetFalloff(1)
	light:SetIntensity(LIGHT_INTENSITY)
        light:SetColour(0.5,0.7,0.7)

	local intensity = LIGHT_INTENSITY

	inst.Light:SetIntensity(intensity)

	inst:DoPeriodicTask(UPDATE_PERIOD, function(inst)
		inst.Light:SetIntensity(intensity)

		intensity = intensity - INTENSITY_DROP_STEP
		if intensity <= 0 then
			inst:Remove()
		end
	end)
end

local function fn()
	local inst = CreateEntity()
	inst.persists = false

	inst:AddTag("FX")

	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()

	inst:DoTaskInTime(0, perform)

	return inst
end

return Prefab( "common/fx/cloud_lightning", fn, assets, prefabs )
