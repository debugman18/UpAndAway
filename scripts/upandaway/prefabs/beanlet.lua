--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/Beanlet.zip"),  -- same name as the .scml
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    anim:SetBank("Beanlet") -- name of the animation root
    anim:SetBuild("Beanlet")  -- name of the file
    anim:PlayAnimation("idle", true) -- name of the animation
	
    return inst
end

return Prefab("common/beanlet", fn, assets) 