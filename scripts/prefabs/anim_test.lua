local assets=
{
    -- always have to declare what assets you’re loading and using
    Asset("ANIM", "anim/anim_test.zip"),  -- same name as the .scml
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    
    anim:SetBank("anim_test_bank") -- name of the animation root
    anim:SetBuild("anim_test")  -- name of the file
    anim:PlayAnimation("anim0", true) -- name of the animation
    
    return inst
end

return Prefab( "common/anim_test", fn, assets) 