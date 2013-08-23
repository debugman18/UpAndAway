local mushassets=
{
	Asset("ANIM", "anim/new_mushrooms.zip"),
}

local cookedassets = 
{
	Asset("ANIM", "anim/new_mushrooms.zip"),
}

local function MakeSkyflower(data)

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

    local function onpickedfn(inst)
        inst.AnimState:PlayAnimation("picked")
        inst:Remove()
    end
    
    local function makeemptyfn(inst)
        inst.AnimState:PlayAnimation("picked")
		inst:Remove()
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

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(data.pickloot, nil)
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable:SetMakeEmptyFn(makeemptyfn)
        
        inst.rain = 0

		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(dig_up)
		inst.components.workable:SetWorkLeft(1)

    	MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
		
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

local data = { 
	{name = "yellow_skyflower", animname="red", pickloot="yellow_cap", open_time = "time",	
	sanity = 0, health = -TUNING.HEALING_MED, hunger = 0,																							
	cookedsanity = -TUNING.SANITY_SMALL, cookedhealth = TUNING.HEALING_TINY, cookedhunger = 0}, 
																								
    {name = "orange_skyflower", animname="green", pickloot="orange_cap", open_time = "time",	
	sanity = -TUNING.SANITY_HUGE, health= 0, hunger = TUNING.CALORIES_SMALL,
	cookedsanity = TUNING.SANITY_MED, cookedhealth = -TUNING.HEALING_TINY, cookedhunger = 0},
																										
    {name = "purple_skyflower", animname="blue", pickloot="purple_cap", open_time = "time",	
	sanity = 0, health= TUNING.HEALING_MED, hunger = TUNING.CALORIES_SMALL, 
	cookedsanity = TUNING.SANITY_SMALL, cookedhealth = -TUNING.HEALING_SMALL, cookedhunger = 0}
	}
	
local prefabs = {}

for k,v in pairs(data) do
    local skyflower, cap, cooked = MakeSkyflower(v)
    table.insert(prefabs, skyflower)
    table.insert(prefabs, cap)
    table.insert(prefabs, cooked)
end

return unpack(prefabs) 
