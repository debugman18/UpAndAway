BindGlobal()

local Lambda = wickerrequire "paradigms.functional"
local Configurable = wickerrequire "adjectives.configurable"


local cfg = Configurable "BEVERAGE"


local function add_beverage_animstate(inst, data)
    local anim = inst.entity:AddAnimState()
    if data.bank then
        anim:SetBank(data.bank)
        if data.build then
            anim:SetBuild(data.build)
            if data.anim then
                if type(data.anim) == "table" then
                    anim:PlayAnimation( unpack(data.anim) )
                else
                    anim:PlayAnimation( data.anim )
                end
            end
        end
    end
    return anim
end

local function MakeBeverage(name, data)
    local assets = data.assets
    local prefabs = JoinArrays(data.prefabs or {}, {cfg:GetConfig("SPOILED_PREFAB")})

    local beverage_pretty_name = STRINGS.NAMES[name:upper()]

    local function basic_fn()
        local inst = CreateEntity()

        --[[
        -- Engine-level components.
        --]]

        inst.entity:AddTransform()
        add_beverage_animstate(inst, data)
        MakeInventoryPhysics(inst)

        -----------------------------------------------------------------------
        SetupNetwork(inst)
        -----------------------------------------------------------------------
        
        --[[
        -- Components.
        --]]

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        do
            local inventoryitem = inst.components.inventoryitem
            if data.inventory_atlas then
                inventoryitem.atlasname = data.inventory_atlas
            end
        end

        inst:AddComponent("perishable")
        do
            local perishable = inst.components.perishable

            perishable:SetPerishTime( data.perish_time or TUNING.PERISH_FAST )
            perishable.onperishreplacement = data.spoiled_prefab or cfg:GetConfig("SPOILED_PREFAB") or "spoiled_food"
            perishable:StartPerishing()
        end

        inst:AddComponent("edible")
        do
            local edible = inst.components.edible

            edible.healthvalue = data.health or 0
            edible.hungervalue = data.hunger or 0
            edible.sanityvalue = data.sanity or 0

            if data.foodtype then
                edible.foodtype = data.foodtype
            end

            if data.oneatenfn then
                inst.components.edible:SetOnEatenFn(data.oneatenfn)
            end
        end

        if data.temperature then
            inst:AddComponent("temperature")
            do
                local temperature = inst.components.temperature

                -- Freezing point.
                temperature.mintemp = 0
                -- Boiling point.
                temperature.maxtemp = 100

                temperature.inherentinsulation = cfg:GetConfig("INHERENT_INSULATION") or 0

                local temp = math.max(temperature.mintemp, math.min(temperature.maxtemp, data.temperature))
                temperature.current = temp
            end

            inst:AddComponent("ua_temperature")

            inst:AddComponent("heatededible")
            do
                local heatededible = inst.components.heatededible

                heatededible:SetHeatCapacity(data.heat_capacity or 0.15)
            end

            --This turns tea into iced tea when kept in an icebox.
            inst.icedthreshold = 5
            inst.warmthreshold = 15

            inst:ListenForEvent("temperaturedelta", function(inst) 
                local temperature = inst.components.temperature.current
                if beverage_pretty_name then
                    if temperature <= inst.icedthreshold then
                        inst.components.named:SetName("Iced "..beverage_pretty_name)
                    elseif temperature >= inst.warmthreshold then
                        inst.components.named:SetName(beverage_pretty_name)
                    end
                end
            end)
        end

        inst:AddComponent("named")

        return inst
    end

    local fn
    if data.postinit then
        local postinit = data.postinit
        fn = function()
            local inst = basic_fn()
            postinit(inst)
            return inst
        end
    else
        fn = basic_fn
    end

    return Prefab( "common/inventory/"..name, fn, assets, prefabs )
end

return MakeBeverage
