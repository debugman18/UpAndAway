---
-- Utility functions for filling STRINGS.
--


local is_character_with_unbelievably_silly_implementation = {
    WATHGRITHR = true,
    WEBBER = true,
}


---
-- Table returned by the module. All its functions are case insensitive in respect to prefab and character names.
--
-- @class table
-- @name Add
--
local Add = {}


local Lambda = wickerrequire "paradigms.functional"

local FunctionQueue = wickerrequire "gadgets.functionqueue"


---
-- Returns all characters. To be used as an iterator.
local all_characters = (function()
    local main_list = Lambda.CompactlyFilter(
        Lambda.Not(Lambda.IsEqualTo("wilson")),
        ipairs(rawget(_G, "MAIN_CHARACTERLIST") or rawget(_G, "CHARACTERLIST"))
    )
    local mod_list = _G.MODCHARACTERLIST

    local lists = {main_list, mod_list}

    local dlc_list = rawget(_G, "ROG_CHARACTERLIST")
    if dlc_list then
        table.insert(lists, dlc_list)
    end

    local function all_characters_coroutine()
        coroutine.yield("GENERIC")
        for _, list in ipairs(lists) do
            for _, character in ipairs(list) do
                coroutine.yield(character)
            end
        end
    end

    return function()
        return coroutine.wrap(all_characters_coroutine)
    end
end)()

---
-- Adds names to a set of prefabs.
--
-- @param names Table mapping a prefab name to its user visible name.
function Add.Names(names)
    for ks, v in pairs(names) do
        if type(ks) ~= "table" then ks = {ks} end
        for _, k in ipairs(ks) do
            local ku = k:upper()
            local real_v = v
            if type(v) == "function" then
                real_v = v(ku)
            end
            STRINGS.NAMES[ku] = real_v
        end
    end
end


local delayed_additions = FunctionQueue()
TheMod:AddSimPostInit(delayed_additions:ToFunction())

--[[
-- Branch is an array with the successive entries to be added, such as
-- {"DESCRIBE", "ALIEN"}
-- or
-- {"DESCRIBE", "SHEEP", "CHARGED"}
--
-- The pieces are put in uppercase if they are not already.
--]]
local add_character_string = (function()
	local function descend(t, node)
		if type(t[node]) == "string" then
			t[node] = {GENERIC = t[node]}
		elseif not t[node] then
			t[node] = {}
		else
			assert( type(t[node]) == "table" )
		end
		return t[node]
	end

    local function do_add(character_upper, branch, str, no_override, base_table)
        local t = base_table
		if not t then
			t = STRINGS.CHARACTERS[character_upper]
		end
        if not t then return end

        local branch_sz = #branch
        local leaf = branch[branch_sz]

        for i = 1, branch_sz - 1 do
            t = descend(t, branch[i])
        end

		if type(str) == "table" then
			t = descend(t, leaf)
			local branch_suffix = {nil}
			for k, substr in pairs(str) do
				branch_suffix[1] = k
				do_add(character_upper, branch_suffix, substr, no_override, t)
			end
			return
		end

        if no_override and t[leaf] ~= nil then return end

        local real_str = str
        if type(str) == "function" then
            real_str = str(character_upper, unpack(branch))
        end
        t[leaf] = real_str
    end

    return function(character_upper, branch, str)
        local upper_branch = Lambda.CompactlyMap(string.upper, ipairs(branch))

        if is_character_with_unbelievably_silly_implementation[character_upper] then
            table.insert(delayed_additions, function()
                return do_add(character_upper, upper_branch, str)
            end)
        elseif character_upper == "ANY" then
            table.insert(delayed_additions, function()
                for char in all_characters() do
                    do_add(char:upper(), upper_branch, str, true)
                end
            end)
        else
            return do_add(character_upper, upper_branch, str)
        end
    end
end)()

local function normalize_branch(branch)
    if branch then
        return Lambda.CompactlyMap(string.upper, ipairs(branch))
    else
        return {}
    end
end

-- Returns a new one.
-- Assumes branch has already been normalized.
local function append_prefab_to_branch(branch, prefab)
    local b = Lambda.CompactlyInjectInto({}, ipairs(branch))
    Lambda.CompactlyMapInto(string.upper, b, prefab:gmatch("[^%.]+"))
    return b
end

local function NewPrefabStringAdder(prefix_branch)
    prefix_branch = normalize_branch(prefix_branch)

    return function(prefabs)
        if type(prefabs) ~= "table" then
            prefabs = {prefabs}
        end

        local branches = Lambda.CompactlyMap(
            Lambda.BindFirst(append_prefab_to_branch, prefix_branch),
            ipairs(prefabs)
        )

        return function(quotes)
            for _, branch in ipairs(branches) do
                for characters, quote in pairs(quotes) do
                    if type(characters) ~= "table" then characters = {characters} end
                    for _, character in ipairs(characters) do
                        add_character_string(character:upper(), branch, quote)
                    end
                end
            end
        end
    end
end

local function NewCharacterStringAdder(prefix_branch)
    prefix_branch = normalize_branch(prefix_branch)

    return function(character)
        local character_upper = character:upper()
        return function(quotes)
            for whats, quote in pairs(quotes) do
                if type(whats) ~= "table" then whats = {whats} end
                for _, what in ipairs(whats) do
                    local branch = append_prefab_to_branch(prefix_branch, what)
                    add_character_string(character_upper, branch, quote)
                end
            end
        end
    end
end

---
-- Adds a set of quotes for a prefab.
--
-- @param prefab Prefab name. If containing a period, the left part is taken as the actual prefab name and the right part as its status name.
--
-- @return A function receiving a set of quotes, in the form of a table mapping a character name to a quote.
Add.QuotesFor = NewPrefabStringAdder {"DESCRIBE"}

---
-- Adds a set of quotes for a character.
--
-- @param character Character name.
--
-- @return A function receiving a set of quotes, in the form of a table mapping a prefab name to a quote.
Add.QuotesBy = NewCharacterStringAdder {"DESCRIBE"}

Add.StringsFor = NewPrefabStringAdder {}

Add.StringsBy = NewCharacterStringAdder {}


return Add
