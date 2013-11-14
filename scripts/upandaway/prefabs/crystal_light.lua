--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
    "maxwelllight_flame",
}

local function changelevels(inst, order)
    for i=1, #order do
        inst.components.burnable:SetFXLevel(order[i])
        Sleep(0.05)
    end
end

local function light(inst)    
    inst.task = inst:StartThread(function() changelevels(inst, inst.lightorder) end)    
end

local function extinguish(inst)
    if inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("maxwelltorch.png")

    anim:SetBank("crystal")
    anim:SetBuild("crystal")
    anim:PlayAnimation("crystal_light")
  
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .1)    

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "Light Crystal" 

    --[[
    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("maxwelllight_flame", Vector3(0,0,0), "fire_marker")
    inst.components.burnable:SetOnIgniteFn(light)   

    inst.lightorder = {5,6,7,8,7}
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(17, 27 )
    inst.components.playerprox:SetOnPlayerNear(function() if not inst.components.burnable:IsBurning() then inst.components.burnable:Ignite() end end)
    inst.components.playerprox:SetOnPlayerFar(extinguish)
    --]]

	return inst
end

return Prefab ("common/inventory/crystal_light", fn, assets, prefabs) 
