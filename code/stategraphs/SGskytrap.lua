BindGlobal()

require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnAttack(),
    CommonHandlers.OnDeath(),
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then           
            inst.sg:GoToState("hit") 
        end 
    end),
}

local states=
{
    State
    {
        name = "spawn",
        tags = {"busy"},

        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeplant/eye_emerge")        
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

    },

    State
    {        
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst)
            inst.Physics:Stop()
        end,


    },

    State
    {
        
        name = "alert",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if inst.components.combat.target then    
                inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,

        events = 
        {
            EventHandler("losttarget", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State
    {
        name = "hit",
        tags = {"busy", "hit"},
        
        onenter = function(inst)
            inst.Physics:Stop()         
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
        
    },  

    State
    { 
        name = "attack",
        tags = {"attack", "canrotate"},
        onenter = function(inst)
            if inst.components.combat.target then    
                inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
            end
        end,
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack()
            inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeplant/eye_bite")
            end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
                if inst.components.combat.target and 
                    distsq(inst.components.combat.target:GetPosition(),inst:GetPosition()) <= 
                    inst.components.combat:CalcAttackRangeSq(inst.components.combat.target) then

                    inst.sg:GoToState("attack")
                else
                    inst.sg:GoToState("alert")
                end
            end),
        },
    },

    State
    {
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            RemovePhysicsColliders(inst) 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeplant/eye_retract")      

        end,        
    },
}

return StateGraph("skytrap", states, events, "idle")