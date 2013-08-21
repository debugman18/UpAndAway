local mushassets=
{
	Asset("ANIM", "anim/new_mushrooms.zip"),
}

local cookedassets = 
{
	Asset("ANIM", "anim/new_mushrooms.zip"),
}

local function MakeMushroom(data)

    local capassets = 
    {
		Asset("ANIM", "anim/new_mushrooms.zip"),
    }

    local prefabs =
    {
        data.pickloot
    }    

	local function dig_up(inst, chopper)
		if inst.components.pickable and inst.components.pickable:CanBePicked() then
			inst.components.lootdropper:SpawnLootPrefab(data.pickloot)
		end

		inst.components.lootdropper:SpawnLootPrefab(data.pickloot)
		inst:Remove()
	end

    local function onsave(inst, data)
        data.rain = inst.rain
    end

    local function onload(inst, data)
        if data.rain or inst.rain then
            inst.rain = data.rain or inst.rain
        end
    end

    local function onpickedfn( inst )
        inst.AnimState:PlayAnimation("picked")
        inst.rain = 10 + math.random(10)
    end
    
    
    local function makeemptyfn( inst )
        inst.AnimState:PlayAnimation("picked")
    end

    local function checkregrow(inst)
        if inst.components.pickable and not inst.components.pickable.canbepicked and GetSeasonManager():IsRaining() then
            inst.rain = inst.rain - 1
            if inst.rain <= 0 then
                inst.components.pickable:Regen()
            end
        end        
    end

    local function open(inst)
        if inst.components.pickable and inst.components.pickable:CanBePicked() then
            if inst.growtask then
                inst.growtask:Cancel()
            end
            inst.growtask = inst:DoTaskInTime(3+math.random()*6, function() 
                    inst.AnimState:PlayAnimation("open_inground")
                    inst.AnimState:PushAnimation("open_"..data.animname)
                    inst.AnimState:PushAnimation(data.animname)
                    inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
                    inst.growtask = nil
                    if inst.components.pickable then
                        inst.components.pickable.caninteractwith = true
                    end
                end)
        end        
    end

    local function GetStatus(inst)
        if inst.components.pickable and inst.components.pickable.canbepicked and not inst.components.pickable.caninteractwith then
            return "INGROUND"
        elseif inst.components.pickable and inst.components.pickable.canbepicked and inst.components.pickable.caninteractwith then
            return "GENERIC"
        else 
            return "PICKED"
        end
    end

    local function onregenfn(inst)
        if (data.open_time == "time" and GetClock():IsDay()) then
            open(inst)
        end		
    end

    local function close(inst)
        if inst.components.pickable and inst.components.pickable:CanBePicked() then
            if inst.growtask then
                inst.growtask:Cancel()
            end
            inst.growtask = inst:DoTaskInTime(3+math.random()*6, function() 
                    inst.AnimState:PlayAnimation("close_"..data.animname)
                    inst.AnimState:PushAnimation("inground")
                    inst:DoTaskInTime(.25, function() inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_down") end )
                    
                    inst.growtask = nil
                    if inst.components.pickable then
                        inst.components.pickable.caninteractwith = false
                    end
                end)    
        end
    end

    local function mushfn(Sim)
    	local inst = CreateEntity()
        inst.entity:AddSoundEmitter()
    	inst.entity:AddTransform()
    	
    	inst.entity:AddAnimState()
        inst.AnimState:SetBank("mushrooms")
        inst.AnimState:SetBuild("new_mushrooms")
        inst.AnimState:PlayAnimation(data.animname)
        inst.AnimState:SetRayTestOnBB(true);
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = GetStatus

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(data.pickloot, nil)
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.onregenfn = onregenfn
        inst.components.pickable:SetMakeEmptyFn(makeemptyfn)
        
        inst.rain = 0

		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(dig_up)
		inst.components.workable:SetWorkLeft(1)


    	MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        MakeNoGrowInWinter(inst)

        local openevent = "daytime"
        local closeevent = "nighttime"
        
        
        local isopen = false
		
		--purple		
        if data.open_time == "time" then
            openevent = "daytime"
            closeevent = "dusktime"    
            isopen = GetClock():IsDay() 
        end

        inst:ListenForEvent(openevent, function(global, data)
            open(inst)            
        end, GetWorld())

        inst:ListenForEvent(closeevent, function(global, data)
            close(inst)            
        end, GetWorld())

        inst:DoPeriodicTask(TUNING.SEG_TIME, checkregrow, TUNING.SEG_TIME + math.random()*TUNING.SEG_TIME)        

        if isopen then
            inst.AnimState:PlayAnimation(data.animname)
        else
            inst.AnimState:PlayAnimation("inground")
        end

        inst.components.pickable.caninteractwith = isopen

        return inst
    end


    local function capfn(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        MakeInventoryPhysics(inst)
        
        inst.AnimState:SetBank("mushrooms")
        inst.AnimState:SetBuild("new_mushrooms")
        inst.AnimState:PlayAnimation(data.animname.."_cap")
        
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        
        MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
        MakeSmallPropagator(inst)
        inst:AddComponent("inventoryitem")

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.sanityvalue = data.sanity
        inst.components.edible.foodtype = "VEGGIE"
        
        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("cookable")
        inst.components.cookable.product = data.pickloot.."_cooked"

        return inst
    end
    
    local function cookedfn(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        MakeInventoryPhysics(inst)
        
        inst.AnimState:SetBank("mushrooms")
        inst.AnimState:SetBuild("new_mushrooms")
        inst.AnimState:PlayAnimation(data.animname.."_cap_cooked")
        
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
        MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
        MakeSmallPropagator(inst)
        inst:AddComponent("inventoryitem")

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.cookedhealth
        inst.components.edible.hungervalue = data.cookedhunger
        inst.components.edible.sanityvalue = data.cookedsanity
        inst.components.edible.foodtype = "VEGGIE"
        
        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        return inst
    end    

    return Prefab( "forest/objects/"..data.name, mushfn, mushassets, prefabs),
           Prefab( "common/inventory/"..data.pickloot, capfn, capassets),
           Prefab( "common/inventory/"..data.pickloot.."_cooked", cookedfn, cookedassets)
end

--Pseudocode, does not work.
local function replaceSanityHunger(swapsanityhunger)
	local oldsanity = GetPlayer().components.sanity.current
	local oldhunger = GetPlayer().components.hunger.current
	
	local newsanity = oldhunger
	local newhunger = oldsanity
	
	local swapsanityhunger = 0
	swapsanityhunger = newhunger - oldhunger
end

--Pseudocode, does not work.
local function replaceHungerSanity(swaphungersanity)
	local oldsanity = GetPlayer().components.sanity.current
	local oldhunger = GetPlayer().components.hunger.current
	
	local newsanity = oldhunger
	local newhunger = oldsanity
	
	local swaphungersanity = 0
	swaphungersanity = newhunger - oldhunger
end

--health.currenthealth

local data = { 
	{name = "yellow_mushroom", animname="red", pickloot="yellow_cap", open_time = "time",	
	sanity = 0, health = -TUNING.HEALING_MED, hunger = 0,																							
	cookedsanity = -TUNING.SANITY_SMALL, cookedhealth = TUNING.HEALING_TINY, cookedhunger = 0}, 
																								
    {name = "orange_mushroom", animname="green", pickloot="orange_cap", open_time = "time",	
	sanity = -TUNING.SANITY_HUGE, health= 0, hunger = TUNING.CALORIES_SMALL,
	cookedsanity = TUNING.SANITY_MED, cookedhealth = -TUNING.HEALING_TINY, cookedhunger = 0},
																										
    {name = "purple_mushroom", animname="blue", pickloot="purple_cap", open_time = "time",	
	sanity = 0, health= TUNING.HEALING_MED, hunger = TUNING.CALORIES_SMALL, 
	cookedsanity = TUNING.SANITY_SMALL, cookedhealth = -TUNING.HEALING_SMALL, cookedhunger = 0}
	}
	
local prefabs = {}

for k,v in pairs(data) do
    local shroom, cap, cooked = MakeMushroom(v)
    table.insert(prefabs, shroom)
    table.insert(prefabs, cap)
    table.insert(prefabs, cooked)
end

return unpack(prefabs) 
