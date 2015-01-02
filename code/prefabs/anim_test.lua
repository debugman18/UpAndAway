-- Not networked.
BindGlobal()

local assets=
{
    -- always have to declare what assets you’re loading and using
    --Asset("ANIM", "anim/testcritter.zip"),  -- same name as the .scml
    --Asset("ANIM", "anim/antlion.zip"),  -- same name as the .scml
    Asset("ANIM", "anim/Beanlet.zip"),  -- same name as the .scml
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.persists = false

    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    
    --[[
    anim:SetBank("testcritter") -- name of the animation root
    anim:SetBuild("testcritter")  -- name of the file
    anim:PlayAnimation("bounce", true) -- name of the animation
    --]]

    anim:SetBank("Beanlet") -- name of the animation root
    anim:SetBuild("Beanlet")  -- name of the file
    anim:PlayAnimation("Dummy", true) -- name of the animation
    
    return inst
end

return Prefab("common/anim_test", fn, assets) 
