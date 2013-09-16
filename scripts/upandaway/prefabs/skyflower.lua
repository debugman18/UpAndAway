--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


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
	"cloud_cotton",
}    

local names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"}
local daturanames = {"f1","f2","f3","f4","f5","f6","f7","f8"}

local function GetStatus(inst)
	return inst.components.staticchargeable:IsCharged() and "DATURA" or "SKYFLOWER"
end

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
    inst.AnimState:SetBank("flowers")
    inst.AnimState:SetBuild("skyflowers")
    inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)
	
	inst:RemoveTag("flower_datura")
    inst:AddTag("flower")	
	
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("skyflower_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn

    inst.components.sanityaura.aura = TUNING.SANITYAURA_LARGE		
	
	return inst
end

local function onchargefn(inst)
    inst.AnimState:SetBank("flowers_evil")
    inst.AnimState:SetBuild("datura")
    inst.animname = daturanames[math.random(#daturanames)]
    inst.AnimState:PlayAnimation(inst.animname)
    
	inst:RemoveTag("flower")
    inst:AddTag("flower_datura")
    
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("datura_petals", 10)
	inst.components.pickable.onpickedfn = onpickedfn
	
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE		
	
    return inst
end

local function onsave(inst, data)
	data.anim = inst.animname	
end

local function onload(inst, data)
	if not data then return end

    if data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end	
end

local function fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetRayTestOnBB(true);
    
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
