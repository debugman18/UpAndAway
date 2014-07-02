BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.PICK, "pick"),
}


local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("transform") then inst.sg:GoToState("attack") end end),
}

local function Gobble(inst)
    --if not inst.SoundEmitter:PlayingSound("gobble") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/gobble")--, "gobble")
    --end
end

local states=
{
      
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/death")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            RemovePhysicsColliders(inst)            
        end,
        
    },

    
    State{
        name = "appear",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/scream")
            --inst.Physics:Stop()	
            inst.AnimState:PlayAnimation("appear")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
        },
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/attack")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            inst.components.combat:StartAttack()
            --inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,
        
        timeline =
        {
            TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
        },
        
        events =
        {
            EventHandler("animover", function(inst) 

                if GetWorld().Map then
                
                    local max_tries = 4
                    for k = 1,max_tries do
                        local pos = Vector3(GetPlayer().Transform:GetWorldPosition())
                        local offset = math.random(1,4)
                        pos.x = pos.x + (math.random(2*offset)-offset)          
                        pos.z = pos.z + (math.random(2*offset)-offset)
                        if GetWorld().Map:GetTileAtPoint(pos:Get()) ~= GROUND.IMPASSABLE then
                            inst.Transform:SetPosition(pos:Get() )
                            break
                        end
                    end
                end

                inst.sg:GoToState("appear")

            end),
        },
    },
    
    --State{
        --name = "pick",
        --
        --tags = {"busy"},
        --
        --onenter = function(inst)
            --inst.AnimState:PlayAnimation("take")
            --inst.Physics:Stop()            
        --end,
        --
        --timeline=
        --{
            --TimeEvent(9*FRAMES, function(inst)
                --inst:PerformBufferedAction()
                --inst.sg:RemoveStateTag("busy")
                --inst.sg:AddStateTag("idle")
            --end),
        --},
        --
        --events=
        --{
            --EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        --},        
    --},
    State{
        name = "hit",
        tags = {"hit"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/hurt")
            --inst.AnimState:PlayAnimation("hit")
            --inst.Physics:Stop()
        end,
        
        events=
        {
            EventHandler("animover", function(inst)

                if GetWorld().Map then
                
                    local max_tries = 4
                    for k = 1,max_tries do
                        local pos = Vector3(GetPlayer().Transform:GetWorldPosition())
                        local offset = math.random(6,10)
                        pos.x = pos.x + (math.random(2*offset)-offset)          
                        pos.z = pos.z + (math.random(2*offset)-offset)
                        if GetWorld().Map:GetTileAtPoint(pos:Get()) ~= GROUND.IMPASSABLE then
                            inst.Transform:SetPosition(pos:Get())

                            local allypos = Vector3(GetPlayer().Transform:GetWorldPosition())
                            if GetWorld().Map:GetTileAtPoint(pos:Get()) ~= GROUND.IMPASSABLE then
                                if math.random(0,100) >= 50 then
                                    local ally = SpawnPrefab("duckraptor")
                                    local duckraptorsize = inst.duckraptorsize
                                    local newsize = (.8 * duckraptorsize)

                                    ally.Transform:SetScale(newsize, newsize, newsize)
                                    ally.duckraptorsize = newsize

                                    local allyoffset = math.random(10,20)
                                    allypos.x = allypos.x + (math.random(2*offset)-offset)          
                                    allypos.z = allypos.z + (math.random(2*offset)-offset)
                                    ally.Transform:SetPosition(allypos:Get())
                                    if ally.duckraptorsize <= .5 then
                                        ally.sg:GoToState("death")
                                    end
                                    inst:Remove()
                                end
                            end

                            break
                        end
                    end
                end

                if inst then
                    inst.sg:GoToState("idle")
                end
                
            end),
            
        },      
    },    
}

CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
		TimeEvent(0*FRAMES, Gobble),
    },
    
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
    starttimeline = 
    {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end ),
    },
    
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})

CommonStates.AddSleepStates(states,
{
    starttimeline = 
    {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/sleep") end ),
    },
    
	sleeptimeline = {
        TimeEvent(40*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/sleep") end),
	},
})

CommonStates.AddSimpleActionState(states, "gohome", "hit", 4*FRAMES, {"busy"})
CommonStates.AddFrozenStates(states)
CommonStates.AddIdle(states)

    
return StateGraph("duckraptor", states, events, "idle", actionhandlers)

