local Lambda = wickerrequire "paradigms.functional"
local Tree = wickerrequire "utils.table.tree"

local DataValidator = wickerrequire "gadgets.datavalidator"

---

local total_day_time = TUNING.TOTAL_DAY_TIME

---

--[[
local function dig_up(inst, chopper)
    if inst.components.pickable then
        inst.components.lootdropper:SpawnLootPrefab("pineapple")
    end
    inst.components.lootdropper:SpawnLootPrefab("dug_pineapple_bush")	
    inst:Remove()
end
]]--

---

local mandatory_data = {
    "name",
    "build",
    "bank",
    "product",
    anims = {
        "empty",
        "normal",
        "growing",
        "ripe",
        "harvested",
        "rotten",
    },
    -- In days.
    times = {
        "tonormal",
        "togrowing",
        "toripe",
    },
}

--[[
local optional_data = {
    anims = {
        "picking",
    },
},
]]--

local default_data = {
    anims = {
        idle = "idle",
    },
    sounds = {
        growth = "dontstarve/forest/treeGrow",
        picking = "dontstarve/wilson/pickup_reeds",
    },
}

local function get_data(inst)
    return inst.wild_data
end

local function set_data(inst, data)
    inst.wild_data = data
end

---

--This is for when it's picked ripe.
local function onpickedfn(inst)
    local data = get_data(inst)
    inst.SoundEmitter:PlaySound(data.sounds.picking) 
    if data.anims.picking then
        inst.AnimState:PlayAnimation(data.anims.picking)
    end
    inst.components.pickable:MakeEmpty()
    inst.components.growable:SetStage(5) -- ?
end

--This is for when it's picked rotten.
local function onharvestfn(inst)
    local data = get_data(inst)
    inst.SoundEmitter:PlaySound(data.sounds.picking)
    inst.components.pickable:MakeBarren()
    inst.AnimState:PlayAnimation(data.anims.harvested)
end	

---

local growfns = {}

growfns.empty = function(inst)
    local data = get_data(inst)
    inst.AnimState:PlayAnimation(data.anims.empty)
    inst.SoundEmitter:PlaySound(data.sounds.growth)
    if inst.components.pickable then
        inst.components.pickable:MakeEmpty()    
    end        
end

growfns.normal = function(inst)
    local data = get_data(inst)
    inst.AnimState:PlayAnimation(data.anims.normal)
    inst.SoundEmitter:PlaySound(data.sounds.growth)  
    if inst.components.pickable then
        inst.components.pickable:MakeEmpty()    
    end                  
end

growfns.growing = function(inst)
    local data = get_data(inst)
    inst.AnimState:PlayAnimation(data.anims.growing)
    inst.SoundEmitter:PlaySound(data.sounds.growth) 
    if inst.components.pickable then
        inst.components.pickable:MakeEmpty()    
    end          
end


growfns.ripe = function(inst)
    local data = get_data(inst)
    inst.AnimState:PlayAnimation(data.anims.ripe)
    inst.SoundEmitter:PlaySound(data.sounds.growth)
    if inst.components.pickable then
        inst.components.pickable:Regen()
    end
end

growfns.harvested = function(inst)
    local data = get_data(inst)
    if inst.components.pickable and inst.components.pickable:IsBarren() then
        inst.AnimState:PlayAnimation(data.anims.rotten)
        inst.components.pickable.product = "wetgoop"
        inst.components.pickable.onpickedfn = onharvestfn 
       else 
           inst.AnimState:PlayAnimation(data.anims.harvested)
       end              
end

---

local function MakeGrowthStages(data)
    local stage_names = {"empty", "normal", "growing", "ripe", "harvested"}
    local num_stages = #stage_names

    -- # of stages unreachable by regular growing.
    local num_unreachable_stages = 1 -- "harvested"

    local num_reachable_stages = num_stages - num_unreachable_stages

    local times = data.times


    local growth_stages = {}
    for i, stage in ipairs(stage_names) do
        local stage_data = {}

        stage_data.name = stage
        stage_data.fn, stage_data.growfn = growfns[stage]
        if i < num_reachable_stages and i < num_stages then
             local timefn_in_days = times["to"..stage_names[i + 1]]
             stage_data.time = function()
                return total_day_time*timefn_in_days()
             end
        end

        table.insert(growth_stages, stage_data)
    end
    return growth_stages
end

---

local ValidateData = DataValidator(mandatory_data, "data")

local function IncludeDefaultData(sub_default_data, sub_data)
    for k, v in pairs(sub_default_data) do
        if type(v) == "table" then
            if type(sub_data[k]) ~= "table" then
                sub_data[k] = {}
            end
            IncludeDefaultData(v, sub_data[k])
        else
            if sub_data[k] == nil then
                sub_data[k] = v
            end
        end
    end
end

-- error_level is relative to the parent function.
local function ProcessData(data, error_level)
    ValidateData(data, error_level + 1)

    local ret = {}

    Tree.InjectInto(ret, data)
    IncludeDefaultData(default_data, data)

    return ret
end

---

local function MakeWildCrop(data)
    data = ProcessData(data, 2)
    assert(type(data.name) == "string", "Prefab name expected as first argument.")

    local name = data.name
    local growth_stages = MakeGrowthStages(data)

    data.prefabs = data.prefabs or {}
    if not Lambda.Find(Lambda.IsEqualTo(data.product), ipairs(data.prefabs)) then
        table.insert(data.prefabs, data.product)
    end

    local function fn()
        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        _G.MakeObstaclePhysics(inst, .2)

        inst.AnimState:SetBank(data.bank)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation(data.anims.idle)

        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------
    
        set_data(inst, data)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")

        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(math.random(1, 3))
        inst.components.growable.loopstages = false
        inst.components.growable:StartGrowing()

        inst:AddComponent("pickable")
        inst.components.pickable.product = data.product
        inst.components.pickable.onpickedfn = onpickedfn 
        inst.components.pickable:MakeEmpty()

        --[[
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up)
        inst.components.workable:SetWorkLeft(1)
        ]]--

        _G.MakeMediumBurnable(inst)
        _G.MakeSmallPropagator(inst)    

        return inst
    end

    --[[
    local function dug_fn(inst)
        inst = CreateEntity()

        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------

        return inst
    end
    ]]--

    return Prefab("common/"..name, fn, data.assets, data.prefabs)
        --Prefab ("common/inventory/dug_pineapple_bush", dug_fn, assets, prefabs) 
end

return MakeWildCrop
