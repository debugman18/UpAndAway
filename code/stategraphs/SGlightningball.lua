BindGlobal()

require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnLocomote(false, true),
}

local states =
{
    State{
        
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle_loop", true)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
            end
        end,
        
        timeline = 
        {

        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates(states,
{
    starttimeline =
    {

    },

    walktimeline = 
    {
        TimeEvent(4*FRAMES, function(inst) PlayFootstep(inst) end),
        TimeEvent(5*FRAMES, function(inst) PlayFootstep(inst) end),
        TimeEvent(10*FRAMES, function(inst) 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/shotexplo")
            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
         end),
        TimeEvent(11*FRAMES, function(inst) PlayFootstep(inst) end),

    },

    endtimeline =
    {

    },
})

return StateGraph("lightningball", states, events, "idle")
