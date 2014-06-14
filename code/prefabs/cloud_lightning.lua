

local Lambda = wickerrequire 'paradigms.functional'

local Configurable = wickerrequire 'adjectives.configurable'


local cfg = Configurable("CLOUD_LIGHTNING")


local assets = {
}

local prefabs = {
--	"sparks_fx",
}


local ENABLED = cfg:GetConfig "ENABLED"

local COLOUR = cfg:GetConfig "COLOUR"
local LIFETIME = cfg:GetConfig "LIFETIME"
local RADIUS = cfg:GetConfig "RADIUS"
local LIGHT_INTENSITY = cfg:GetConfig "LIGHT_INTENSITY"
local UPDATE_PERIOD = cfg:GetConfig "UPDATE_PERIOD"

local INTENSITY_DROP_RATE = LIGHT_INTENSITY/LIFETIME
local INTENSITY_DROP_STEP = INTENSITY_DROP_RATE*UPDATE_PERIOD


local function perform(inst)
	if not ENABLED then
		inst:Remove()
		return
	end

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
    light:SetColour(COLOUR:Get())

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
