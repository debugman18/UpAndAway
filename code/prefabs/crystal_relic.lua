BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs = 
{
	"owl",
	"crystal_fragment_relic",
}

local CFG = TheMod:GetConfig()

local loot = 
{
    "crystal_fragment_relic",
	"crystal_fragment_relic",
	"crystal_fragment_relic",
}
        
local function onMined(inst, worker)
    inst:RemoveComponent("resurrector")
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function OnActivate(inst)
	inst.components.resurrector.active = true
	inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_activate")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end

local function doresurrect(inst, dude)
	inst:AddTag("busy")	
	if inst.MiniMapEntity then
		inst.MiniMapEntity:SetEnabled(false)
	end	
    if inst.Physics then
		MakeInventoryPhysics(inst) -- collides with world, but not character
    end

	GetPseudoClock():MakeNextDay()
    dude.Transform:SetPosition(inst.Transform:GetWorldPosition())
    dude:Hide()
    TheCamera:SetDistance(12)

    scheduler:ExecuteInTime(3, function()
        dude:Show()
        --inst:Hide()

        GetPseudoSeasonManager():DoLightningStrike(Vector3(inst.Transform:GetWorldPosition()))


		inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_break")
        --inst.components.lootdropper:DropLoot()
        inst:Remove()
        
        if dude.components.hunger then
            dude.components.hunger:SetPercent(.3)
        end

        if dude.components.health then
            dude.components.health:Respawn(.3)
        end
        
        if dude.components.sanity then
			dude.components.sanity:SetPercent(.3)
        end
        
        dude.sg:GoToState("wakeup")
        
        dude:DoTaskInTime(3, function(inst) 
		            if dude.HUD then
		                dude.HUD:Show()
		            end
		            TheCamera:SetDefault()
		            inst:RemoveTag("busy")

			--SaveGameIndex:SaveCurrent(function()
			--	end)            
        end)
        
    end)

    inst:Remove()
end

local function makeactive(inst)
	--inst.AnimState:PlayAnimation("idle_activate", true)
	inst.components.activatable.inactive = false
end

local function makeused(inst)
	inst.AnimState:PlayAnimation("idle_low", true)
end

local function onhit(inst, worker)
    if workleft and workleft <= 0 then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
        --inst.components.lootdropper:DropLoot()
        inst:Remove()
    else            
        if workleft and workleft <= TUNING.SPILAGMITE_ROCK * 0.5 then
            inst.AnimState:PlayAnimation("idle_low")
        else
            inst.AnimState:PlayAnimation("idle_med")
        end
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon("crystal_relic.png")
    
    MakeObstaclePhysics(inst, 1)

    inst:AddTag("crystal")

	anim:SetBank("crystal_relic")
	anim:SetBuild("crystal")
    anim:PlayAnimation("idle_full")
    MakeObstaclePhysics(inst, 1.)
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)
    inst:AddTag("structure")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.SPILAGMITE_ROCK*1.5)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetOnFinishCallback(onMined)	
	
	local scale = math.random(3,4)
	inst.Transform:SetScale(scale, scale, scale)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("owl")
    inst.components.periodicspawner:SetDensityInRange(5, 3)
    inst.components.periodicspawner:SetMinimumSpacing(5)

	inst:AddComponent("resurrector")
	inst.components.resurrector.makeactivefn = makeactive
	inst.components.resurrector.makeusedfn = makeused
	inst.components.resurrector.doresurrect = doresurrect

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "Sacred Crystal"

	--MakeSnowCovered(inst, .01)
    return inst
end

return Prefab("cloudrealm/objects/crystal_relic", fn, assets, prefabs )  
