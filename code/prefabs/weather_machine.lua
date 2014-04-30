BindGlobal()

local Pred = wickerrequire "lib.predicates"

local assets =
{
	Asset("ANIM", "anim/weather_machine.zip"),
}


-- List of surface weather effects.
-- Each effect takes the seasonmanager as the parameter.
local surface_weather_effects = {
	function(sm)
		sm:StartWinter()
	end,
	function(sm)
		sm:StartSummer()
	end,
	function(sm)
		if sm:GetPOP() >= 1 then
			sm:StopPrecip()
		else
			sm:ForcePrecip()
			sm:StartPrecip()
		end
	end,
	function(sm)
		sm:Cycle()
	end,
}
if IsDLCEnabled(REIGN_OF_GIANTS) then
	table.insert(surface_weather_effects, function(sm)
		sm:StartAutumn()
	end)
	table.insert(surface_weather_effects, function(sm)
		sm:StartSpring()
	end)
end


local function onload(inst, data)
	if inst.components.machine:IsOn() then
		inst.AnimState:PlayAnimation("idle_on", true)
	end
end

local function weather_off(inst)
	if not inst.components.machine:IsOn() then
		if not Pred.IsCloudRealm() then
			TheMod:DebugSay("Weather Machine Reset")
			GetPlayer().components.sanity:DoDelta(-10)
		end
	end
	inst.AnimState:PlayAnimation("idle_off", true)
end	

local function DoWeatherPick(inst)
	local sm = GetSeasonManager()
	if not sm then return end

	local weather_id = math.random(#surface_weather_effects)
	TheMod:DebugSay("[", inst, "] DoWeatherPick() weather_id = ", weather_id)

	surface_weather_effects[weather_id](sm)
end	

local function DoCloudrealmEffect(inst)
	local sm = GetSeasonManager()
	if sm then
		if IsDLCEnabled(REIGN_OF_GIANTS) then
			sm:StartAutumn()
		else
			sm:StartSummer()
		end	
	end

	local sgen = GetStaticGenerator()
	if sgen then
		sgen:ReleaseState()
		sgen:Charge()
		sgen:HoldState(math.huge)
	end
end

local function weather_on(inst)
	if inst.components.machine:IsOn() then return end


	if Pred.IsCloudRealm() then
		TheMod:DebugSay("[", inst, "] In cloudrealm.")
		DoCloudrealmEffect(inst)
	else 
		TheMod:DebugSay("[", inst, "] In another world.")
		DoWeatherPick(inst)
	end
	inst.AnimState:PlayAnimation("idle_on", true)
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("weather_machine")
	inst.AnimState:SetBuild("weather_machine")
	inst.AnimState:PlayAnimation("idle_off", true)
	--inst.Transform:SetScale(.5,.5,.5)
	--inst.AnimState:SetMultColour(0, 229, 0, 1)

	MakeObstaclePhysics(inst, .8)

	inst:AddComponent("inspectable")

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = weather_on
	inst.components.machine.turnofffn = weather_off

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("weather_machine.tex") 

    inst:AddComponent("deployable")
    inst.components.deployable.test = Pred.IsDeployablePoint
    --inst.components.deployable.ondeploy = ondeploy

    inst:AddTag("structure")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("weather_machine.tex") 

    inst.OnLoad = onload

	return inst
end

return {
	Prefab ("common/inventory/weather_machine", fn, assets),
	MakePlacer ("common/weather_machine_placer", "weather_machine", "weather_machine", "idle_off"), 
}	
