--[[
-- This function takes an entity and returns its gender, caching the result
-- (since  GetGenderStrings() is quite inefficient)
--]]
local get_inst_gender = (function()
	local cache = {}

	return function(inst)
		local p = inst.prefab
		if not p then return "MALE" end

		local ret = cache[p]
		if not ret then
			ret = _G.GetGenderStrings(p) or "MALE"
			cache[p] = ret
		end

		return ret
	end
end)()

--[[
-- This defines translations of words in the speeches below according to
-- the specified function.
--
-- The original word can be specified in any combination of lower/upper case.
--
-- When mapping a word, the final word preserved the capitalization of the
-- word as found in the text.
--]]
WORD_MAP = {
	fella = function(listener)
		return get_inst_gender(listener) == "FEMALE" and "darling" or "fella"
	end
}

-- These are the shopkeeper's speeches.
--
-- Each speech is a function receiving a SpeechManager object as its first
-- parameter (see components/speechgiver.lua and search for the "@README@"
-- string in a comment).
--
-- The speaker entity (the Shopkeeper) is in the "speaker" field, and the
-- listening entity (the player) in the "listener" field.
--
-- I hope the following usage is simple and self-explanatory, even without
-- checking the speechgiver.lua file.
SPEECHES = {}


local metalsnd = "dontstarve/common/destroy_metal"


--This is the speech where he asks for beefalo in exchange for magic beans.
SPEECHES.BEAN_QUEST = function(mgr)
	mgr:MakeNonInterruptible()
	mgr:EnterCutScene()

	mgr "Hello there, fella."
	mgr:PlaySound(metalsnd)

	mgr "You look tired."

	Sleep(0.5)

	mgr "What if I told you I had something that could get you out?"
	mgr "That could whisk you away from this miserable plane?"

	Sleep(0.5)

	mgr "Interested?"
	mgr "Then let's make a deal."

	Sleep(0.5)

	mgr "I have need of a Beefalo."
	mgr "Those hairy beasts you've seen roaming the grasslands."
	mgr "Bring me one..."
	Sleep(1)
	mgr "...And I'll give you the ticket out."

	mgr:ExitCutScene()
	Sleep(0.5)

	mgr "Get to it, fella."
	mgr:PlaySound(metalsnd)
end


--This is for when a trade is successful.
--
--args is the table specified in inst.components.speechgiver:AddSpeechData()
--in the shopkeeper constructor.
SPEECHES.BEAN_SUCCESS = function(mgr, args)
	assert( args.givebeans )

	mgr:MakeNonInterruptible()
	mgr:EnterCutScene()

	Sleep(1.5)

	mgr "You fulfilled your end of the bargain."
	mgr:PlaySound(metalsnd)

	mgr "Now for me to keep mine."
	mgr:PlaySound(metalsnd)

	mgr:KillVoice()
	Sleep(0.5)

	args.givebeans(mgr.speaker, mgr.listener)

	Sleep(0.5)

	mgr "Your ticket out of here."
	mgr:PlaySound(metalsnd)

	-- Goes straight into the BEANS_HINT speech, so I removed the part below.

	--[[
	mgr:ExitCutScene()
	Sleep(0.5)

	mgr "Best of luck, fella."
	mgr:PlaySound(metalsnd)
	]]--
end


--This is for when the player attacks the shopkeeper.
--(the entity gets removed, it will never run!)
SPEECHES.HIT = function(mgr)
	if mgr.listener:HasTag("player") then
		mgr:EnterCutScene()

		Sleep(1)
		mgr "..."
		Sleep(1)
	end
end

--This is for when the player keeps bugging the shopkeeper about the beans.
SPEECHES.BEAN_REMINDER = function(mgr)
	Sleep(0.25)

	mgr "Get to it, fella."
	mgr:PlaySound(metalsnd)
end

--This is to flag the player down.
SPEECHES.FLAG_PLAYER = function(mgr)
	Sleep(0.25)

	mgr "Hey you! Yes, you there!"
	mgr:PlaySound(metalsnd)
end

--This gives the player a hint about the beans.
SPEECHES.BEAN_HINT = function(mgr)
	if not mgr.speaker.gavebeans then return end

	if mgr:EnterCutScene() then
		Sleep(1.5)
	end

	mgr "Now, you can't just plant those beans in any old soil."
	mgr:PlaySound(metalsnd)

	mgr "They require a powerful fertilizer."
	mgr:PlaySound(metalsnd)

	mgr "Bonemeal, perhaps. A grave?"
	mgr:PlaySound(metalsnd)

	mgr "Then..."
	Sleep(1.5)

	mgr "...Just let the moon do the rest."
	mgr:PlaySound(metalsnd)
end
