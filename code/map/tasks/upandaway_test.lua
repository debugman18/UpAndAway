TheMod:AddTask("UpAndAway_survival_preview_1", {
    locks = LOCKS.NONE,
    keys_given = {KEYS.TIER1},

    room_choices={
        ["BeefalowPlain"] = 2,
        ["Graveyard"] = 1,
    },

    room_bg=GROUND.GRASS,
    background_room="BGGrass",
    colour={r=.05,g=.5,b=.05,a=1},
})

TheMod:AddTask("UpAndAway_survival_preview_2", {
    locks = LOCKS.TIER1,
    keys_given = {},

    room_choices={
        ["Clearing"] = math.random(1, 2),
        ["MandrakeHome"] = math.random(1, 2),
        ["Forest"] = 1,
    },

    room_bg=GROUND.GRASS,
    background_room="BGGrass",
    colour={r=.05,g=.5,b=.05,a=1},
})

TheMod:AddTask("UpAndAway_survival_preview_3", {
    locks = LOCKS.TIER1,
    keys_given = {},

    room_choices={
        ["Clearing"] = 1,
        ["MandrakeHome"] = math.random(1, 2),
        ["Forest"] = math.random(0, 1),
    },

    room_bg=GROUND.GRASS,
    background_room="BGGrass",
    colour={r=.05,g=.5,b=.05,a=1},
})
