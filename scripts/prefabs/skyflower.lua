local assets=
{
	Asset("ANIM", "anim/skyflowers.zip"),
	Asset("ANIM", "anim/datura.zip"),	
}

local prefabs =
{
    "skyflower_petals",
	"datura_petals",
	"cloud_cotton",
}    

local names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"}
local daturanames = {"f1","f2","f3","f4","f5","f6","f7","f8"}

local function onpickedfn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end
	if picker then
		local cotton = SpawnPrefab("cloud_cotton")
		cotton.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	inst:Remove()
end

local function onunchargefn(inst)
	inst.entity:AddTransform()	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("flowers")
    inst.animname = names[math.random(#names)]
    inst.AnimState:SetBuild("skyflowers")
    inst.AnimState:PlayAnimation(inst.animname)
    inst.AnimState:SetRayTestOnBB(true);
	
	inst:RemoveTag("flower_datura")
    inst:AddTag("flower")	
	
    inst.components.sanityaura.aura = TUNING.SANITYAURA_LARGE		
	
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("skyflower_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
	
	inst.charged = false
	
	return inst
end

local function onstaticfn(inst)
	inst.entity:AddTransform()	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("flowers_evil")
    inst.animname = daturanames[math.random(#daturanames)]
    inst.AnimState:SetBuild("datura")
    inst.AnimState:PlayAnimation(inst.animname)
    inst.AnimState:SetRayTestOnBB(true);
    
	inst:RemoveTag("flower")
    inst:AddTag("flower_datura")
    
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("datura_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
	
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE		
    
	inst.charged = true
	
    return inst
end

local function onsave(inst, data)
	data.charged = inst.charged
	data.anim = inst.animname	
end

local function onload(inst, data)
	if data and data.charged then
		inst.charged = data.charged
	end
	
	if inst.charged then
		onstaticfn(inst)
	else
		onunchargefn(inst)
	end
	
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end	
end

local function fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("flowers")
    inst.animname = names[math.random(#names)]
    inst.AnimState:SetBuild("skyflowers")
    inst.AnimState:PlayAnimation(inst.animname)
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddTag("flower")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
	
    inst:AddComponent("sanityaura")
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

	inst:ListenForEvent("upandaway_charge", function()
		print "Charged!"
		onstaticfn(inst)	
		return inst
	end, GetWorld())

	inst:ListenForEvent("upandaway_uncharge", function()
		print "Uncharged!"
		onunchargefn(inst)	
		return inst
	end, GetWorld())	

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    
    return inst
end

return Prefab("forest/objects/skyflower", fn, assets, prefabs)
