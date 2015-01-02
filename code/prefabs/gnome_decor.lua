BindGlobal()

local assets = 
{
    Asset("ANIM", "anim/gnome_decor.zip"),
}

local function makefn(bankname, buildname, animname)
    local function fn(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst:AddTag("DECOR")
        
        anim:SetBank(bankname)
        anim:SetBuild(buildname)
        anim:PlayAnimation(animname)

        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------
        
        return inst
    end

    return fn
end    

return {
    Prefab ("forest/objects/gnomedecor/gnome_farmrock", makefn("gnome_decor", "gnome_decor", "1"), assets),
    Prefab ("forest/objects/gnomedecor/gnome_farmrocktall", makefn("gnome_decor", "gnome_decor", "2"), assets),
    Prefab ("forest/objects/gnomedecor/gnome_farmrockflat", makefn("gnome_decor", "gnome_decor", "8"), assets),
    Prefab ("forest/objects/gnomedecor/gnome_fencepost", makefn("gnome_decor", "gnome_decor", "5"), assets),
    Prefab ("forest/objects/gnomedecor/gnome_fencepostright", makefn("gnome_decor", "gnome_decor", "9"), assets),
}

