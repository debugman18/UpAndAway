--FIXME: not MP compatible (shadows); network setup not added.
BindGlobal()

local assets =
{
    Asset( "ANIM", "anim/invisible_hound.zip" ),
}

local common_prefabs =
{
    "balloon",
}


local Lambda = wickerrequire "paradigms.functional"
local Game = wickerrequire "utils.game"

local cfg = wickerrequire("adjectives.configurable")("BALLOON_HOUND")


-- list of hounds to use as a base.
local base_hounds = {"hound", "icehound", "firehound"}


local function new_dummy_entity()
    local inst = CreateEntity()
    inst.persists = false
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    return inst
end

local make_ground_shadow = (function()
    local UPDATE_PERIOD = FRAMES

    local function get_height(inst)
        local x, y = inst.Transform:GetWorldPosition()
        return y
    end

    local function update_ground_shadow(shadowinst)
        shadowinst.Transform:SetPosition(0, -get_height(shadowinst.parent), 0)
    end

    local function stop_updating(shadowinst)
        if shadowinst.updatetask then
            update_ground_shadow(shadowinst)
            shadowinst.updatetask:Cancel()
            shadowinst.updatetask = nil
        end
    end

    local function start_updating(shadowinst)
        if not shadowinst.updatetask and not shadowinst:IsInLimbo() and not shadowinst.parent:IsAsleep() then
            shadowinst.updatetask = shadowinst:DoPeriodicTask(UPDATE_PERIOD, update_ground_shadow)
        end
    end

    local function from_parent(f)
        return function(inst)
            return f(inst.shadowinst)
        end
    end
    
    return function(inst)
        local shadowinst = new_dummy_entity()
        inst.shadowinst = shadowinst

        shadowinst.entity:AddTransform()--:SetPosition(0, -HEIGHT, 0)
        shadowinst.entity:AddAnimState()
        shadowinst.entity:AddDynamicShadow():SetSize(2.5, 1.5)
        shadowinst.AnimState:SetBank("hound")
        shadowinst.AnimState:SetBuild("invisible_hound")
        shadowinst.AnimState:PlayAnimation("idle")

        shadowinst:ListenForEvent("exitlimbo", start_updating)
        shadowinst:ListenForEvent("enterlimbo", stop_updating)
        shadowinst:ListenForEvent("entitywake", from_parent(start_updating), inst)
        shadowinst:ListenForEvent("entersleep", from_parent(stop_updating), inst)

        inst:AddChild(shadowinst)

        shadowinst.start_updating = start_updating
        shadowinst.stop_updating = stop_updating
    end
end)()

