error "This shouldn't be used presently."

--[[
--
-- This handles controlling the clients' cameras from the host.
--
--]]

-- This maps camera fields to handlers for when they change.
-- Only used when we are the camera authority.
local cam_handlers = {}

-- Good until ~1.6k.
local function NetAngle(inst, varname)
    local ret = NetShort(inst, varname)
    ret:SetEncodingScale(20)
    return ret
end

-- Good until ~3k.
local function NetSpeed(inst, varname)
    local ret = NetShort(inst, varname)
    ret:SetEncodingScale(10)
    return ret
end

-- Good until ~3k.
local function NetDistance(inst, varname)
    local ret = NetShort(inst, varname)
    ret:SetEncodingScale(10)
    return ret
end

local UACamera = Class(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "UACameraReplica")

    assert(inst:HasTag("player"), "Logic error.")

    self.net_target = NetEntity(inst, "ua_camera.target")
    self.net_heading_target = NetAngle(inst, "ua_camera.heading_target")
    self.net_pangain = NetSpeed(inst, "ua_camera.pangain")
    self.net_headinggain = NetSpeed(inst, "ua_camera.headinggain")
    self.net_distancegain = NetSpeed(inst, "ua_camera.distancegain")
    self.net_controllable = NetBool(inst, "ua_camera.controllable")
    self.net_offset_x = NetDistance(inst, "ua_camera.offset_x")
    self.net_offset_y = NetDistance(inst, "ua_camera.offset_y")
    self.net_offset_z = NetDistance(inst, "ua_camera.offset_z")
    self.net_distance = NetDistance(inst, "ua_camera.distance")

    self.net_can_flip_heading = NetBool(inst, "ua_camera.can_flip_heading")
    self.net_is_offset_absolute = NetBool(inst, "ua_camera.is_offset_absolute")

    self.net_push_state = NetSignal(inst, "ua_camera.push_state")
    self.net_pop_state = NetSignal(inst, "ua_camera.pop_state")

    -- This denotes whether we should actually change TheCamera.
    self.is_authority = false

    if inst:HasTag("player") then
        TheMod:AddLocalPlayerPostActivation(function()
            local is_authority = (inst == GetLocalPlayer())
            self.is_authority = is_authority

            if is_authority then
                local cam = assert(_G.TheCamera)

                self.state_stack = {}

                self.net_target.local_value = cam.target
                self.net_heading_target.local_value = cam:GetHeadingTarget()
                self.net_pangain.local_value = cam.pangain
                self.net_headinggain.local_value = cam.headinggain
                self.net_distancegain.local_value = cam.distancegain
                self.net_controllable.local_value = cam:IsControllable()
                self.net_offset_x.local_value, self.net_offset_y.local_value, self.net_offset_z.local_value = (function()
                    if cam.target_offset then
                        return cam.target_offset:Get()
                    else
                        return 0, 0, 0
                    end
                end)()
                self.net_distance.local_value = cam:GetDistance()

                self.net_can_flip_heading.local_value = false
                self.net_is_offset_absolute.local_value = false

                self.net_target:AddOnDirtyFn(cam_handlers.target)
                self.net_heading_target:AddOnDirtyFn(cam_handlers.heading_target)
                self.net_pangain:AddOnDirtyFn(cam_handlers.pangain)
                self.net_headinggain:AddOnDirtyFn(cam_handlers.headinggain)
                self.net_distancegain:AddOnDirtyFn(cam_handlers.distancegain)
                self.net_controllable:AddOnDirtyFn(cam_handlers.controllable)
                --self.net_offset_x:AddOnDirtyFn(cam_handlers.offset)
                --self.net_offset_y:AddOnDirtyFn(cam_handlers.offset)
                self.net_offset_z:AddOnDirtyFn(cam_handlers.offset)
                self.net_distance:AddOnDirtyFn(cam_handlers.distance)

                self.net_push_state:AddOnDirtyFn(cam_handlers.push_state)
                self.net_pop_state:AddOnDirtyFn(cam_handlers.pop_state)
            end
        end)
    end
end)
local UAC = UACamera

function UAC:IsAuthority()
    return self.is_authority
end

---

