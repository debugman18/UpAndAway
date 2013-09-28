--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local Add = modrequire 'lib.addstrings'

--This gives each prefab its own in-game name.

Add.Names {

    beanlet = "Beanlet",

    beanstalk = "Beanstalk",

    beanstalk_chunk = "Beanstalk Chunk",

    beanstalk_exit = "Beanstalk",

    beanstalk_wall = "Beanstalk Wall",

    bee_marshmallow = "Marshmallow Bee",

    candy_fruit = "Candy Fruit",

    cheshire_cat = "Cat",

    cloudcrag = "Cloudcrag",

    cloud_bomb = "Cloudbomb",

    cloud_bush = "Cloudbush",    

    cloud_cotton = "Cloud Cotton",

    cloud_fruit = "Cloudfruit",

    cloud_storage = "Cloud Chest",

    cloud_turf = "Cloud Turf",

    crystal_axe = "Axe of Storms",

    crystal_cap = "Crystal Cap",

    crystal_deposit = "Crystal Deposit",

    crystal_lamp = "Crystal Lamp",

    crystal_moss = "Crystal Moss",

    crystal_relic = "Crystal Relic",

    crystal_shard = "Crystal Shard",

    crystal_wall = "Crystal Wall",

    datura_petals = "Datura Petals",

    duckraptor = "Duckraptor",

    duckraptor_baby = "Duckling",

    duckraptor_mother = "Mother Duckraptor",

    flying_fish = "Flying Fish",

    golden_amulet = "Golden Amulet",

    golden_egg = "Golden Egg",

    golden_golem = "Golden Golem",

    golden_rose = "Golden Rose",

    golden_petals = "Golden Petals",

    goose = "Goose",

    hive_marshmallow = "Marshmallow",    

    kite = "Kite",

    lionant = "Lionant",

    lionblob = "Strange Blob",

    longbill = "Longbill",

    magic_beans = "Magic Beans",

    magic_beans_cooked = "Baked Beans",

    magic_bean_giant = "Bean Giant",

    magic_bean_sprout = "Bean Sprout",

    monolith = "Monolith",

    moonflower = "Moonflower",

    moonflower_seeds = "Moonflower Seeds",

    owl = "Strix",

    pineapple_bush = "Pineapple Bush",

    pineapple_fruit = "Pineapple",

    rainbowcoon = "Rainbowcoon",

    research_lectern = "Cumulocator Station",

    sheep = "Sheep",

    shopkeeper = "Shopkeeper",

    skyflower = "Skyflower",

    skyflower_petals = "Skyflower Petals",

    sunflower = "Golden Sunflower",

    sunflower_seeds = "Golden Sunflower Seeds",

    sky_chest = "Golden Chest",

    skyflies = "Lightning Bug",

    skylemur = "Sky Lemur",

    tree_thunder = "Thunder Tree",

    vine = "Beanstalk Vine",

    weather_machine = "Tropospherical Relay",

}

Add.QuotesFor "beanstalk" {

    GENERIC = "It reaches the clouds.",
    
    waxwell = "If only my brother Jack was here...",

    wendy = "All I'd need to do is let go.",
    
    wickerbottom = "The end of the stalk is covered by a layer of cumulonimbus clouds.",

    willow = "That would make a spectacular fire.",

    wolfgang = "Is big beanstalk. Reminds Wolfgang of home.",

    woodie = "Even Lucy can't chop through it.",

    wx78 = "IT HAS GROWN OUT OF CONTROL.",

}

Add.QuotesFor "hive_marshmallow" {

    GENERIC = "",

    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

}

Add.QuotesFor "magic_beans" {

    GENERIC = "",
    waxwell = "I hope the legends aren't full of beans.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Not enough for my mighty belly.",
    woodie = "",
    wx78 = "",

}

Add.QuotesFor "magic_beans_cooked" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

}

