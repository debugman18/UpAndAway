BindGlobal()


local Logic = wickerrequire "paradigms.logic"
local game = wickerrequire "game"
local Game = game
local Effects = game.effects


--[[
-- To reduce the likelihood of bugs and to reduce code clutter, I've made loot prefabs get
-- automatically inserted here, so there's no need to specify them upfront.
--
-- I kept those I consider of "general relevance", besides loot. Feel free to readd (or erase) some
-- if you consider it more appropriate.
--]]
local prefabs = 
{
    --Mod prefabs.
    "golden_egg",
    "magic_beans",
}

local assets =
{
    Asset("ANIM", "anim/beanstalk.zip"),
    --Asset("ANIM", "anim/beanstalk_chopped.zip" ),	
    Asset("SOUND", "sound/tentacle.fsb"),
}

-- Loot specification. The field 'n' specifies how many, the field 'p'
-- the probability. 'n' defaults to 1, and so does 'p'.
local loot = {
    {"beanstalk_chunk"},
    {"beanstalk_chunk", p = 0.75},
    {"beanstalk_chunk", p = 0.5, n = 8},

    {"skeleton", p = 0.6},
    {"skeleton", p = 0.2},

    {"goldnugget", p = 0.7},
    {"goldnugget", p = 0.5},

    {"marble", p = 0.8, n = 2},

    {"cloud_turf", p = 0.5, n = 3},

    {"magic_beans", p = 0.21},
    {"magic_beans", p = 0.18},
}


--[[
-- Ensures all the loot prefabs will be preloaded.
--
-- The test for duplicacy is not quite efficient (it's quadratic), but
-- since this will only run once per "game instance" (once on menu, once on
-- the actual game, once on each world generation) it doesn't really matter.
--]]
for _, l in ipairs(loot) do
    local name = l[1]
    assert( type(name) == "string" )
    
    if not Logic.ThereExists(Logic.IsEqualTo(name), ipairs(prefabs)) then
        table.insert(prefabs, name)
    end
end


-- Returns a function which adds the loot to an entity.
-- It didn't need to be coded as a "function which returns a function", this
-- is just for code encapsulation (and to get the same efficiency as writing
-- the preprocessing code directly in the main file).
local function NewLootAdder()
    -- Ugly name.
    -- Lists the prefabs which always drop, with multiplicity.
    local alwaysloot = {}
    
    -- Lists tables, whose first entry is a prefab name and the second one
    -- is the probability for it to drop.
    local notalwaysloot = {}

    for _, l in ipairs(loot) do
        local prefab = l[1]
        assert( type(prefab) == "string" )

        for i = 1, (l.n or 1) do
            if (l.p or 1) == 1 then
                table.insert(alwaysloot, prefab)
            else
                assert( type(l.p) == "number" )
                table.insert(notalwaysloot, {prefab, l.p})
            end
        end
    end

    return function(inst)
        local dropper = inst.components.lootdropper
        if not dropper then
            inst:AddComponent("lootdropper")
            dropper = inst.components.lootdropper
        end

        -- Non-probabilistic loot needs to be added first.
        dropper:SetLoot( alwaysloot )

        for _, t in ipairs(notalwaysloot) do
            assert( #t == 2 )
            dropper:AddChanceLoot( unpack(t) )
        end
    end
end

local AddLoot = NewLootAdder()


local function onsave(inst, data)
    -- Lets save a bit of disk space: use nil instead of false.
    data.chopped = inst.chopped or nil
end		   

local function onload(inst, data)
    inst.chopped = data and data.chopped

    if inst.chopped then
        chopped(inst)
    end
end  

--This changes the screen some if the player is far.
local function onfar(inst)
    --TheCamera:SetDistance(100)
end

--This changes the screen some if the player is near.
local function onnear(inst)
    --TheCamera:SetDistance(100)
end

local function chopbeanstalk(inst, chopper, chops)
    if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
        inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")		  
    else
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")		  
    end
end

chopped = function(inst)
    inst.chopped = true	

    inst:RemoveComponent("workable")

    -- Removing this component was causing a crash sometimes by a race condition.
    -- (the crash was caused by the game attempting to get the "verb" for the activation)
    --
    -- The issue is with non-instant buffered actions that only run later.
    --inst:RemoveComponent("activatable")
    
    inst.components.activatable.inactive = true
    inst:DoTaskInTime(2, function(inst)
            inst:RemoveComponent("activatable")
    end)

    -- This destroys the cloud level savedata, if any.
    inst:RemoveComponent("climbable")

    inst.AnimState:PlayAnimation("idle_hole","loop")
end

local function chopdownbeanstalk(inst, chopper)
    inst.chopped = true

    Effects.DropLootFromTheSky(inst, 4)

    inst:DoTaskInTime(.4, function(inst) 
        local sz = 10
        for _, player in ipairs(Game.FindAllPlayerInRange(inst, 64)) do
            Effects.ShakeCamera(player, inst, "FULL", 0.25, 0.03, sz, 6)
        end
    end)

    inst.AnimState:PlayAnimation("retract", false)

    game.ListenForEventOnce(inst, "animover", chopped)
end

local function fn(Sim)
    --[[
    -- Engine-level components.
    --]]
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local physics = inst.entity:AddPhysics()
    local anim = inst.entity:AddAnimState()	
    local sound = inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()

    --[[
    -- Why was this here? exitcavelight should be spawned (and set to the player's/beanstalk's position)
    -- when he exits the foreign land, just to prevent the grue from insta-killing him in case
    -- it's night. It's not really a part of entity creation.
    --
    -- I renamed it "exitlight" to avoid confusion with inst.Light (which the beanstalk currently does
    -- not have, but anyway).
    --]]
    --[[
    local exitlight = SpawnPrefab("exitcavelight")	
    exitlight.Transform:SetPosition(inst.Transform:GetWorldPosition())
    ]]--
    

    --[[
    -- Engine-level components configuration (and related tags).
    --]]
    
    trans:SetScale(1.5, 1, 1.5)

    inst:AddTag("blocker")
    physics:SetMass(0) -- 0 mass means infinite mass, actually (i.e., static object).
    --physics:SetCylinder(0.6, 2)
    physics:SetCylinder(2, 24)
    physics:SetCollisionGroup(COLLISION.OBSTACLES)
    physics:SetFriction(10000)
    physics:CollidesWith(COLLISION.WORLD)
    physics:CollidesWith(COLLISION.ITEMS)
    physics:CollidesWith(COLLISION.CHARACTERS)

    anim:SetBank("tentaclepillar")
    anim:SetBuild("beanstalk")
    anim:PushAnimation("idle", true)	

    inst.MiniMapEntity:SetIcon( "beanstalk.tex" )

    sound:PlaySound("dontstarve/tentacle/tentapiller_idle_LP","loop")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddTag("beanstalk_climbable")

    
    --[[
    -- Lua-level components.
    --]]
    
    inst:AddComponent("climbable")
    inst.components.climbable:SetDirection("UP")
    
    ---------------------  

	--[[
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 30)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	]]--

    ---------------------  
    
    --inst:AddComponent("workable")
    --inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    --inst.components.workable:SetOnWorkCallback(chopbeanstalk)
    --inst.components.workable:SetOnFinishCallback(chopdownbeanstalk)

    ---------------------  
    
    inst:AddComponent("inspectable")
    
    ---------------------
    
    inst:AddComponent("lootdropper")
    AddLoot(inst)

    ---------------------
    
    inst.chopped = false
    inst.OnSave = onsave
    inst.OnLoad = onload
    return inst
end

return Prefab( "common/monsters/beanstalk", fn, assets, prefabs )

