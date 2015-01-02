BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.HAMMER, "attack"),
    ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40

local function DeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    for i, v in ipairs(AllPlayers) do
        v:ShakeCamera(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST)
    end
end

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states=
{
    State{
        name = "gohome",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst:ClearBufferedAction()
            inst.components.knownlocations:RememberLocation("home", nil)
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },      
    
    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
                inst:ClearBufferedAction()
                inst.components.knownlocations:RememberLocation("home", nil)
            end
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates( states,
{
    starttimeline =
    {
        TimeEvent(1*FRAMES, DeerclopsFootstep),
    },
    walktimeline = 
    { 
        TimeEvent(1*FRAMES, DeerclopsFootstep),
        TimeEvent(1*FRAMES, DeerclopsFootstep),
    },
    endtimeline=
    {
        TimeEvent(1*FRAMES, DeerclopsFootstep),
    },
})

CommonStates.AddCombatStates(states,
{
    hittimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/hurt") end),
    },
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
        TimeEvent(35*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
            inst.components.combat:DoAttack(inst.sg.statemem.target)
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.HAMMER then
                inst.bufferedaction.target.components.workable:SetWorkLeft(1)
                inst:PerformBufferedAction()
            end
            for i, v in ipairs(AllPlayers) do
                v:ShakeCamera(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)
            end
        end),
        TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },
    deathtimeline=
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/death") end),
        TimeEvent(50*FRAMES, function(inst)
            if GetPseudoSeasonManager():GetSnowPercent() > 0.02 then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")
            else
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
            end    
            for i, v in ipairs(AllPlayers) do
                v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, 3, inst, SHAKE_DIST)
            end
        end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        --TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("beangiant", states, events, "idle", actionhandlers)

