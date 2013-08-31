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

local names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"}
local daturanames = {"f1","f2","f3","f4","f5","f6","f7","f8"}

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function onpickedfn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end	
	
	inst:Remove()
end

local function fncommon(Sim)
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
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("skyflower_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)


    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    
    return inst
end

local function fndatura(Sim)
	local inst = fncommon(Sim)
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("flowers_evil")
    inst.animname = daturanames[math.random(#daturanames)]
    inst.AnimState:SetBuild("datura")
    inst.AnimState:PlayAnimation(inst.animname)
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddTag("flower")
    
    --inst:AddComponent("inspectable")
    
    --inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("datura_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    
	--MakeSmallBurnable(inst)
    --MakeSmallPropagator(inst)

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    
    return inst
end

return Prefab("forest/objects/skyflower", fncommon, assets, prefabs),
	   Prefab("forest/objects/datura", fndatura, assets, prefabs)