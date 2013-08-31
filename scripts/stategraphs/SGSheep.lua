require("stategraphs/commonstates")

local actionhandlers = 
{
}


local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),

    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() then inst.sg:GoToState("attack", data.target) end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),    
    EventHandler("loseloyalty", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("shake") end end),    
    
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()
            if inst.hairGrowthPending then
                inst.sg:GoToState("hair_growth")
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
                
                inst.sg:SetTimeout(2 + 2*math.random())
            end
        end,
        
        ontimeout=function(inst)
            local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
            if not inst:HasTag("baby") and herd and herd.components.mood and herd.components.mood:IsInMood() then
                if math.random() < .5 then
                    inst.sg:GoToState("matingcall")
                else
                    inst.sg:GoToState("tailswish")
                end
            else
                local rand = math.random()
                if rand < .3 then
                    inst.sg:GoToState("graze")
                elseif rand < .6 then
                    inst.sg:GoToState("bellow")
                else
                    inst.sg:GoToState("shake")
                end
            end
        end,
    },
    
    State{
        name = "shake",
        tags = {"canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shake")
        end,
       
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "bellow",
        tags = {"canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("bellow")
            inst.SoundEmitter:PlaySound(inst.sounds.grunt)
        end,
       
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "matingcall",
        tags = {},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("mating_taunt1")
            inst.SoundEmitter:PlaySound(inst.sounds.yell)
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "tailswish",
        tags = {},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("mating_taunt2")
        end,
        
        timeline=
        {
            TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swish) end),
            TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swish) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name="graze",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("graze_loop", true)
            inst.sg:SetTimeout(5+math.random()*5)
        end,
        
        ontimeout= function(inst)
            inst.sg:GoToState("idle")
        end,

    },
    
    State{
        name = "alert",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.SoundEmitter:PlaySound(inst.sounds.curious)
            inst.AnimState:PlayAnimation("alert_pre")
            inst.AnimState:PushAnimation("alert_idle", true)
        end,
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)    
			inst.sg.statemem.target = target
            inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,
        
        
        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.yell)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },

    
    State{
        name = "hair_growth",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth_pre")
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_vocal")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("hair_growth_pop") end),
        },
    },
    
    State{
        name = "hair_growth_pop",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hair_growth") 
                inst.SoundEmitter:PlaySound("dontstarve/beefalo/hairgrow_pop")
                if inst:HasTag("baby") and inst.components.growable then
                    inst.AnimState:SetBuild("beefalo_baby_build")
                    inst.components.growable:SetStage(inst.components.growable:GetNextStage() )
                elseif inst.components.beard then
                    local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
                    if herd and herd.components.mood and herd.components.mood:IsInMood() then
                        inst.AnimState:SetBuild("beefalo_heat_build") 
                    else
                        inst.AnimState:SetBuild("beefalo_build") 
                    end
                    inst.components.beard.bits = 3
                end
                inst.hairGrowthPending = false
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "shaved",
        tags = {"busy", "sleeping"},
        
        onenter = function(inst)
            inst.AnimState:SetBuild("beefalo_shaved_build")
            inst.AnimState:PlayAnimation("shave")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                    inst.sg:GoToState("sleeping")
                else
                    inst.sg:GoToState("wake")
                end
            end),
        },
    },
}

CommonStates.AddWalkStates(
    states,
    {
        walktimeline = 
        { 
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
            TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
        }
    })
    
CommonStates.AddRunStates(
    states,
    {
        runtimeline = 
        { 
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk) end),
        }
    })

CommonStates.AddSimpleState(states,"hit", "hit")
CommonStates.AddFrozenStates(states)

CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
    
return StateGraph("sheep", states, events, "idle", actionhandlers)