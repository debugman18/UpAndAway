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


local Withdrawable = Class(Debuggable, function(self, inst)
    self.inst = inst
	Debuggable._ctor(self)
	self:SetConfigurationKey("WITHDRAWABLE")

	self.onwithdrawfn = nil
end)

function Withdrawable:SetOnWithdrawFn(fn)
	self.onwithdrawfn = fn
end

function Withdrawable:SetDefaultOnWithdrawFn(prefabname)
	assert( Pred.PrefabExists(prefabname) )
	self:SetOnWithdrawFn( Lambda.BindFirst(SpawnPrefab, prefabname) )
end

function Withdrawable:Withdraw(withdrawer)
	self:DebugSay("withdrawing")

	local pos = self.inst:GetPosition()

	self.inst:PushEvent("onwithdraw", {withdrawer = withdrawer})

	local outcomes
	if self.onwithdrawfn then
        outcomes = {self.onwithdrawfn(self.inst, withdrawer)}
	end

	if self.inst:IsValid() then
		self.inst:Remove()
	end

	if not outcomes then
		return true
	end

	for _, e in pairs(outcomes) do
		if Pred.IsEntityScript(e) and e:IsValid() then
			self:DebugSay("got withdraw outcome [", e, "]...")
			if e.components.inventoryitem and withdrawer.components.inventory then
				self:DebugSay("...and put it in [", withdrawer, "]'s inventory.")
				withdrawer.components.inventory:GiveItem( e )
			else
				self:DebugSay("...and put it on ground.")
				Game.Move(e, pos)
			end
		end
	end

	return true
end

function Withdrawable:CollectSceneActions(doer, actions, right)
	if right then
		table.insert(actions, ACTIONS.WITHDRAW)
	end
end

return Withdrawable
