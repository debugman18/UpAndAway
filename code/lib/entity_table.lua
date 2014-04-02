--[[
-- Creates tables indexes by entities.
--
-- The entries are automatically cleaned when the entity is removed.
--]]


local Pred = wickerrequire 'lib.predicates'


local function new_entity_table(onclear)
	local inner_t = {}

	local function ClearEntry(inst)
		if onclear then
			onclear(inst)
		end
		inner_t[inst] = nil
	end

	local function SetInstEntry(t, inst, v)
		assert( Pred.IsEntityScript(inst), "EntityScript expected as index!" )

		local oldv = inner_t[inst]

		if oldv == nil and v ~= nil then
			inst:ListenForEvent("onremove", ClearEntry)
		elseif oldv ~= nil and v == nil then
			inst:RemoveEventCallback("onremove", ClearEntry)
			if onclear then
				onclear(inst)
			end
		end

		inner_t[inst] = v
	end

	local next = next
	local function next(t, k)
		return next(inner_t)
	end

	local pairs = pairs
	local function pairs(t)
		return pairs(inner_t)
	end

	local t = {}

	return setmetatable(t, {
		__index = inner_t,
		__newindex = SetInstEntry,
		__next = next,
		__pairs = pairs,
	})
end


return new_entity_table
