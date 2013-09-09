local assets=
{
    -- always have to declare what assets you’re loading and using
    --Asset("ANIM", "anim/testcritter.zip"),  -- same name as the .scml
	--Asset("ANIM", "anim/antlion.zip"),  -- same name as the .scml
	Asset("ANIM", "anim/wigglebox.zip"),  -- same name as the .scml
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    
	--[[
    anim:SetBank("testcritter") -- name of the animation root
    anim:SetBuild("testcritter")  -- name of the file
    anim:PlayAnimation("bounce", true) -- name of the animation
    --]]

    anim:SetBank("wigglebox") -- name of the animation root
    anim:SetBuild("wigglebox")  -- name of the file
    anim:PlayAnimation("wiggle", true) -- name of the animation
	
    return inst
end

return Prefab("common/anim_test", fn, assets) 