BindGlobal()

local assets =
{
    Asset("ANIM", "anim/whirlwind.zip")	
}

local brain = modrequire "brains.whirlwindbrain"

--[[
-- Receives the whirlwind entity and the victim.
-- Returns the curve (as a function of elapsed time) describing the path
-- when lifting the victim.
--]]
local function MakeHelix(inst, victim)
    local rspeed = 0.8
    local angspeed = 2.2*math.pi
    local yspeed = 1.4

    local r0 = math.sqrt( inst:GetDistanceSqToInst(victim) )
    local ang0 = -inst:GetAngleToPoint(victim:GetPosition())*_G.DEGREES
    local y0 = victim:GetPosition().y

    return function(t)
        local r = r0 + rspeed*t
        local ang = ang0 + angspeed*t
        local y = y0 + yspeed*t

        if t >= 8 then return end

        return Vector3(
            r*math.cos(ang),
            y,
            r*math.sin(ang)
        )
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    anim:SetBank("whirlwind")
    anim:SetBuild("whirlwind")
    anim:PlayAnimation("spin_loop", true)
    anim:SetMultColour(.6, .6, .6, .3)

    inst.Transform:SetScale(1.7,1.7,1.7)

    local physics = inst.entity:AddPhysics()
    physics:SetMass(1)
    physics:SetCylinder(.3, 3)
    physics:SetFriction(0)
    physics:SetDamping(5)
    physics:SetCollisionGroup(_G.COLLISION.OBSTACLES)
    physics:ClearCollisionMask()
    physics:CollidesWith(_G.COLLISION.WORLD)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------



    inst:AddComponent("entityflinger")
    do
        local entityflinger = inst.components.entityflinger

        entityflinger:RequestDeathIn(30)

        -- Minimum distance to throw entities away.
        entityflinger:SetMinimumDistance(32)
        -- Like the above, but maximum.
        entityflinger:SetMaximumDistance(512)
        -- Height at which a thrown entity appears.
        entityflinger:SetHeight(64)
        -- Radius for attracting entities closer.
        entityflinger:SetAttractionRadius(4)
        -- Radius to stop attracting and start lifting.
        entityflinger:SetActivityRadius(.40) --.25
        -- Speed of attraction.
        entityflinger:SetAttractionSpeed(2)
        -- Attraction test.
        entityflinger:SetAttractionTest( nil )
        -- Curve to be described when lifting an entity.
        entityflinger:SetMotionCurveGenerator( MakeHelix )

        entityflinger:StartAttracting()
    end

    inst:AddComponent("locomotor")
    do
        local locomotor = inst.components.locomotor

        locomotor.directdrive = true
        locomotor.walkspeed = 1
        locomotor.runspeed = 1
    end

    inst:AddComponent("inspectable")


    inst:SetBrain(brain)


    return inst
end

return Prefab ("common/objects/whirlwind", fn, assets) 
