BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
}

local events=
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states=
{
     State{
        
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle_loop", true)
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,
        
        timeline = 
        {
            TimeEvent(21*FRAMES, function(inst) end ),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State
    {
        name = "death",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
        end,
    },

    State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst)  
            inst.AnimState:PlayAnimation("hurt")          
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
   
}

CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
    },
    walktimeline = {
            TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
            TimeEvent(7*FRAMES, function(inst) 
                --inst.SoundEmitter:PlaySound("dontstarve/creatures/knight"..inst.kind.."/bounce")
                inst.components.locomotor:WalkForward()
            end ),
            TimeEvent(20*FRAMES, function(inst)
                --inst.SoundEmitter:PlaySound("dontstarve/creatures/knight"..inst.kind.."/land")
                inst.Physics:Stop()
            end ),
    },
}, nil,true)

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(15*FRAMES, function(inst)  end),
        TimeEvent(17*FRAMES, function(inst) inst.components.combat:DoAttack() end),
    },
    hittimeline = 
    {
        TimeEvent(0*FRAMES, function(inst)  end),
    },
    deathtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst)  end),
    },
})

CommonStates.AddSimpleRunStates(states, getidleanim)
    
return StateGraph("octocopter", states, events, "idle")
