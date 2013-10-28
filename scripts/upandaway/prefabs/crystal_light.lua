--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/rock_stalagmite.zip"),
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

    anim:SetBank("maxwell_torch")
    anim:SetBuild("maxwell_torch")
    anim:PlayAnimation("idle",false)
  
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .1)    

    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("maxwelllight_flame", Vector3(0,0,0), "fire_marker")
    inst.components.burnable:SetOnIgniteFn(light)

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "Light Crystal"    

    inst.lightorder = {5,6,7,8,7}
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(17, 27 )
    inst.components.playerprox:SetOnPlayerNear(function() if not inst.components.burnable:IsBurning() then inst.components.burnable:Ignite() end end)
    inst.components.playerprox:SetOnPlayerFar(extinguish)

	return inst
end

return Prefab ("common/inventory/crystal_light", fn, assets, prefabs) 
