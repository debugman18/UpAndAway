BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.PICKUP, "pickup"),
}


local events =
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    EventHandler("giveuptarget", function(inst, data) inst.sg:GoToState("abandon") end),
    --[[
    EventHandler("newcombattarget", function(inst, data)
        if data.target and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("happy")
        end
    end),
    ]]--
    EventHandler("becomenice", function(inst, data)
        inst:AddTag("cuddly")
        inst.sg:GoToState("abandon")
    end),
    EventHandler("becomenaughty", function(inst, data)
        inst:RemoveTag("cuddly")
        inst.sg:GoToState("happy")
    end),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_scared", true)
            else
                inst.AnimState:PlayAnimation("were_idle_loop", true)
            end
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/idle")
            inst.sg:SetTimeout(math.random()*2+2)
        end,

        ontimeout= function(inst)
            inst.sg:GoToState("funnyidle")
        end,

    },

    State{
        name= "funnyidle",
        tags = {"idle"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_happy")

                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/taunt")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/pullout")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") 
            else
                inst.AnimState:PlayAnimation("idle_angry")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/taunt")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep")
            end
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/death")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/death_voice")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    
    State{
        name = "gohome",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pig_pickup")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
            end),
        },
    },  

    State{
        name = "happy",
        tags = {"busy", "naughty"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("howl")
            SpawnPrefab("gummybear_rainbow").Transform:SetPosition(inst:GetPosition():Get())
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/plant")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
        end,
        
        timeline = 
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/taunt") 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
                SpawnPrefab("gummybear_rainbow").Transform:SetPosition(inst:GetPosition():Get()) 
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "abandon",
        tags = {"busy"},
        
        onenter = function(inst, leader)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_angry")
            SpawnPrefab("gummybear_rainbow").Transform:SetPosition(inst:GetPosition():Get())
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/plant")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") 
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("were_atk_pre")
            inst.AnimState:PushAnimation("were_atk", false)
        end,
        
        timeline=
        {
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/taunt")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
             end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst)
                if not inst.components.combat.target and math.random() < 0.3 then
                    inst.sg:GoToState("funnyidle")
                else
                    inst.sg:GoToState("idle")
                end
            end ),
        },
    },
    
    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_scared")
            else
                inst.AnimState:PlayAnimation("were_run_pre")
                inst.components.locomotor:RunForward()
            end
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
    },
    
    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_happy")
            else
                inst.AnimState:PlayAnimation("were_run_loop")
            end
            inst.components.locomotor:RunForward()
        end,
        
        timeline = 
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/splat") end),
            TimeEvent(0*FRAMES, PlayFootstep ),
            TimeEvent(10*FRAMES, PlayFootstep ),
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/splat") end),
        },
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),        
        },
    },
        
    State{
        name = "run_stop",
        tags = {"canrotate"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_scared")
            else
                inst.AnimState:PlayAnimation("were_run_pst")
            end
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
    },
    
    State{
        name = "walk_start",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst) 
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("were_walk_pre")
            else
                inst.AnimState:PlayAnimation("were_walk_pre")
            end
            inst.components.locomotor:WalkForward()
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
        },
    },
        
    State{
        name = "walk",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst) 
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("were_walk_loop")
            else
                inst.AnimState:PlayAnimation("were_walk_loop")
            end
            inst.components.locomotor:WalkForward()
        end,

        timeline = 
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/walk") end),
            TimeEvent(0*FRAMES, PlayFootstep),
            TimeEvent(12*FRAMES, PlayFootstep),
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/walk") end),
        },
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
        },
    },
    
    State{
        name = "walk_stop",
        tags = {"canrotate"},
        
        onenter = function(inst) 
            if inst:HasTag("cuddly") then
                inst.AnimState:PlayAnimation("idle_happy")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/taunt")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/pullout")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack") 
            else
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("were_walk_pst")
            end
        end,
        
        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
    },
    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("eat")
        end,
        
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
                if not inst.components.combat.target or math.random() < 0.3 then
                    inst.sg:GoToState("howl")
                else
                    inst.sg:GoToState("idle")
                end
            end ),
        },        
    },
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/hurt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/hurt")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },    
}

CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/werepig/sleep") end ),
    },
})

CommonStates.AddFrozenStates(states)
CommonStates.AddSimpleActionState(states, "eat", "eat", 20*FRAMES, {"busy"})
    
return StateGraph("gummybear", states, events, "idle", actionhandlers)
