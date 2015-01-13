BindGlobal()

require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "migrate"),
    ActionHandler(ACTIONS.WALKTO, "migrate"),
}

local events=
{
    CommonHandlers.OnStep(),

    EventHandler("locomote", function(inst)
                                local is_attacking = inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("runningattack")
                                local is_busy = inst.sg:HasStateTag("busy")
                                local is_idling = inst.sg:HasStateTag("idle")
                                local is_moving = inst.sg:HasStateTag("moving")
                                local is_running = inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack")

                                if is_attacking or is_busy then return end

                                local should_move = inst.components.locomotor:WantsToMoveForward()
                                local should_run = inst.components.locomotor:WantsToRun()
                                
                                if is_moving and not should_move then
                                    if is_running then
                                        inst.sg:GoToState("run_stop")
                                    else
                                        inst.sg:GoToState("walk_stop")
                                    end
                                elseif (not is_moving and should_move) or (is_moving and should_move and is_running ~= should_run) then
                                    if should_run then
                                        inst.sg:GoToState("run_start")
                                    else
                                        inst.sg:GoToState("walk_start")
                                    end
                                end
                            end),

    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),

    EventHandler("doattack", function(inst,target)
                                local nstate = "attack"
                                local targ = target.target
                                if target then
                                    inst.sg.statemem.target = target.target
                                    targ = target.target
                                    eprint(inst,"dattack targ",target.target)
                                end
                                if inst.sg:HasStateTag("running") then
                                    nstate = "runningattack"
                                end
                                if inst.components.health and not inst.components.health:IsDead()
                                   and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
                                    inst.sg:GoToState(nstate,targ)
                                end
                            end),

    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),    
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, pushanim)
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(2 + 2*math.random())
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },
    
    State{
        name = "alert",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("")
        end,
    },

    State{ name = "run_start",
            tags = {"moving", "running", "canrotate"},
            
            onenter = function(inst)
                inst.components.locomotor:RunForward()
                if GetPseudoSeasonManager():GetSnowPercent() < 0.1 then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/walk_moss_large")
                else
                    inst.SoundEmitter:PlaySound("dontstarve/movement/walk_moss_large")
                end
                inst.AnimState:PlayAnimation("run_start")
                inst.sg.mem.foosteps = 0
            end,

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),
            },
            
            onexit = function(inst)
                if GetPseudoSeasonManager():IsWinter() then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/walk_moss_large")
                else
                    inst.SoundEmitter:PlaySound("dontstarve/movement/walk_moss_large")
                end
            end,

            timeline=
            {
            },
        },

    State{ name = "run",
            tags = {"moving", "running", "canrotate"},
            
            onenter = function(inst)
                inst.components.locomotor:RunForward()
                inst.AnimState:PlayAnimation("run_loop")
            end,
            
            timeline=
            {
            },
            
            events=
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("run") end ),
            },
        },
    
    State{ name = "run_stop",
            tags = {"canrotate", "idle"},
            
            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("run_stop")
            end,
            
            events=
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("walk_start") end ),
            },
        }, 

    State{ name = "walk_start",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst)
                inst.components.locomotor:WalkForward()
                inst.AnimState:PlayAnimation("run_start")
            end,

            events=
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),
            },
        },
    
    State{ name = "walk",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst)
                inst.components.locomotor:WalkForward()
                inst.AnimState:PlayAnimation("run_loop", true)
                inst.SoundEmitter:PlaySound("dontstarve/movement/walk_water")
            end,
    
            events=
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),
            },

            timeline = {
                TimeEvent(5*FRAMES, function(inst)
                                        if GetPseudoSeasonManager():IsWinter() then
                                            inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small")
                                        else
                                            inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small")
                                        end
                                    end),
                TimeEvent(21*FRAMES, function(inst)
                                        if GetPseudoSeasonManager():IsWinter() then
                                            inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small")
                                        else
                                            inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small")
                                        end
                                    end),
            },
        },

    State{ name = "walk_stop",
            tags = {"canrotate", "idle"},
            
            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("run_stop", true)
            end,

            events=
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
            },
        }, 

    State{ name = "migrate",
            onenter = function(inst, playanim)
                inst:PerformBufferedAction()
                inst.components.locomotor:WalkForward()
                inst.SoundEmitter:PlaySound("dontstarve/movement/walk_water")
            end,
            timeline = {
                TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small") end),
                TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/movement/run_mud_small") end),
            },
            events=
            {
                EventHandler("animover", function (inst)
                    inst.sg:GoToState("idle")
                end),
            }
        }, 
    
    State{  name = "attack",
            tags = {"attack"},
            
            onenter = function(inst,target)
                eprint(inst,"StateAttack onenter:",target,inst.sg.statemem.target)
                if target then
                    inst.sg.statemem.target = target
                end
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/bite")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/eat")
                inst.components.combat:StartAttack()
                inst.components.locomotor:StopMoving()
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
            end,
            
            timeline =
            {
                TimeEvent(15*FRAMES, function(inst)
                                        eprint(inst,"DoAttack()",inst.sg.statemem.target)
                                        inst.components.combat:DoAttack(inst.sg.statemem.target)
                                     end),
            },
            
            events =
            {
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("walk_start") end),
            },
        },  
 
    State{  name = "runningattack",
            tags = {"runningattack"},
            
            onenter = function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/bite")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/eat")
                inst.components.combat:StartAttack()
            end,
            
            timeline =
            {
                TimeEvent(1*FRAMES, function(inst)
                                        inst.components.combat:DoAttack()
                                     end),
            },
            
            events =
            {
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("walk_start") end),
            },
        },

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rabbit/scream")
            inst.components.locomotor:StopMoving()
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
 }

CommonStates.AddSimpleState(states,"hit", "hit")

CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        TimeEvent(46*FRAMES, function(inst) end)
    },
})
CommonStates.AddFrozenStates(states)
    
return StateGraph("beanlet", states, events, "idle", actionhandlers)

