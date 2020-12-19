BindGlobal()

local assets =
{
    --Asset("ANIM", "anim/kiki_basic.zip"),
    --Asset("ANIM", "anim/kiki_build.zip"),
    --Asset("ANIM", "anim/kiki_nightmare_skin.zip"),
    --Asset("SOUND", "sound/monkey.fsb"),
}

local prefabs =
{

}

local loot = 
{

}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("kiki")
    inst.AnimState:SetBuild("kiki_basic")
    
    inst.AnimState:PlayAnimation("idle_loop", true)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

    return inst
end

return Prefab ("common/creatures/sky_lemur", fn, assets, prefabs) 
