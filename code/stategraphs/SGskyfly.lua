BindGlobal()

require("stategraphs/commonstates")

local WALK_SPEED = 3

local events=
{
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg.statemem.wantstomove = true
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end), 
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),
}


local states=
{

    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("swarm_pre", true)
        end,
    },    
    
    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,

    },    
    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            --inst.Physics:Stop()
            inst.AnimState:PlayAnimation("swarm_loop")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if inst.sg.statemem.wantstomove then
                    inst.sg:GoToState("moving")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
}
CommonStates.AddFrozenStates(states)
    
return StateGraph("skyfly", states, events, "idle")
