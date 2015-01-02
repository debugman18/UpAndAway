BindGlobal()


local Configurable = wickerrequire "adjectives.configurable"

local cfg = Configurable("TEA_LEAF")


local assets = {
    Asset("ANIM", "anim/tea_leaves.zip"),
}

local prefabs = {
    cfg:GetConfig("SPOILED_PREFAB"),
}

local function make_leaf(name, data)
    local function fn()
        local inst = CreateEntity()


        inst:AddTag("tea_leaf")
        inst:AddTag("show_spoilage")


        inst.entity:AddTransform()
        
        local anim = inst.entity:AddAnimState()
        anim:SetBank(data.bank)
        anim:SetBuild(data.build)
        anim:PlayAnimation(data.anim, true)
        inst.Transform:SetScale(3,3,3)


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------


        
        inst:AddComponent("inspectable")

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = 5

        inst:AddComponent("inventoryitem")
        do
            local inventoryitem = inst.components.inventoryitem

            inventoryitem.atlasname = inventoryimage_atlas(name)
        end

        inst:AddComponent("stackable")
        do
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        end

        inst:AddComponent("perishable")
        do
            local perishable = inst.components.perishable

            perishable:SetPerishTime(data.perishtime)
            perishable.onperishreplacement = cfg:GetConfig("SPOILED_PREFAB")
            perishable:StartPerishing()
        end

        inst:AddComponent("dryable")
        do
            local dryable = inst.components.dryable
            dryable:SetProduct("blacktea_leaves")
            dryable:SetDryTime(TUNING.DRY_FAST)
        end

        return inst
    end

    return Prefab( "common/inventory/"..name, fn, assets, prefabs )
end

return {
    make_leaf("tea_leaves", {
        bank = "tea_leaves", build = "tea_leaves", anim = "idle_green",
        perishtime = 15*TUNING.TOTAL_DAY_TIME,
    }),
    make_leaf("blacktea_leaves", {
        bank = "tea_leaves", build = "tea_leaves", anim = "idle_black",
        perishtime = 45*TUNING.TOTAL_DAY_TIME,
    }),
}
