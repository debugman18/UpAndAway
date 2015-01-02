BindGlobal()

require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/package.zip"),

    Asset( "ATLAS", inventoryimage_atlas("package") ),
    Asset( "IMAGE", inventoryimage_texture("package") ),	
}

local function do_unpack(inst)
    if inst.components.packer:Unpack() then
        inst:Remove()
    end
end	

local function get_name(inst)
    local basename = inst.components.packer:GetName()
    if basename then
        return "Packaged "..basename
    else
        return "Unknown Package"
    end
end

local function fn(Sim, iteminside)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("package")
    inst.AnimState:SetBuild("package")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(3,3,3)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("packer")
    do
        local packer = inst.components.packer

        --[[
        -- General things which should never be packed are being given the
        -- unpackable tag in postinits.packaging.
        --
        -- Specific things which shouldn't be packed by white staff packages
        -- are being filtered out in the white staff prefab file.
        --]]
        --[[
        packer:SetCanPackFn(function(target, inst)
            -- stuff
        end)
        ]]--
    end

    inst:AddComponent("deployable")
    do
        local deployable = inst.components.deployable

        deployable.ondeploy = do_unpack
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("package")

    inst.displaynamefn = get_name

    return inst
end

return {
    Prefab("common/inventory/package", fn, assets),
    MakePlacer("common/inventory/package_placer", "package", "package", "idle", false, false, true, 3),
}
