BindGlobal()


--[[
-- We generate the speech through a function so that it may tweak it according
-- to dynamic data (i.e., player gender).
--]]

local function generateSpeeches()
	local character = SaveGameIndex:GetSlotCharacter()

	local gender = GetGenderStrings(character)


	-- How we describe (i.e., refer) to the character.
	local char_desc = gender == "FEMALE" and "darling" or "fella"


	--These are the shopkeeper's speeches.
	return {
		--This is the speech that is loaded if no speech is defined.
		NULL_SPEECH=
		{
			
			delay = 2,
			disableplayer = false,
			skippable = false,
			
			{
				string = "You... You shouldn't be here.",
				wait = 2,
				anim = nil,
				sound = nil,
			},
			{
				string = "Really. Something is off in this universe.",
				wait = 1,
				anim = nil,
				sound = nil,
			},
		},
		
		--This is the speech where he asks for beefalo in exchange for magic beans.
		BEAN_QUEST =
		{
			disableplayer = false,
			skippable = true,
			
			{
				string = ("Hello there, %s."):format(char_desc),
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "You look tired.",
				wait = 2,
				anim = nil,
				sound = nil,
			},
			{
				string = "What if I told you I had something that could get you out?",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "That could whisk you away from this miserable plane?",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "Interested?",
				wait = 2,
				anim = nil,
				sound = nil,
			},
			{
				string = "Then let's make a deal.",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "I have need of a Beefalo.",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "Those hairy beasts you've seen roaming the grasslands.",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "Bring me one...",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = "...And I'll give you the ticket out.",
				wait = 3,
				anim = nil,
				sound = nil,
			},
			{
				string = ("Get to it, %s."):format(char_desc),
				wait = 2,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
			
		--This is for when a trade is successful.
		BEAN_SUCCESS =
		{
			
			disableplayer = false,
			skippable = false,
			
			{
				string = "You fulfilled your end of the bargain.",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "Now for me to keep mine.",
				wait = 2,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "Your ticket out of here.",
				wait = 2,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = ("Best of luck, %s."):format(char_desc),
				wait = 2,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
	
		--This is for when the player attacks the shopkeeper.
		--(the entity gets removed, it will never run!)
		HIT =
		{
			
			delay = 2,
			disableplayer = false,
			skippable = false,
			
			{
				string = "...",
				wait = 2,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
		
		--This is for when the player keeps bugging the shopkeeper about the beans.
		BEAN_REMINDER =
		{
			
			delay = 0.25,
			disableplayer = false,
			skippable = false,
			
			{
				string = ("Get to it, %s."):format(char_desc),
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
		
		--This is to flag the player down.
		FLAG_PLAYER =
		{
			
			delay = 0.25,
			disableplayer = false,
			skippable = true,
			
			{
				string = "Hey you! Yes, you there!",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
	
		--This gives the player a hint about the beans.
		BEANS_HINT =
		{
			
			delay = 0.25,
			disableplayer = false,
			skippable = true,
			
			{
				string = "Now, you can't just plant those beans in any old soil.",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "They require a powerful fertilizer.",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "Bonemeal, perhaps. A grave?",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "Then...",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
			{
				string = "...Just let the moon do the rest.",
				wait = 3,
				anim = nil,
				sound = "dontstarve/common/destroy_metal",
			},
		},
	}
end


return generateSpeeches
