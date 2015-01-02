--FIXME: not MP compatible

BindGlobal()

local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local Tree = wickerrequire "utils.table.tree"

local Debuggable = wickerrequire "adjectives.debuggable"

local default_attack_levels = {
    intro={warnduration= function() return 120 end, numhounds = function() return 2 end},
    light={warnduration= function() return 60 end, numhounds = function() return 2 + math.random(2) end},
    med={warnduration= function() return 45 end, numhounds = function() return 3 + math.random(3) end},
    heavy={warnduration= function() return 30 end, numhounds = function() return 4 + math.random(3) end},
    crazy={warnduration= function() return 30 end, numhounds = function() return 6 + math.random(4) end},
}

local default_attack_delays = {
    rare = function() return TUNING.TOTAL_DAY_TIME * 6 + math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
    occasional = function() return TUNING.TOTAL_DAY_TIME * 4 + math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
    frequent = function() return TUNING.TOTAL_DAY_TIME * 3 + math.random() * TUNING.TOTAL_DAY_TIME * 5 end,
}

local GenericHounded = HostClass(Debuggable, function(self, inst, name)
    self.inst = inst

    Debuggable._ctor(self, name or "GenericHounded", true)
    
    self.spawn_distance = 30
    self.announcement = "ANNOUNCE_HOUNDS"
    self.warning_sound = "dontstarve/creatures/hound/distant"
    self.announcewarningsoundinterval = 4
    self.hound_spawner = default_spawner

    self.attack_levels = Tree.InjectInto({}, default_attack_levels)
    self.attack_delays = Tree.InjectInto({}, default_attack_delays)

    self.warning = false
    self.timetoattack = 200
    self.warnduration = 30
    self.timetonextwarningsound = 0
    self.houndstorelease = 0
    self.timetonexthound = 0

    self.attackdelayfn = self.attack_delays.occasional
    self.attacksizefn = self.attack_levels.light.numhounds
    self.warndurationfn = self.attack_levels.light.warnduration
    self.spawnmode = "escalating"
    
    self.inst:StartUpdatingComponent(self)
    self:PlanNextHoundAttack()
end)

function GenericHounded:SetSpawnDistance(r)
    assert( Pred.IsPositiveNumber(r) or Pred.IsCallable(r) )
    self.spawn_distance = r
end

function GenericHounded:GetSpawnDistance()
    local r = self.spawn_distance
    if Pred.IsCallable(r) then
        r = r(self.inst)
        assert( Pred.IsPositiveNumber(r) )
    end
    return r
end

function GenericHounded:GetPrefabToSpawn()
    local prefab = "hound"
    local special_chance = self:GetSpecialHoundChance()

    if GetPseudoSeasonManager() then
        if GetPseudoSeasonManager():IsSummer() then
            special_chance = special_chance * 1.5
        end

        if math.random() < special_chance then
            if GetPseudoSeasonManager():IsWinter() then
                prefab = "icehound"
            else
                prefab = "firehound"
            end
        end
    end

    return prefab
end

function GenericHounded:SpawnModeEscalating()
    self.spawnmode = "escalating"
    self:PlanNextHoundAttack()
end

function GenericHounded:SpawnModeNever()
    self.spawnmode = "never"
    self:PlanNextHoundAttack()
end

function GenericHounded:SpawnModeHeavy()
    self.spawnmode = "constant"
    self.attackdelayfn = self.attack_delays.frequent
    self.attacksizefn = self.attack_levels.heavy.numhounds
    self.warndurationfn = self.attack_levels.heavy.warnduration
    self:PlanNextHoundAttack()
end

function GenericHounded:SpawnModeMed()
    self.spawnmode = "constant"
    self.attackdelayfn = self.attack_delays.occasional
    self.attacksizefn = self.attack_levels.med.numhounds
    self.warndurationfn = self.attack_levels.med.warnduration
    self:PlanNextHoundAttack()
end

function GenericHounded:SpawnModeLight()
    self.spawnmode = "constant"
    self.attackdelayfn = self.attack_delays.rare
    self.attacksizefn = self.attack_levels.light.numhounds
    self.warndurationfn = self.attack_levels.light.warnduration
    self:PlanNextHoundAttack()
end


function GenericHounded:OnSave()
    if not self.noserial then
        return 
        {
            spawnmode = self.spawnmode,
            warning = self.warning,
            timetoattack = self.timetoattack,
            warnduration = self.warnduration,
            houndstorelease = self.houndstorelease,
            timetonexthound = self.timetonexthound
        }
    end
    self.noserial = false
end

function GenericHounded:OnLoad(data)
    self.spawnmode = data.spawnmode or "escalating"
    self.warning = data.warning or false
    self.timetoattack = data.timetoattack or 0
    self.warnduration = data.warnduration or 0
    self.houndstorelease = data.houndstorelease or 0
    self.timetonexthound = data.timetonexthound or 0
end


function GenericHounded:OnProgress()
    self.noserial = true
end


function GenericHounded:GetDebugString()
    if self.timetoattack > 0 then
        return string.format("%s %d hounds are coming in %2.2f", self.warning and "WARNING" or "WAITING",   self.houndstorelease, self.timetoattack)
    else
        return string.format("ATTACKING %d hounds left. Next in %2.2f", self.houndstorelease, self.timetonexthound)
    end
end

