BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.PICK, "pick"),
}


local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("transform") then inst.sg:GoToState("attack") end end),
}

local function Gobble(inst)
    --if not inst.SoundEmitter:PlayingSound("gobble") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/gobble")--, "gobble")
    --end
end

local function Blink(inst, offset_min, offset_max)
    local target = inst.components.combat and inst.components.combat.target
    if GetWorld().Map and target then
        local max_tries = 4
        for k = 1, max_tries do
            local pos = target:GetPosition()
            local offset = math.random(offset_min, offset_max)
            pos.x = pos.x + (math.random(2*offset)-offset)          
            pos.z = pos.z + (math.random(2*offset)-offset)
            if Pred.IsUnblockedPoint(pos) then
                inst.Transform:SetPosition(pos:Get())
                return true
            end
        end
    end
    return false
end

local states=
{
      
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/death")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            RemovePhysicsColliders(inst)            
        end,
        
    },

    
    State{
        name = "appear",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/scream")
            --inst.Physics:Stop()	
            inst.AnimState:PlayAnimation("appear")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.components.combat:StartAttack()
            --inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline =
        {
            TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events =
        {
            EventHandler("animover", function(inst) 
                Blink(inst, 1, 4)
                inst.sg:GoToState("appear")
            end),
        },
    },
    
    --State{
        --name = "pick",
        --
        --tags = {"busy"},
        --
        --onenter = function(inst)
            --inst.AnimState:PlayAnimation("take")
            --inst.Physics:Stop()            
        --end,
        --
        --timeline=
        --{
            --TimeEvent(9*FRAMES, function(inst)
                --inst:PerformBufferedAction()
                --inst.sg:RemoveStateTag("busy")
                --inst.sg:AddStateTag("idle")
            --end),
        --},
        --
        --events=
        --{
            --EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        --},        
    --},
    State{
        name = "hit",
        tags = {"hit"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/hurt")
            --inst.AnimState:PlayAnimation("hit")
            --inst.Physics:Stop()
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if math.random() > 0.5 then
                    local ally = SpawnPrefab("duckraptor")
                    if ally then
                        local newsize = 0.8*ally.duckraptorsize
                        ally.duckraptorsize = newsize
                        ally.Transform:SetScale(newsize, newsize, newsize)

                        Game.Move(ally, inst)
                        inst:Remove()
                        Blink(ally, 10, 20)

                        if ally.duckraptorsize <= 0.5 then
                            ally.sg:GoToState("death")
                        end
                    end
                else
                    Blink(inst, 6, 10)
                end

                if inst:IsValid() then
                    inst.sg:GoToState("idle")
                end
            end),
            
        },      
    },    
}

CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
        TimeEvent(0*FRAMES, Gobble),
    },
    
    walktimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(12*FRAMES, PlayFootstep ),
    },
})
CommonStates.AddRunStates(states,
{
    starttimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end ),
    },
    
    runtimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end ),
        TimeEvent(10*FRAMES, PlayFootstep ),
    },
})

CommonStates.AddSleepStates(states,
{
    starttimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/sleep") end ),
    },
    
    sleeptimeline = {
        TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/sleep") end),
    },
})

CommonStates.AddSimpleActionState(states, "gohome", "hit", 4*FRAMES, {"busy"})
CommonStates.AddFrozenStates(states)
CommonStates.AddIdle(states)

    
return StateGraph("duckraptor", states, events, "idle", actionhandlers)

