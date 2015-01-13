BindGlobal()

require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnAttack(),
    CommonHandlers.OnDeath(),
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then           
            inst.sg:GoToState("idle") 
        end 
    end),
    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() then
            if inst.components.combat.target and inst:IsNear(inst.components.combat.target, 2) then
                inst.sg:GoToState("attack")
            end
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
            inst.AnimState:PushAnimation("idle")       
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
            inst.AnimState:PushAnimation("idle")
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
            inst.AnimState:PushAnimation("idle")
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
            inst.AnimState:PushAnimation("idle")       
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
                inst.components.combat:StartAttack()
                inst.AnimState:PushAnimation("attack")  
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
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State
    {
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("die")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition())) 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeplant/eye_retract")  
            inst.AnimState:PushAnimation("death")
        end,        
    },
}

return StateGraph("skytrap", states, events, "idle")