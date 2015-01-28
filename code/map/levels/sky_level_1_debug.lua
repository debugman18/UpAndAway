local LEVELTYPE = _G.LEVELTYPE

TheMod:AddLevel(LEVELTYPE.SURVIVAL, {
    id="SKY_LEVEL_1_DEBUG",
    name="Up and Away - Debug Level One",
    nomaxwell=true,
    desc="For biome testing only.",

    overrides={
        {"location",        "cave"},
        {"world_size",      "tiny"}, 

        {"day",             "onlydusk"}, 

        {"start_setpeice",  "BeanstalkTop"},                
        {"start_node",      "BeanstalkSpawn"},
    },
    
    tasks = {
        "Cloud_Innocent_Generic_Biome",
        "Cloud_Generic_Biome",
        --"Cloud_Innocent_Aurora_Biome",
        --"Cloud_Aurora_Biome",
        --"Cloud_Innocent_Rainbow_Biome",
        --"Cloud_Rainbow_Biome",
        --"Cloud_Innocent_Snow_Biome",
        --"Cloud_Snow_Biome",
    },
})