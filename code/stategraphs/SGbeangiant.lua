BindGlobal()

require("stategraphs/commonstates")

local CFG = TheMod:GetConfig()

local actionhandlers = 
{
    ActionHandler(ACTIONS.HAMMER, "attack"),
    ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40

local function Footstep(inst)
    inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/walk")
    if AllPlayers then
        for i, v in ipairs(AllPlayers) do
            v:ShakeCamera(CAMERASHAKE.VERTICAL, .5, .03, 2, inst, SHAKE_DIST)
        end
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
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "pod_loop"

            if inst:HasTag("pod") then
                animname = "pod_loop"
            else
                animname = "idle_loop"
            end
            
            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation(animname, true)
            else
                inst.AnimState:PlayAnimation(animname, true)
            end
        end,
    },

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
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/idle") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/idle") end),
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
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/idle") end),
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/idle") end),
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
        TimeEvent(1*FRAMES, Footstep),
    },
    walktimeline = 
    { 
        TimeEvent(1*FRAMES, Footstep),
        TimeEvent(1*FRAMES, Footstep),
    },
    endtimeline=
    {
        TimeEvent(1*FRAMES, Footstep),
    },
})

CommonStates.AddCombatStates(states,
{
    hittimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/hurt") end),
    },
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/idle") end),
        TimeEvent(35*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/attack")
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
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/beanclops/death") end),
        TimeEvent(50*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")  
            local player = ThePlayer
            local distToPlayer = inst:GetPosition():Dist(player:GetPosition())
            local power = Lerp(3, 1, distToPlayer/180)

            --player.components.playercontroller:ShakeCamera(CAMERASHAKE.FULL, .5, .05, 2, inst, SHAKE_DIST)             
        end),
    },
})


return StateGraph("beangiant", states, events, "idle", actionhandlers)

