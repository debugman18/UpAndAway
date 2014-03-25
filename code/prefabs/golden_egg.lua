BindGlobal()

local assets =
{
	Asset("ANIM", "anim/tallbird_egg.zip"),
	Asset("ANIM", "anim/golden_egg.zip"),
}

local prefabs = 
{
	"goldnugget",
	"duckraptor",
}

local cfg = wickerrequire("adjectives.configurable")("GOLDEN_EGG")
local PatchedComponents = modrequire "patched_components"
local Effects = modrequire "lib.effects"

local function HeatFn(inst, observer)
    return inst.components.temperature:GetCurrent()	
end

local get_perish_rate = (function()
	-- Temperature for which the rate is 1.
	local base_temp = 30

	local freeze_temp = cfg:GetConfig "FREEZE_TEMP"

	assert( base_temp > freeze_temp )
	
	return function(inst)
		local temp = inst.components.temperature
		if not temp then return 0 end

		return math.max(
			0,
			(temp:GetCurrent() - freeze_temp)/(base_temp - freeze_temp)
		)
	end
end)()

local function force_drop(inst)
	local inventoryitem = inst.components.inventoryitem
	if inventoryitem then
		Effects.ThrowItemFromContainer(inst)
		inventoryitem.canbepickedup = false
	end
end

local function corruptegg(inst)
	force_drop(inst)

	--inst.AnimState:SetColour(60/255,60/255,60/255)
	inst.Light:SetColour(60/255,60/255,60/255)

	local chargeable = inst.components.staticchargeable
	if chargeable and chargeable:IsCharged() then
		chargeable:HoldState(1.5)
	end

	inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_jump")
	inst.AnimState:PlayAnimation("toohot")

	inst:DoTaskInTime(20*_G.FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_explo")

		local corruption = SpawnPrefab("duckraptor")
		corruption.Transform:SetPosition(inst.Transform:GetWorldPosition())	

		local ashes = SpawnPrefab("ash")
		ashes.Transform:SetPosition(inst.Transform:GetWorldPosition())

		inst:Remove()
	end)
end

local function on_charged(inst)
	if inst.components.inventoryitem then
		force_drop(inst)
	end

	if inst.components.temperature then
		inst.AnimState:PlayAnimation("idle_hot", true)
	end
	
	inst:StartThread(function()
		local charge_rate = 100/cfg:GetConfig("BASE_CHARGE_TIME")
		
		local chargeable = inst.components.staticchargeable

		while true do
			local player = GetPlayer()
			if player and player.components.sanity and player.components.sanity:IsCrazy() then
				corruptegg(inst)
				break
			end

			local dt = 1 + math.random()
			_G.Sleep(dt)

			if not (inst:IsValid() and chargeable:IsCharged()) then
				break
			end

			local temp = inst.components.temperature
			if temp then
				temp:SetTemp( temp:GetCurrent() + dt*charge_rate )
			end
		end

		if not inst:IsValid() then return end

		if inst.components.temperature then
			inst.components.temperature:SetTemp(nil)
		end
	end)
end

local function on_uncharged(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = true
	end

	inst.AnimState:PlayAnimation("egg")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("egg")
    inst.AnimState:SetBuild("golden_egg")
    inst.AnimState:PlayAnimation("egg")

    inst.Transform:SetScale(1.2, 1.2, 1.2)

	--[[
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	]]--

	inst:AddComponent("inspectable")

	inst:AddComponent("staticchargeable")
	do
		local chargeable = inst.components.staticchargeable

		chargeable:SetOnChargedFn(on_charged)
		chargeable:SetOnUnchargedFn(on_uncharged)

		chargeable:SetOnChargedDelay(math.random())
		chargeable:SetOnUnchargedDelay(0.5*math.random())
	end

	inst:AddComponent("inventoryitem")
	do
		local inventoryitem = inst.components.inventoryitem

		-- FIXME: remove this once we have a proper icon.
		inventoryitem:ChangeImageName("tallbirdegg")
	end

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = cfg:GetConfig "MAX_TEMP"
	inst.components.temperature.mintemp = cfg:GetConfig "MIN_TEMP"
	inst.components.temperature.current = cfg:GetConfig "INITIAL_TEMP"
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
	inst:AddTag("show_temperature")

	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	inst.components.heater.carriedheatfn = HeatFn

	PatchedComponents.Add(inst, "flexible_perishable")
	do
		local perishable = inst.components.perishable

		perishable.onperishreplacement = "goldnugget"
		perishable:SetPerishTime(cfg:GetConfig("BASE_PERISH_TIME"))
		perishable:SetRate(get_perish_rate)
		perishable:StartPerishing()
	end
	inst:AddTag("show_spoilage")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.entity:AddLight()
	inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
	inst.Light:Enable(true)
	inst.Light:SetDisableOnSceneRemoval(false)

	return inst
end

return Prefab ("common/inventory/golden_egg", fn, assets) 
