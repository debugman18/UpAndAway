TheMod:AddPrefabPostInit({
    "walrus_camp",
    "pigking",
    "shopkeeper",
    "cave_entrance",
    "cave_exit",
    "beanstalk",
    "beanstalk_sapling",
    "beanstalk_exit",
    "adventure_portal",
    "wormhole",
    "wormhole_limited_1",
    "houndmound",
    "ancient_altar",
    "ancient_altar_broken",
}, function(inst)
    inst:AddTag("nonpackable")
end)
