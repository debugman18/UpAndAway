local LK = modrequire "map.lockandkey"


local KEYS, LOCKS = LK.SAFE_KEYS, LK.SAFE_LOCKS

-------------------------------------------------------------------------------

--Generic Biome
TheMod:AddTask("Cloud_Innocent_Generic_Biome", {
    locks = LOCKS.NONE,
    keys_given = {KEYS.FABLE_TECH, KEYS.CRAFTABLE_HEAT},

    room_choices={
        ["SkyflowerGarden"] = math.random(1, 1),
        ["SheepHerd"] = math.random(0, 1),
        ["BushGarden"] = math.random(1, 2),
        ["Sea_Mimic"] = math.random(0, 1),	
    },

    room_bg=GROUND.POOPCLOUD,
    background_room="BGCloud",
    colour={r=.2,g=.2,b=.2,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 5,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

TheMod:AddTask("Cloud_Generic_Biome", {
    locks = LOCKS.TIER1,
    keys_given = {KEYS.TIER2, KEYS.CRAFTABLE_HEAT},

    room_choices={
        ["SkyflowerGarden"] = math.random(1, 1),
        ["SheepHerd"] = math.random(1, 3),
        ["BushGarden"] = math.random(1, 4),
        ["Sea_Mimic"] = math.random(1, 2),	
    },

    room_bg=GROUND.POOPCLOUD,
    background_room="BGCloud",
    colour={r=.2,g=.2,b=.2,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 4,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

-------------------------------------------------------------------------------

--Snow Biome
TheMod:AddTask("Cloud_Innocent_Snow_Biome", {
    locks = {LOCKS.TIER1, LOCKS.HEAT},
    keys_given = {KEYS.TIER2, KEYS.SUSTAINABLE_HEAT},

    room_choices = {
        ["CragLanding"] = math.random(1, 2),
        ["Thunder_Forest"] = math.random(1, 2),
        ["Sea_Mimic"] = math.random(0, 1),
    },

    room_bg=GROUND.FUNGUS,
    background_room="BGSnow",
    colour={r=.8,g=.8,b=.8,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 4,
      -- Whether or not to connect the last node to the first
      make_loop = false,
})

TheMod:AddTask("Cloud_Snow_Biome", {
    locks = {LOCKS.TIER2, LOCKS.SUSTAINABLE_HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["Thunder_Forest"] = math.random(2, 2),
        ["Manta_Room"] = math.random(2, 2),
        ["Sea_Mimic"] = math.random(1, 2),
        ["CragLanding"] = math.random(1, 2),	
    },

    room_bg=GROUND.FUNGUS,
    background_room="BGSnow",
    colour={r=.8,g=.8,b=.8,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 4,
      -- Whether or not to connect the last node to the first
      make_loop = false,	
})

-------------------------------------------------------------------------------

--Aurora Biome
TheMod:AddTask("Cloud_Innocent_Aurora_Biome", {
    locks = {LOCKS.TIER1, LOCKS.HEAT},
    keys_given = {KEYS.TIER2, KEYS.SUSTAINABLE_HEAT},

    room_choices={
        ["Bigbird_Nest"] = math.random(1, 2),	
        ["CragLanding"] = math.random(1, 2),
        ["Vine_Room"] = math.random(0, 1),
        ["Crystal_Fields"] = math.random(0, 1),		
        ["SheepHerd"] = math.random(0, 1),
    },

    room_bg=GROUND.GRASS,
    background_room="BGAurora",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 0,
      -- Whether or not to connect the last node to the first
      make_loop = false,	
})


TheMod:AddTask("Cloud_Aurora_Biome", {
    locks = {LOCKS.TIER2, LOCKS.SUSTAINABLE_HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["CragLanding"] = math.random(0, 1),
        ["Vine_Room"] = math.random(1, 2),
        ["Beanlet_Den"] = math.random(1, 2),		
        ["Crystal_Fields"] = math.random(2, 2),		
        ["SheepHerd"] = math.random(1, 2),
        ["Bigbird_Nest"] = math.random(1, 1),
        ["Vine_Room"] = math.random(2, 2),  
    },

    room_bg=GROUND.GRASS,
    background_room="BGAurora",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 0,
      -- Whether or not to connect the last node to the first
      make_loop = false,	
})

-------------------------------------------------------------------------------

--Rainbow Biome
TheMod:AddTask("Cloud_Innocent_Rainbow_Biome", {
    locks = {LOCKS.TIER1, LOCKS.HEAT},
    keys_given = {KEYS.TIER2},

    room_choices={
        ["Rainbow_Room"] = math.random(1, 2),
        ["Fish_Fields"] = math.random(1, 2),
        ["Crystal_Fields"] = math.random(0, 1),	
        ["Sea_Mimic"] = math.random(0, 1),	
    },

    room_bg=GROUND.MARSH,
    background_room="BGRainbow",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 2,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

TheMod:AddTask("Cloud_Rainbow_Biome", {
    locks = {LOCKS.TIER2, LOCKS.HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["Rainbow_Room"] = math.random(0, 1),
        ["Fish_Fields"] = math.random(1, 2),
        ["Crystal_Fields"] = math.random(1, 2),	
        ["Sea_Mimic"] = math.random(1, 2),	
    },

    room_bg=GROUND.MARSH,
    background_room="BGRainbow",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 2,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

-------------------------------------------------------------------------------