function GenericHounded:OnUpdate(dt)
    if self.spawnmode == "never" then
        return
    end
    
    self.timetoattack = self.timetoattack - dt
    if self.timetoattack <= 0 then
        self.timetonexthound = self.timetonexthound - dt		
        
        if self.timetonexthound < 0 then
            self.warning = false
            self:ReleaseHound()
            
            local day = GetPseudoClock():GetNumCycles()
            if day < 20 then
                self.timetonexthound = 3 + math.random()*5
            elseif day < 60 then
                self.timetonexthound = 2 + math.random()*3
            elseif day < 100 then
                self.timetonexthound = .5 + math.random()*3
            else
                self.timetonexthound = .5 + math.random()*1
            end
        end
        
        if self.houndstorelease <= 0 then
            self:PlanNextHoundAttack()
        end
    else
        if not self.warning and self.timetoattack < self.warnduration then
            self.warning = true
            self.timetonextwarningsound = 0
        end
    end
    
    if self.warning then
        self.timetonextwarningsound	= self.timetonextwarningsound - dt
        
        if self.timetonextwarningsound <= 0 then
        
            self.announcewarningsoundinterval = self.announcewarningsoundinterval - 1
            if self.announcewarningsoundinterval <= 0 then
                self.announcewarningsoundinterval = 10 + math.random(5)
                    GetPlayer().components.talker:Say(GetString(GetPlayer().prefab, self.announcement))
            end
        
            local inst = CreateEntity()
            inst.entity:AddTransform()
            inst.entity:AddSoundEmitter()
            inst.persists = false
            local theta = 2*math.pi*math.random()

            local radius = 30
            
            if self.timetoattack < 30 then
                self.timetonextwarningsound = .3 + math.random(1)
                radius = self:GetSpawnDistance()
            elseif self.timetoattack < 60 then
                self.timetonextwarningsound = 2 + math.random(1)
                radius = self:GetSpawnDistance() + 10
            elseif self.timetoattack < 90 then
                self.timetonextwarningsound = 4 + math.random(2)
                radius = self:GetSpawnDistance() + 20
            else
                self.timetonextwarningsound = 5 + math.random(4)
                radius = self:GetSpawnDistance() + 30
            end

            local offset = Vector3(GetPlayer().Transform:GetWorldPosition()) +  Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
            
            inst.Transform:SetPosition(offset.x,offset.y,offset.z)
            inst.SoundEmitter:PlaySound(self.warning_sound)
            inst:DoTaskInTime(1.5, function() inst:Remove() end)
            
        end
    end
end


function GenericHounded:CalcEscalationLevel()
    local day = GetPseudoClock():GetNumCycles()
    
    if day < 10 then
        self.attackdelayfn = self.attack_delays.rare
        self.attacksizefn = self.attack_levels.intro.numhounds
        self.warndurationfn = self.attack_levels.intro.warnduration
    elseif day < 25 then
        self.attackdelayfn = self.attack_delays.rare
        self.attacksizefn = self.attack_levels.light.numhounds
        self.warndurationfn = self.attack_levels.light.warnduration
    elseif day < 50 then
        self.attackdelayfn = self.attack_delays.occasional
        self.attacksizefn = self.attack_levels.med.numhounds
        self.warndurationfn = self.attack_levels.med.warnduration
    elseif day < 100 then
        self.attackdelayfn = self.attack_delays.occasional
        self.attacksizefn = self.attack_levels.heavy.numhounds
        self.warndurationfn = self.attack_levels.heavy.warnduration
    else
        self.attackdelayfn = self.attack_delays.frequent
        self.attacksizefn = self.attack_levels.crazy.numhounds
        self.warndurationfn = self.attack_levels.crazy.warnduration
    end
    
end

function GenericHounded:PlanNextHoundAttack()
    
    if self.spawnmode == "escalating" then
        self:CalcEscalationLevel()
    end
    
    if self.spawnmode ~= "never" then
        self.timetoattack = self.attackdelayfn()
        self.houndstorelease = self.attacksizefn()
        self.warnduration = self.warndurationfn()
    end
end


function GenericHounded:GetSpawnPoint(pt)
    local offset = FindWalkableOffset(pt, 2*math.pi*math.random(), self:GetSpawnDistance(), 12, true)
    if offset then
        return pt+offset
    end
end

function GenericHounded:GetSpecialHoundChance()
    local day = GetPseudoClock():GetNumCycles()
    local chance = 0
    for k,v in ipairs(TUNING.HOUND_SPECIAL_CHANCE) do
        if day > v.minday then
            chance = v.chance
        elseif day <= v.minday then
            return chance
        end
    end
    
    return chance
end

function GenericHounded:ReleaseHound(dt)
    local spawn_pt = self:GetSpawnPoint( GetPlayer():GetPosition() )
    if spawn_pt then
        self.houndstorelease = self.houndstorelease - 1
        self:SpawnHound(spawn_pt)
    end
end

function GenericHounded:SpawnHound(spawn_pt)
    local hound = SpawnPrefab( self:GetPrefabToSpawn() )
    if hound then
        hound.Physics:Teleport(spawn_pt:Get())
        hound:FacePoint(GetPlayer():GetPosition())
        hound.components.combat:SuggestTarget(GetPlayer())
        return hound
    end
end

function GenericHounded:LongUpdate(dt)
    if self.spawnmode == "never" then
        return
    end
    
    if self.timetoattack > 30 then
        self.timetoattack = math.max(30, self.timetoattack - dt)
    end
end


return GenericHounded
