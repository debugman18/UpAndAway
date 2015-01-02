BindGlobal()

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

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("evergreen_lumpy.png")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    
    return inst
end

return Prefab("common/lionblob", fn, assets) 