local function NewSetter(prettyname, varname_stem)
    local varname = "net_"..varname_stem

    UAC["Set"..prettyname] = function(self, v)
        self[varname]:ForceSync(v)
    end
end


NewSetter("Target", "target")
NewSetter("PanGain", "pangain")
NewSetter("HeadingGain", "headinggain")
NewSetter("DistanceGain", "distancegain")
NewSetter("Controllable", "controllable")
NewSetter("Distance", "distance")

function UAC:SetHeadingTarget(heading, can_flip)
    self.net_can_flip_heading.value = (can_flip and true or false)
    self.net_heading_target:ForceSync(heading)
end

function UAC:SetOffset(off, is_absolute)
    self.net_is_offset_absolute.value = (is_absolute and true or false)

    self.net_offset_x.value = off.x
    self.net_offset_y.value = off.y
    self.net_offset_z:ForceSync(off.z)
end

function UAC:SetGains(pan, heading, distance)
    self:SetPanGain(pan)
    self:SetHeadingGain(heading)
    self:SetDistanceGain(distance)
end

function UAC:PushState()
    self.net_push_state()
end

function UAC:PopState()
    self.net_pop_state()
end

---

local function NewCamSetter(id, camid)
    if camid == nil then
        camid = id
    end
    local net_id = "net_"..id
    cam_handlers[id] = function(inst)
        local self = replica(inst).ua_camera
        if not self then return end

        local cam = assert(_G.TheCamera)

        cam[camid] = self[net_id].value
    end
end

local function NewCamMethodSetter(id, camid)
    if camid == nil then
        camid = id
    end
    local net_id = "net_"..id
    cam_handlers[id] = function(inst)
        local self = replica(inst).ua_camera
        if not self then return end

        local cam = assert(_G.TheCamera)

        cam[camid](cam, self[net_id].value)
    end
end

NewCamMethodSetter("target", "SetTarget")
NewCamSetter("pangain")
NewCamSetter("headinggain")
NewCamSetter("distancegain")
NewCamMethodSetter("controllable", "SetControllable")
NewCamMethodSetter("distance", "SetDistance")

function cam_handlers.heading_target(inst)
    local self = replica(inst).ua_camera
    if not self then return end

    local ht = self.net_heading_target.value

    local cam = assert(_G.TheCamera)

    if self.net_can_flip_heading .value then
        if cam.heading and math.abs(ht%360 - cam.heading%360) > 90 then
            ht = ht + 180
        end
    end

    cam:SetHeadingTarget(ht)
end

function cam_handlers.offset(inst)
    local self = replica(inst).ua_camera
    if not self then return end

    local cam = assert(_G.TheCamera)
    
    local x = self.net_offset_x.value
    local y = self.net_offset_y.value
    local z = self.net_offset_z.value

    local off = Vector3(x, y, z)
    if cam.target and self.net_is_offset_absolute.value then
        off = off - cam.target:GetPosition()
    end

    cam:SetOffset( off )
end

---

local function getCamState()
    local cam = assert( _G.TheCamera )
    return {
        target = cam.target,
        heading_target = cam:GetHeadingTarget(),
        pangain = cam.pangain,
        headinggain = cam.headinggain,
        distancegain = cam.distancegain,
        controllable = cam:IsControllable(),
        distance = cam:GetDistance(),
        offset = Vector3( cam.targetoffset:Get() ),
    }
end

local function restoreCamState(s)
    local cam = assert( _G.TheCamera )

    cam:SetTarget(s.target)
    cam:SetHeadingTarget(s.heading_target)
    cam.pangain = s.pangain
    cam.headinggain = s.headinggain
    cam.distancegain = s.distancegain
    cam:SetControllable(s.controllable)
    cam:SetDistance(s.distance)
    cam:SetOffset(s.offset)
end

function cam_handlers.push_state(inst)
    local self = replica(inst).ua_camera
    if not self then return end

    assert(self.state_stack)
    table.insert(self.state_stack, getCamState())
end

function cam_handlers.pop_state(inst)
    local self = replica(inst).ua_camera
    if not self then return end

    assert(self.state_stack)
    local s = table.remove(self.state_stack)
    if s then
        restoreCamState(s)
    else
        _G.TheCamera:SetDefault()
    end
end

---

return UAC
