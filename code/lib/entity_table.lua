--[[
-- Creates tables indexes by entities.
--
-- The entries are automatically cleaned when the entity is removed.
--]]


local Pred = wickerrequire 'lib.predicates'


local function new_entity_table(onclear)
	local inner_t = {}

	local function ClearEntry(inst)
		inner_t[inst] = nil
		if onclear then
			onclear(inst)
		end
	end

	local function SetInstEntry(t, inst, v)
		assert( Pred.IsEntityScript(inst), "EntityScript expected as index!" )

		local oldv = inner_t[inst]
		inner_t[inst] = v

		if oldv == nil and v ~= nil then
			inst:ListenForEvent("onremove", ClearEntry)
		elseif oldv ~= nil and v == nil then
			inst:RemoveEventCallback("onremove", ClearEntry)
			if onclear then
				onclear(inst)
			end
		end
	end

	local t = {}

	function t.IsEmpty()
		return next(inner_t) == nil
	end

	return setmetatable(t, {
		__index = inner_t,
		__newindex = SetInstEntry,
	})
end


return new_entity_table
