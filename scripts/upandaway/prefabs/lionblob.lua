--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/lionblob.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    
    anim:SetBank("lionblob") -- name of the animation root
    anim:SetBuild("lionblob")  -- name of the file
    anim:PlayAnimation("nod", true) -- name of the animation
	
    return inst
end

return Prefab("common/lionblob", fn, assets) 