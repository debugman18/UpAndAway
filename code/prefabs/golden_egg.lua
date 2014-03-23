BindGlobal()

local assets =
{
	Asset("ANIM", "anim/tallbird_egg.zip"),
	Asset("ANIM", "anim/golden_egg.zip"),
}

local prefabs = 
{
	"duckraptor",
}

local function HeatFn(inst, observer)
    --inst:DoPeriodicTask(1, function(inst)
    	--if inst.components.temperature then
    		--local heathotness = inst.components.temperature.current
			--local heatdecay = heathotness / 100000
			--local realhotness = heathotness - heatdecay 
			--inst.components.temperature:SetTemperature(realhotness)
		--end	
    --end)   
    return inst.components.temperature:GetCurrent()	
end

local function corruptegg(inst)
	--inst.AnimState:SetColour(60/255,60/255,60/255)
	inst.Light:SetColour(60/255,60/255,60/255)

	local corruption = SpawnPrefab("duckraptor")
    corruption.Transform:SetPosition(inst.Transform:GetWorldPosition())	

    local ashes = SpawnPrefab("ash")
    ashes.Transform:SetPosition(inst.Transform:GetWorldPosition())

   	inst:Remove()
end

local function OnDropped(inst)
	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 100
	inst.components.temperature.mintemp = 0
	inst.components.temperature.current = 100
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
end

local function OnPickedUp(inst)
	if inst.components.temperature then
		inst:RemoveComponent("temperature")
	end	
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

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:ListenForEvent("upandaway_uncharge", function()
		--inst.components.temperature.current = 80
	end)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickedUp)	

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 100
	inst.components.temperature.mintemp = 0
	inst.components.temperature.current = 100
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED

	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	--inst.components.heater.carriedheatfn = HeatFn

	inst:AddComponent("perishable")
	inst.components.perishable.onperishreplacement = "goldnugget"

    inst:DoPeriodicTask(1, function(inst)
    	if inst.components.temperature then
    		local hotness = inst.components.temperature.current
			local neardecay = hotness / 4
			local perishtime = hotness - neardecay 
			inst.components.perishable:SetPerishTime(perishtime)
			inst.components.perishable:StartPerishing()
			print(perishtime)    
		end	
    end)    

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.entity:AddLight()
	inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
	inst.Light:Enable(true)

	inst.player = GetPlayer()
	inst.player:ListenForEvent("goinsane", function() corruptegg(inst) end)

	return inst
end

return Prefab ("common/inventory/golden_egg", fn, assets) 