local function configure_balloon(balloon, data)
    data = data or balloon.data or {}
    balloon.data = data

    balloon.AnimState:OverrideSymbol("swap_balloon", "balloon_shapes", "balloon_"..tostring(data.id or 1))

    if not data.colour then
        local colours = cfg:GetConfig("BALLOON_COLOURS")
        data.colour = colours[math.random(#colours)]
    end
    balloon.AnimState:SetMultColour(data.colour.x, data.colour.y, data.colour.z, 1)
end

local function make_balloon(inst)
    local balloon = new_dummy_entity()
    balloon.data = data
    inst.ballooninst = balloon

    balloon.entity:AddTransform()
    balloon.entity:AddAnimState()
    balloon.entity:AddSoundEmitter()

    local scale = cfg:GetConfig("BALLOON_SCALE")
    balloon.Transform:SetScale(scale, scale, scale)

    local follower = balloon.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "hound_body", 20*scale, -260 + 50*scale, -0.1 )

    balloon.AnimState:SetBank("balloon")
    balloon.AnimState:SetBuild("balloon")
    balloon.AnimState:PlayAnimation("idle", true)
    balloon.AnimState:SetTime(math.random()*2)
    balloon.AnimState:SetRayTestOnBB(true)
    
    balloon:ListenForEvent("onremove", function() balloon:Remove() end, inst)

    configure_balloon(balloon)
end


local function stop_falling(inst)
    if inst.fallthread then
        TheMod:DebugSay("Killing fall thread of [", inst, "].")
        CancelThread(inst.fallthread)
        inst.fallthread = nil
    end
    if inst.floatawaythread then
        TheMod:DebugSay("Killing float away thread of [", inst, "].")
        CancelThread(inst.floatawaythread)
        inst.floatawaythread = nil
    end

    inst.Physics:SetDamping(5)

    inst.shadowinst:stop_updating()
end

local function do_floataway(inst)
    stop_falling(inst)

    inst:StopBrain()
    inst:SetBrain(nil)

    local speed = cfg:GetConfig("FLOAT_AWAY_SPEED")

    inst.Physics:SetMotorVel(0, speed, 0)

    inst.floatawaythread = inst:StartThread(function()
        if not inst:IsValid() then return end

        TheMod:DebugSay("Floating [", inst, "] away with speed ", speed, ".")

        inst.shadowinst:start_updating()

        local period = 1/15

        local x, y = inst.Transform:GetWorldPosition()

        while inst:IsValid() and not inst:IsAsleep() and y < 30 do
            Sleep(period)
            inst.Physics:SetMotorVel(0, speed, 0)
            x, y = inst.Transform:GetWorldPosition()
        end

        if not inst:IsValid() then return end

        inst.floatawaythread = nil

        TheMod:DebugSay("Removed [", inst, "].")
        inst:Remove()
    end)

    return inst.floatawaythread
end

local function leave_world_in(inst, delay)
    if inst.leavetask then
        inst.leavetask:Cancel()
        inst.leavetask = nil
    end

    if inst.grounded then return end

    inst.leaveat = GetTime() + delay

    inst.leavetask = inst:DoTaskInTime(delay, function(inst)
        if not inst.grounded then
            do_floataway(inst)
        end
    end)
end

local function do_fall(inst, damping, final_height, epsilon, callback)
    stop_falling(inst)

    inst.Physics:SetDamping(damping)
    inst.Physics:SetMotorVel(1, 0, 0)
    inst.Physics:SetMotorVel(0, 0, 0)

    inst.fallthread = inst:StartThread(function()
        if not inst:IsValid() then return end

        TheMod:DebugSay("Dropping [", inst, "] with damping ", damping, ".")

        inst.shadowinst:start_updating()

        local period = 1/15

        local x, y = inst.Transform:GetWorldPosition()

        while inst:IsValid() and not inst:IsAsleep() and y - final_height > epsilon do
            Sleep(period)
            x, y = inst.Transform:GetWorldPosition()
        end

        if not inst:IsValid() then return end

        inst.Physics:SetDamping(5)

        do
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.Physics:Teleport(x, final_height, z)
        end

        TheMod:DebugSay("Dropped [", inst, "].")

        if callback then
            callback(inst)
        end

        inst.fallthread = nil

        inst.shadowinst:stop_updating()
    end)

    return inst.fallthread
end

local function floating_retargetfn(inst)
    local combat = inst.components.combat

    local range = combat:GetAttackRange()

    -- How much beyond the attack range we look for a target (to account for large body sizes).
    -- If even a Deerclops has a radius of 0.5, this should be fine.
    local extra_range = 1

    return Game.FindSomeEntity(inst, range + extra_range, function(guy)
        local max_dist = range + (guy.Physics and guy.Physics:GetRadius() or 0)
        if inst:GetDistanceSqToInst(guy) <= max_dist*max_dist then
            return combat:CanTarget(guy)
        end
    end, nil, {"wall", "houndmound", "hound", "houndfriend"})
end

local function floating_keeptargetfn(inst, target)
    local combat = inst.components.combat
    return combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= combat:CalcAttackRangeSq(target)
end

local function fall_smoothly(inst, cb)
    do_fall(inst, cfg:GetConfig("FALL_DAMPING"), cfg:GetConfig("HEIGHT"), 0, cb)
end

local function set_floating(inst)
    inst.grounded = false
    inst:AddTag("flying")

    inst.DynamicShadow:Enable(false)
    inst.shadowinst:ReturnToScene()
    inst.ballooninst:ReturnToScene()

    inst.ballooninst.SoundEmitter:PlaySound("dontstarve/common/balloon_bounce")

    do
        local combat = inst.components.combat

        combat:SetRetargetFunction(1, floating_retargetfn)
        combat:SetKeepTargetFunction(floating_keeptargetfn)
    end

    inst:StopBrain()

    fall_smoothly(inst, function(inst)
        inst:SetBrain(require "brains/balloon_houndbrain")
        inst:RestartBrain()
    end)
end

local function set_grounded(inst)
    inst.grounded = true
    inst:RemoveTag("flying")

    inst.ballooninst:RemoveFromScene()

    inst:StopBrain()

    do
        local combat = inst.components.combat

        combat:SetRetargetFunction(3, inst.grounded_fns.retargetfn)
        combat:SetKeepTargetFunction(inst.grounded_fns.keeptargetfn)
    end

    do_fall(inst, 0.5, 0, 0.2, function(inst)
        inst.shadowinst:RemoveFromScene()
        inst.DynamicShadow:Enable(true)

        inst:SetBrain(require "brains/houndbrain")
        inst:RestartBrain()
    end)
end

local function pop_balloon(inst)
    if inst.grounded then return end

    inst.grounded = true

    local balloon = inst.ballooninst

    balloon.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
    balloon:DoTaskInTime(0, function(balloon)
        -- I don't know why this is necessary. The first sound simply doesn't
        -- play.
        balloon.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
    end)
    balloon.AnimState:PlayAnimation("pop")

    Game.ListenForEventOnce(balloon, "animover", function() set_grounded(inst) end)
end


local function OnSave(inst, data)
    if inst.grounded then
        data.grounded = true
    elseif inst.leaveat then
        data.leave_delay = inst.leaveat - GetTime()
    end
    data.balloondata = inst.ballooninst.data
end

local function OnLoad(inst, data)
    if data then
        if data.balloondata then
            configure_balloon(inst.ballooninst, data.balloondata)
        end
        if data.grounded then
            set_grounded(inst)
        elseif data.leave_delay then
            leave_world_in(inst, data.leave_delay)
        end
    end
end


local function MakePrefab(base_prefab)
    local prefabs = Lambda.CompactlyInjectInto({base_prefab}, ipairs(common_prefabs))

    local function fn(Sim)
        local inst = SpawnPrefab(base_prefab)
        inst.prefab, inst.name = nil, nil

        do
            local combat = inst.components.combat

            inst.grounded_fns = {
                retargetfn = combat.targetfn,
                keeptargetfn = combat.keeptargetfn,
            }
        end

        --------------------------------------
        
        make_ground_shadow(inst)
        make_balloon(inst)

        --------------------------------------
        
        inst:ListenForEvent("attacked", pop_balloon)
        inst:ListenForEvent("death", pop_balloon)

        --------------------------------------
        
        -- FIXME: for debugging purposes, remove later.
        function inst:SetHeight(h)
            local x, y, z = self.Transform:GetWorldPosition()
            self.Transform:SetPosition(x, h, z)

            if self.grounded then
                set_grounded(self)
            else
                set_floating(self)
            end
        end
        function inst:Pop()
            pop_balloon(self)
        end
        function inst:FloatAway()
            do_floataway(self)
        end

        --------------------------------------
    
        set_floating(inst)

        do
            local timeout_range = cfg:GetConfig("TIMEOUT")
            local timeout = timeout_range[1] + (timeout_range[2] - timeout_range[1])*math.random()
            leave_world_in(inst, timeout)
        end

        --------------------------------------
        
        inst.OnSave = OnSave
        inst.OnLoad = OnLoad

        return inst
    end

    return Prefab("monsters/balloon_"..base_prefab, fn, assets, prefabs)
end

return Lambda.CompactlyMap(MakePrefab, ipairs(base_hounds))
