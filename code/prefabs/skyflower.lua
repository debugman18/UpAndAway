BindGlobal()


local Configurable = wickerrequire 'adjectives.configurable'
local goodcfg = Configurable("SKYFLOWER")


local assets=
{
	Asset("ANIM", "anim/skyflowers.zip"),
	Asset("ANIM", "anim/datura.zip"),	
}

local prefabs =
{
    "skyflower_petals",
	"datura_petals",
}    

local anim_names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"}
local datura_anim_names = {"f1","f2","f3","f4","f5","f6","f7","f8"}

local function generate_random_anim_number()
	return math.random( math.max(#anim_names, #datura_anim_names) )
end

-- Get anim name by number.
local function get_anim_name(inst)
	return anim_names[1 + (inst.animnumber - 1) % #anim_names]
end

local function get_datura_anim_name(inst)
	return datura_anim_names[1 + (inst.animnumber - 1) % #datura_anim_names]
end

local function update_anim(inst)
	local sc = inst.components.staticchargeable

	if sc and sc:IsCharged() then
		inst.AnimState:PlayAnimation( get_datura_anim_name(inst) )
	else
		inst.AnimState:PlayAnimation( get_anim_name(inst) )
	end
end

local function GetStatus(inst)
	return inst.components.staticchargeable:IsCharged() and "DATURA" or "SKYFLOWER"
end

local function onpickedfn(inst, picker)
	if not inst:HasTag("flower_datura") and picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	elseif inst:HasTag("flower_datura") and picker and picker.components.sanity then
		picker.components.sanity:DoDelta(-TUNING.SANITY_TINY)		
	end

	inst:Remove()
end

local function onunchargefn(inst)
	update_anim(inst)
    inst.AnimState:SetBank("flowers")
    inst.AnimState:SetBuild("skyflowers")
	update_anim(inst)
	
	inst:RemoveTag("flower_datura")
	-- Do NOT remove the flower tag, ever.
    --inst:AddTag("flower")	
	
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("skyflower_petals", 40)
	inst.components.pickable.onpickedfn = onpickedfn	

	inst.components.sanityaura.aura = 0	
	
	return inst
end

local function onchargefn(inst)
	-- The dual update call is necessary to avoid log spam saying the previous anim does not exist.
	update_anim(inst)
    inst.AnimState:SetBank("datura")
    inst.AnimState:SetBuild("datura")
	update_anim(inst)
    
	-- Do NOT remove the flower tag, ever.
	--inst:RemoveTag("flower")
    inst:AddTag("flower_datura")
    
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("datura_petals", 40)
	inst.components.pickable.onpickedfn = onpickedfn
	
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE		
	
    return inst
end

local function onsave(inst, data)
	data.animnumber = inst.animnumber
end

local function onload(inst, data)
    if data and data.animnumber then
        inst.animnumber = data.animnumber
		update_anim(inst)
	end	
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("flowers")
    inst.AnimState:SetBuild("skyflowers")
    inst.AnimState:SetRayTestOnBB(true);

	inst.animnumber = generate_random_anim_number()
	update_anim(inst)

	inst:AddTag("flower")

	-----------------------------------------------------------------------
	SetupNetwork(inst)
	-----------------------------------------------------------------------
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	
    inst:AddComponent("pickable")
    inst.components.pickable.quickpick = true
	
    inst:AddComponent("sanityaura")
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetOnChargeFn(onchargefn)
	inst.components.staticchargeable:SetOnUnchargeFn(onunchargefn)
	inst.components.staticchargeable:SetOnChargeDelay( goodcfg:GetConfig "CHARGE_DELAY" )
	inst.components.staticchargeable:SetOnUnchargeDelay( goodcfg:GetConfig "UNCHARGE_DELAY" )

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 


	onunchargefn(inst)

    
    return inst
end

return Prefab("forest/objects/skyflower", fn, assets, prefabs)
