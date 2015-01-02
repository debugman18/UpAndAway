BindGlobal()


local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local table = wickerrequire "utils.table"

local cfg = wickerrequire("adjectives.debuggable")()
cfg:SetConfigurationKey "MUSHROOM_HAT"


local UPDATE_PERIOD = 1/3
local NAGGING_PERIOD = cfg:GetConfig "NAGGING_PERIOD"


local assets = {
    Asset("ANIM", "anim/mushroom_hat.zip"),
}

local prefabs = {}


local build_markov_chain, new_state_updater
do
    local MarkovChain = wickerrequire "math.probability.markovchain"

    local function buildStateHandler(state)
        local effects = assert( state.effects )
        return function(inst, dt, overtime)
            for k, v in pairs(effects) do
                local cmp = inst.components[k]
                if cmp then
                    cmp:DoDelta(v*dt, overtime)
                end
            end
        end
    end

    local state_map = cfg:GetConfig("STATES")
    local state_handlers = Lambda.Map(buildStateHandler, pairs(state_map))
    local state_list = Lambda.CompactlyInjectInto({}, table.keys(state_handlers))
    assert( #state_list > 0 )


    local function average_time_to_probability(dt)
        assert( Pred.IsPositiveNumber(dt) )
        return 1/math.ceil(dt/UPDATE_PERIOD)
    end

    -- Probability of switching to any other state, per state.
    -- Each takes the entity as a parameters.
    local nonpersistency_p = Lambda.Map(function(state)
        local persistency = state.persistency
        assert( Pred.IsCallable(persistency) )

        -- Factor to account for the number of states.
        local normalizer = 1/(#state_list - 1)
        return function(inst)
            local perishable = inst.components.perishable
            if not perishable then return 0 end
            local f = perishable:GetPercent()
            return average_time_to_probability(persistency(f))*normalizer
        end
    end, pairs(state_map))
    
    build_markov_chain = function(inst)
        local chain = MarkovChain()

        for _, state in ipairs(state_list) do
            assert( Pred.IsString(state) )
            chain:AddState(state)
        end

        chain:SetInitialState( state_list[math.random(#state_list)] )

        for i, state in ipairs(state_list) do
            for j, other_state in ipairs(state_list) do
                if i ~= j then
                    chain:SetTransitionProbability(state, other_state, Lambda.BindFirst(nonpersistency_p[state], inst))
                end
            end
        end

        inst.chain = chain
        return chain
    end

    local NAGGING_COUNTDOWN = math.ceil(NAGGING_PERIOD/UPDATE_PERIOD)
    new_state_updater = function()
        local countdown = 0

        return function(inst)
            local owner = inst:IsValid() and inst.components.inventoryitem and inst.components.inventoryitem.owner
            if not (owner and owner:IsValid()) then return end

            local s = inst.chain:GetState()

            local h = state_handlers[s]
            if h then
                local overtime = countdown > 0
                if not overtime then
                    cfg:DebugSay("[", inst, "]", " updating state ", s, " over [", owner, "]")
                end
                h(owner, UPDATE_PERIOD, overtime)
            end
            inst.chain:Step()

            if inst.chain:GetState() ~= s then
                countdown = 0
            elseif countdown <= 0 then
                countdown = NAGGING_COUNTDOWN
            else
                countdown = countdown - 1
            end
        end
    end
end


local function cancel_update_task(inst)
    if inst.update_task then
        inst.update_task:Cancel()
        inst.update_task = nil
    end
end

local function start_update_task(inst)
    if inst.update_task then return end

    inst.update_task = inst:DoPeriodicTask(UPDATE_PERIOD, new_state_updater(), 0.2*math.random())
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "mushroom_hat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAIR")
    end
        
    start_update_task(inst)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
    end

    cancel_update_task(inst)
end

local function onperish(inst)
    inst:Remove()
end

local function OnSave(inst, data)
    if data then
        data.markov_state = inst.chain:GetState()
    end
end

local function OnLoad(inst, data)
    local s = data and data.markov_state
    if s and inst.chain:IsState(s) then
        inst.chain:GoTo(s)
    end
end

local function fn()
    local inst = CreateEntity()

    --[[
    -- Formalities.
    --]]

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("featherhat")
    inst.AnimState:SetBuild("mushroom_hat")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    --[[
    -- Meaningful stuff.
    --]]

    inst:AddComponent("inventoryitem")
    do
        local inventoryitem = inst.components.inventoryitem

        inventoryitem.atlasname = inventoryimage_atlas("mushroom_hat")
    end

    inst:AddComponent("equippable")
    do
        local equippable = inst.components.equippable

        equippable.equipslot = EQUIPSLOTS.HEAD
        equippable:SetOnEquip(onequip)
        equippable:SetOnUnequip(onunequip)
    end

    inst:AddComponent("perishable")
    do
        local perishable = inst.components.perishable
        inst:AddTag("show_spoilage")

        perishable:SetPerishTime( cfg:GetConfig "DURABILITY" )
        perishable:SetOnPerishFn(onperish)
        perishable.onperishreplacement = "spoiled_food"
    end


    build_markov_chain(inst)


    inst.OnSave = OnSave
    inst.OnLoad = OnLoad


    return inst
end

return Prefab("common/inventory/mushroom_hat", fn, assets, prefabs) 
