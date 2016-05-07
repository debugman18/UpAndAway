-- This only exists to trick morgue into listing static as a cause of death.

BindGlobal()

local assets=
{
    Asset("ANIM","anim/staticdamagefx.zip")
}

local function fn(Sim)

    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    
	inst.AnimState:SetBank("staticdamagefx")
    inst.AnimState:SetBuild("staticdamagefx")
    --inst.AnimState:PlayAnimation("idle",false) -- Done externally
	
	------------------------------------------------------------------------
	
	inst:AddTag("NOCLICK")
    -- Avoid stunlock.
    inst:AddTag("insect")

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    
	-- Remove self after playing animation
	inst:ListenForEvent("animover",inst.Remove)
	
    return inst

end

return Prefab("common/staticdummy", fn, assets) 