Add.QuotesFor "sheep" {

    GENERIC = "They make me feel sleepy.",
    waxwell = "It's cuteness disgusts me greatly.",
    wendy = " Ignorance. The worst kind of darkness.",
    wickerbottom = "Ovis Aris. Reminds me of farms.",
    willow = "Cotton. Very flammable.",
    wolfgang = "Little sheep is made of soft.",
    woodie = "Ooh! Lambchops!",
    wx78 = "DOCILE MAMMAL. HARD TO FRIGHTEN.",

}

Add.QuotesFor "sheep.ram" {

    GENERIC = "Electrifying!",
    waxwell = "The weather forecast shows a local storm.",
    wendy = "Their cup hath runneth over.",
    willow = "Shouldn't have charged him up.",
    wolfgang = "Sheep is mighty now!",
    woodie = "Looks like I'm in trouble now. Oops.",
    wx78 = "APPARENTLY EASY TO ANGER.",

}

Add.QuotesFor "shopkeeper" {

    GENERIC = "Odd place to set up a store.",
    waxwell = "I forgot to thank you for that book you sold me.",
    wendy = "A deceiver at heart.",
    wickerbottom = "Perhaps he has some books for sale.",
    willow = "I like the flag on his umbrella.",
    wolfgang = "Is talking umbrella.",
    woodie = "Men like this ran my lumber yard.",
    wx78 = "A PEDDLER OF GOODS.",

}

Add.QuotesFor "skyflower" {

    GENERIC = "They smell of dreams.",
    waxwell = "The urge of stomping on them is still present.",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "Their pollen smells different to each person. For me, it is like a new book.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",

}

Add.QuotesFor "skyflower_petals" {

    GENERIC = "They smell of dreams.",
    waxwell = "I'll make a bouquet for Charlie with these.",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "Their pollen smells different to each person. For me, it is like a new book.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",

}

Add.QuotesFor "skyflower.datura" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It smells like innocence. Ripe for the taking.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "datura_petals" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It smells like innocence. Ripe for the taking. ",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "antlion" {

    GENERIC = "It smells of nightmares.",
    waxwell = "Even my Tallbirds were a bigger success than this one.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "beanlet" {

    GENERIC = "It smells of nightmares.",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "magic_bean_giant" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It's not even worth a hill of beans.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "flying_fish" {

    GENERIC = "It smells of nightmares.",
    waxwell = "Being able to fly did not aid you at all.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "golden_golem" {

    GENERIC = "It smells of nightmares.",
    waxwell = "How intruiging.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "owl" {

    GENERIC = "It smells of nightmares.",
    waxwell = "These have a secret brotherhoot.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "longbill" {

    GENERIC = "It smells of nightmares.",
    waxwell = "With it's size it most likely has trouble ducking.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "duckraptor" {

    GENERIC = "It smells of nightmares.",
    waxwell = "You will make a rather exquisite duck pâté.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "rainbowcoon" {

    GENERIC = "It smells of nightmares.",
    waxwell = "The rainbow is trying to taste my food!",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "cloud_bush" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It needs manure, but where do I obtain that here?",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "marshmallow" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It smells like innocence. Ripe for the taking. ",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "tree_thunder" {

    GENERIC = "It smells of nightmares.",
    waxwell = "I was rather shocked the first time I discovered these.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "crystal_lamp" {

    GENERIC = "It smells of nightmares.",
    waxwell = "Even the light is crystal clear.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "cloud_turf" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It came from above.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "crystal_relic" {

    GENERIC = "It smells of nightmares.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "goose" {

    GENERIC = "It smells of nightmares.",
    waxwell = "For others a source of wealth, for me a source of annoyance.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "monolith" {

    GENERIC = "It smells of nightmares.",
    waxwell = "It's artistic value is greatly underrated.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "golden_lyre" {

    GENERIC = "It smells of nightmares.",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}

Add.QuotesFor "cotton_candy" {

    GENERIC = "It smells of nightmares.",
    waxwell = "A sugary delicacy for carnivals and common folk.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",

}