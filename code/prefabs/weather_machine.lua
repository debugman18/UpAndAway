BindGlobal()

local assets =
{
	Asset("ANIM", "anim/weather_machine.zip"),
}

local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function weather_off(inst)
	if GetWorld() and not GetWorld():HasTag("cloudrealm") then
		print "Weather Machine Reset"
		GetSeasonManager():Cycle()
		GetPlayer().components.sanity:DoDelta(-10)
	end
	inst.AnimState:PlayAnimation("idle_off", true)
end	

local function DoWeatherPick(inst)
	if GetWorld() and IsDLCEnabled(REIGN_OF_GIANTS) then
		weather_id = math.random(1,7)
		GetPlayer().components.sanity:DoDelta(-40)
		if weather_id == 1 then
			print(weather_id)
			GetSeasonManager():StartWinter()
		elseif weather_id == 2 then
			print(weather_id)
			GetSeasonManager():StartSummer()
		elseif weather_id == 3 then
			print(weather_id)
			GetSeasonManager():StartPrecip()
		elseif weather_id == 4 and GetSeasonManager().precip then
			print(weather_id)
			GetSeasonManager():StopPrecip()
		elseif weather_id == 5 then	
			print(weather_id)
			GetSeasonManager():Cycle()
		elseif weather_id == 6 then
			print(weather_id)
			GetSeasonManager():StartAutumn()
		elseif weather_id == 7 then
			print(weather_id)
			GetSeasonManager():StartSpring()								
		end	
	else	
		weather_id = math.random(1,5)
		GetPlayer().components.sanity:DoDelta(-40)
		if weather_id == 1 then
			print(weather_id)
			GetSeasonManager():StartWinter()
		elseif weather_id == 2 then
			print(weather_id)
			GetSeasonManager():StartSummer()
		elseif weather_id == 3 then
			print(weather_id)
			GetSeasonManager():StartPrecip()
		elseif weather_id == 4 and GetSeasonManager().precip then
			print(weather_id)
			GetSeasonManager():StopPrecip()
		elseif weather_id == 5 then	
			print(weather_id)
			GetSeasonManager():Cycle()
		end	
	end	
end	

local function weather_on(inst)
	if GetWorld() and GetWorld():HasTag("cloudrealm") then
		print "In cloudrealm."
		GetSeasonManager():StartSummer()
		inst:DoPeriodicTask(10, function(inst) GetWorld().components.staticgenerator:Charge() end)
	else 
		print "In another world."
		DoWeatherPick()
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
    inst.components.deployable.test = test_ground
    --inst.components.deployable.ondeploy = ondeploy

    inst:AddTag("structure")

	return inst
end

return {
	Prefab ("common/inventory/weather_machine", fn, assets),
	MakePlacer ("common/weather_machine_placer", "weather_machine", "weather_machine", "idle_off"), 
}	
