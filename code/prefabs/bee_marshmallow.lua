BindGlobal()

local beecommon = require "brains/beecommon"

local workersounds = 
{
    takeoff = "dontstarve/bee/bee_takeoff",
    attack = "dontstarve/bee/bee_attack",
    buzz = "dontstarve/bee/bee_fly_LP",
    hit = "dontstarve/bee/bee_hurt",
    death = "dontstarve/bee/bee_death",
}

local killersounds = 
{
    takeoff = "dontstarve/bee/killerbee_takeoff",
    attack = "dontstarve/bee/killerbee_attack",
    buzz = "dontstarve/bee/killerbee_fly_LP",
    hit = "dontstarve/bee/killerbee_hurt",
    death = "dontstarve/bee/killerbee_death",
}

local assets=
{
	Asset("ANIM", "anim/bee_marshmallow.zip"),
	Asset("ANIM", "anim/bee_angry_build.zip"),
    Asset("ANIM", "anim/bee_build.zip"),
    Asset("ANIM", "anim/bee.zip"),
	Asset("SOUND", "sound/bee.fsb"),

    Asset( "ATLAS", "images/inventoryimages/bee_marshmallow.xml" ),
    Asset( "IMAGE", "images/inventoryimages/bee_marshmallow.tex" ), 
}
    
local prefabs =
{
	"marshmallow",
}

local workerbrain = require("brains/beebrain")
local killerbrain = require("brains/killerbeebrain")


local function KillerRetarget(inst)
    return FindEntity(inst, 8, function(guy)
        return (guy:HasTag("character") or guy:HasTag("animal") or guy:HasTag("monster") )
            and not guy:HasTag("insect")
            and inst.components.combat:CanTarget(guy)
    end)
end

local function onunchargefn(inst)
  
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1, 1, 1)
    inst:RemoveTag("scarytoprey")
    inst.components.health:SetMaxHealth(TUNING.BEE_HEALTH)
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat:SetAttackPeriod(TUNING.BEE_ATTACK_PERIOD)
	if not inst.components.pollinator then
		inst:AddComponent("pollinator")   
	end
    inst:SetBrain(workerbrain)
    inst.sounds = workersounds

    return inst
end

local function onchargefn(inst) 
 
    inst:AddTag("scarytoprey")
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.8, 2, 2)
    inst.components.health:SetMaxHealth(TUNING.BEE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BEE_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BEE_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(2, KillerRetarget)
	if inst.components.pollinator then
		inst:RemoveComponent("pollinator")
	end
    inst:SetBrain(killerbrain)
    inst.sounds = killersounds    
    
    return inst
end

local function OnAttacked(inst)
    print "Test."
end    

local function OnWorked(inst, worker)
    local owner = inst.components.homeseeker and inst.components.homeseeker.home
    if owner and owner.components.childspawner then
        owner.components.childspawner:OnChildKilled(inst)
    end
    if worker.components.inventory then
        FightStat_Caught(inst)
        worker.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
    end
end

local function OnDropped(inst)
    inst.sg:GoToState("catchbreath")
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.brain then
		inst.brain:Start()
	end
	if inst.sg then
	    inst.sg:Start()
	end
	if inst.components.stackable then
	    while inst.components.stackable:StackSize() > 1 do
	        local item = inst.components.stackable:Get()
	        if item then
	            if item.components.inventoryitem then
	                item.components.inventoryitem:OnDropped()
	            end
	            item.Physics:Teleport(inst.Transform:GetWorldPosition() )
	        end
	    end
	end
end

local function OnPickedUp(inst)
    inst.sg:GoToState("idle")
end

local function commonfn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize( .8, .5 )
    inst.Transform:SetFourFaced()
 
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")    
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true);

    ----------
    
    inst:AddTag("bee")
    inst:AddTag("insect")
    inst:AddTag("hit_panic")
    inst:AddTag("smallcreature") 
   
    MakeCharacterPhysics(inst, 1, .5)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.FLYERS)
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbee")
    
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bee_marshmallow.xml"
	inst:AddComponent("stackable")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickedUp)
	inst.components.inventoryitem.canbepickedup = false

	---------------------
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("honey", 1)
	inst.components.lootdropper:AddRandomLoot("stinger", 5)   
	inst.components.lootdropper.numrandomloot = 1
	
	 ------------------
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)
   
    MakeSmallBurnableCharacter(inst, "body", Vector3(0, -1, 0))
    MakeTinyFreezableCharacter(inst, "body", Vector3(0, -1, 0))
    
    ------------------
    inst:AddComponent("health")

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"

    ------------------
    
    inst:AddComponent("sleeper")
    ------------------
    
    inst:AddComponent("knownlocations")

    ------------------
    
    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(onchargefn)
    inst.components.staticchargeable:SetOnUnchargeFn(onunchargefn)
	
    onunchargefn(inst)

    return inst
end

return Prefab( "forest/monsters/bee_marshmallow", commonfn, assets, prefabs)
