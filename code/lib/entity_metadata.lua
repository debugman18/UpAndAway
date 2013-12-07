--[[
-- Returns a table indexed by entities to stores arbitrary data about them.
--
-- The entries are automatically cleaned when the entity is removed.
--]]


local Pred = wickerrequire 'lib.predicates'


local metadata


local function ClearEntry(inst)
	metadata[inst] = nil
end

local function CreateInstEntry(_, inst)
	assert( Pred.IsEntityScript(inst), "EntityScript expected as index!" )

	local entry = {}
	metadata[inst] = entry

	inst:ListenForEvent("onremove", ClearEntry)

	return entry
end


metadata = setmetatable({}, {
	__index = CreateInstEntry,
	__mode = "k",
})


return metadata
