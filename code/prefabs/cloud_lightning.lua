-- IMPORTANT: This is a non-networked entity.

local Lambda = wickerrequire "paradigms.functional"

local Configurable = wickerrequire "adjectives.configurable"


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

local function make_nonet_entity(parent)
    local inst = CreateEntity()
    inst.persists = false

    inst:AddTag("FX")

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()

	if parent then
		assert( IsDST() )
		parent:AddChild( inst )
		inst.Transform:SetFromProxy(parent.GUID)
	end

    inst:DoTaskInTime(0, perform)

    return inst
end

local function nonet_fn()
	return make_nonet_entity(nil)
end

local fn
if IsSingleplayer() then
	fn = nonet_fn
else
	fn = function()
		local inst = CreateEntity()
		inst.persists = false

		if not IsDedicated() and ENABLED then
			inst.local_child = make_nonet_entity(inst)
		end

		------------------------------------------------------------------------
		SetupNetwork(inst)
		------------------------------------------------------------------------

		if inst.local_child then
			inst:ListenForEvent("onremove", inst.Remove, inst.local_child)
		else
			inst:DoTaskInTime(1.1*LIFETIME + 2*FRAMES, inst.Remove)
		end

		return inst
	end
end

return {
	Prefab( "common/fx/cloud_lightning", fn, assets, prefabs ),
	Prefab( "common/fx/cloud_lightning_nonet", nonet_fn, assets, prefabs ),
}
