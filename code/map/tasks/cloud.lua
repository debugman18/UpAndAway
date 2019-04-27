local LK = modrequire "map.lockandkey"


local KEYS, LOCKS = LK.SAFE_KEYS, LK.SAFE_LOCKS

-------------------------------------------------------------------------------

--Generic Biome
TheMod:AddTask("Cloud_Innocent_Generic_Biome", {
    locks = LOCKS.NONE,
    keys_given = {KEYS.FABLE_TECH, KEYS.CRAFTABLE_HEAT},

    room_choices={
        ["SkyflowerGarden"] = 1,
        ["SheepHerd"] = 1,
    },

    room_bg=GROUND.POOPCLOUD,
    background_room="BGCloud",
    colour={r=.2,g=.2,b=.2,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 10,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

TheMod:AddTask("Cloud_Generic_Biome", {
    locks = LOCKS.TIER1,
    keys_given = {KEYS.TIER2, KEYS.CRAFTABLE_HEAT},

    room_choices={
        ["SkyflowerGarden"] = math.random(1, 1),
        ["SheepHerd"] = 3,
        ["BushGarden"] = math.random(1, 4),
    },

    room_bg=GROUND.CLOUDSWIRL,
    background_room="BGCloud",
    colour={r=.2,g=.2,b=.2,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 4,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

TheMod:AddTask("Cloud_Sunflower_Biome", {
    locks = LOCKS.TIER1,
    keys_given = {KEYS.TIER2, KEYS.CRAFTABLE_HEAT},

    room_choices={
        ["SunflowerGarden"] = 1,
    },

    room_bg=GROUND.CLOUDLAND,
    background_room="BGCloud",
    colour={r=.2,g=.2,b=.2,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 0,
      -- Whether or not to connect the last node to the first
      make_loop = false, 
})

-------------------------------------------------------------------------------

--Snow Biome
TheMod:AddTask("Cloud_Innocent_Snow_Biome", {
    locks = {LOCKS.TIER1, LOCKS.HEAT},
    keys_given = {KEYS.TIER2, KEYS.SUSTAINABLE_HEAT},

    room_choices = {
        ["CragLanding"] = 2,
        ["Thunder_Forest"] = math.random(1, 2),
        ["Sea_Mimic"] = 1,
    },

    room_bg=GROUND.SNOW,
    background_room="BGSnow",
    colour={r=.8,g=.8,b=.8,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 4,
      -- Whether or not to connect the last node to the first
      make_loop = true,
})

TheMod:AddTask("Cloud_Snow_Biome", {
    locks = {LOCKS.TIER2, LOCKS.SUSTAINABLE_HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["Thunder_Forest"] = 2,
        ["Blob_Room"] = 2,
        ["Sea_Mimic"] = math.random(1, 2),
        ["CragLanding"] = math.random(1, 2),	
    },

    room_bg=GROUND.SNOWTWO,
    background_room="BGSnow",
    colour={r=.8,g=.8,b=.8,a=1},
      -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 0,
      -- Whether or not to connect the last node to the first
      make_loop = false,	
})

TheMod:AddTask("Gnome_Snow_Biome", {
    locks = {LOCKS.TIER2, LOCKS.SUSTAINABLE_HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["Gnome_Forest"] = 1, 
    },

    room_bg=GROUND.SNOW,
    background_room="BGSnow",
    colour={r=1,g=1,b=1,a=1},
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
        ["CragLanding"] = math.random(1, 2),
        ["SheepHerd"] = 1,
    },

    room_bg=GROUND.AURORA,
    background_room="BGAurora",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 2,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})


TheMod:AddTask("Cloud_Aurora_Biome", {
    locks = {LOCKS.TIER2, LOCKS.SUSTAINABLE_HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["CragLanding"] = 1,
        ["Beanlet_Den"] = 3,		
        ["Crystal_Fields"] = 1,		
        ["SheepHerd"] = 2,
        ["Bigbird_Nest"] = 1,
        ["Vine_Room"] = 3,  
        ["Blob_Room"] = 2,
    },

    room_bg=GROUND.AURORATWO,
    background_room="BGAurora",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 6,
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
        ["Crystal_Fields"] = 1,	
    },

    room_bg=GROUND.RAINBOW,
    background_room="BGRainbow",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 0,
      -- Whether or not to connect the last node to the first
      make_loop = false,	
})

TheMod:AddTask("Cloud_Rainbow_Biome", {
    locks = {LOCKS.TIER2, LOCKS.HEAT},
    keys_given = {KEYS.TIER3},

    room_choices={
        ["Fish_Fields"] = math.random(1, 2),
        ["Crystal_Fields"] = math.random(1, 2),	
        ["Sea_Mimic"] = math.random(1, 2),	
    },

    room_bg=GROUND.RAINBOWTWO,
    background_room="BGRainbow",
    colour={r=.8,g=.8,b=.8,a=1},
    -- The number of neighbors beyond the first that each node links to
      crosslink_factor = 2,
      -- Whether or not to connect the last node to the first
      make_loop = true,	
})

-------------------------------------------------------------------------------