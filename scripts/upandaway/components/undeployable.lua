--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Lambda = wickerrequire 'paradigms.functional'

local Pred = wickerrequire 'lib.predicates'

local Game = wickerrequire 'utils.game'

local Debuggable = wickerrequire 'adjectives.debuggable'


require 'actions'
local ACTIONS = _G.ACTIONS


local Undeployable = Class(Debuggable, function(self, inst)
    self.inst = inst
	Debuggable._ctor(self)
	self:SetConfigurationKey("UNDEPLOYABLE")

	self.onundeployfn = nil
end)

function Undeployable:SetOnUndeployFn(fn)
	self.onundeployfn = fn
end

function Undeployable:SetDefaultOnUndeployFn(prefabname)
	assert( Pred.PrefabExists(prefabname) )
	self:SetOnUndeployFn( Lambda.BindFirst(SpawnPrefab, prefabname) )
end

function Undeployable:Undeploy(undeployer)
	self:DebugSay("undeploying")

	local pos = self.inst:GetPosition()

	self.inst:PushEvent("onundeploy", {undeployer = undeployer})

	local outcomes
	if self.onundeployfn then
        outcomes = {self.onundeployfn(self.inst, undeployer)}
	end

	if self.inst:IsValid() then
		self.inst:Remove()
	end

	if not outcomes then
		return true
	end

	for _, e in pairs(outcomes) do
		if Pred.IsEntityScript(e) and e:IsValid() then
			self:DebugSay("got undeploy outcome [", e, "]...")
			if e.components.inventoryitem and undeployer.components.inventory then
				self:DebugSay("...and put it in [", undeployer, "]'s inventory.")
				undeployer.components.inventory:GiveItem( e )
			else
				self:DebugSay("...and put it on ground.")
				Game.Move(e, pos)
			end
		end
	end

	return true
end

function Undeployable:CollectSceneActions(doer, actions, right)
	if right then
		table.insert(actions, ACTIONS.UNDEPLOY)
	end
end

return Undeployable
