local Add = modrequire 'lib.addstrings'

--This gives each prefab its own in-game name.

Add.Names {

	alien = "Aurora",

    ball_lightning = "Ball Lightning",
	
	balloon_hound = "Balloon Hound",

    bean_giant = "Bean Giant",    

    bean_giant_statue = "Giant Statue",

    beanlet = "Beanlet",
    
    beanlet_shell = "Beanlet Shell",
    
    beanlet_zealot = "Zealot Beanlet",
    
    beanstalk = "Giant Beanstalk",

    beanstalk_sapling = "Beanstalk Sapling",

    beanstalk_chunk = "Beanstalk Chunk",

    beanstalk_exit = "Beanstalk Tip",

    beanstalk_wall = "Beanstalk Wall",

    bee_marshmallow = "Marshmallow Bee",

    bird_paradise = "Bird of Paradise",

    blackstaff = "Black Staff"

    candy_fruit = "Candy Fruit",

    cauldron = "Cauldron",

    cheshire = "Cat",
    
    chimera = "Chimera",

    cloudcrag = "Cloudcrag",
    
    cloud_algae = "Cloud Algae",
    
    cloud_algae_fragment = "Cloud Algae",

    cloud_bomb = "Cloudbomb",

    cloud_bush = "Cloudbush",    
    
    cloud_coral = "Cloud Coral",
    
    cloud_coral_fragment = "Cloud Coral",

    cloud_cotton = "Cloud Cotton",

    cloud_fruit_tree = "Cloudfruit Tree",

    cloud_fruit = "Cloud Fruit",

    cloud_storage = "Cloud Chest",

    cloud_turf = "Cloud Turf",

    cloud_wall = "Cloud Wall",

    colored_corn = "Rainbow Gem Corn",

    cotton_candy = "Cotton Candy",

    cotton_hat = "Cotton Hat",

    cotton_vest = "Cotton Vest",
    
    crystal_armor = "Crystal Armor",

    crystal_axe = "Axe of Storms",
    
    crystal_black = "Black Crystal",

    crystal_fragment_black = "Black Crystal Fragment",

    crystal_cap = "Crystal Cap",

    crystal_fragment_spire = "Spire Crystal Shard",    

    crystal_lamp = "Crystal Lamp",

    crystal_light = "Light Crystal",

    crystal_fragment_light = "Light Crystal Fragment",

    crystal_quartz = "Quartz Crystal",

    crystal_fragment_quartz = "Quartz Crystal Fragment",

    crystal_relic = "Crystal Relic",

    crystal_fragment_relic = "Crystal Relic Fragment",
    
    crystal_spire = "Crystal Spire",

    crystal_wall = "Crystal Wall",

    crystal_water = "Water Crystal",

    crystal_fragment_water = "Water Crystal Fragment",
    
    crystal_white = "White Crystal",

    crystal_fragment_white = "White Crystal Fragment",

    cumulostone = "Cumolostone",

    datura_petals = "Datura Petals",

    dragonblood_sap = "Dragonblood Sap",

    dragonblood_tree = "Dragonblood Tree",

    dragonblood_log = "Dragonblood Log",

    duckraptor = "Duckraptor",

    flying_fish = "Flying Fish",
    
    flying_fish_pond = "Flying Fish Pond",

    golden_amulet = "Golden Amulet",

    golden_egg = "Golden Egg",

    golden_golem = "Golden Golem",

    golden_lyre = "Golden Harp",

    golden_rose = "Golden Rose",

    golden_sunflower = "Golden Sunflower",

    golden_sunflower_seeds = "Golden Sunflower Seeds",

    golden_petals = "Golden Petals",

    goose = "Goose",
    
    grabber = "Grabber",
    
    greenbean = "Greenbean",

    gustflower = "Gustflower",

    gustflower_seeds = "Gustflower Seeds",

    hive_marshmallow = "Marshmallow",   
    
    jellyshroom_blue = "Blue Jellyshroom",

    jellyshroom_green = "Green Jellyshroom",

    jellyshroom_red = "Red Jellyshroom",

    kite = "Kite",
    
    live_gnome = "Gnome",

    lionant = "Lionant",

    lionblob = "Strange Blob",

    longbill = "Longbill",

    magnet = "Mag Net",

    magic_beans = "Magic Beans",

    magic_beans_cooked = "Baked Beans",
    
    manta = "Manta",
    
    manta_leather = "Manta Leather",

    marshmallow = "Marshmallow",

    monolith = "Monolith",
    
    octocopter = "Octocopter",

    owl = "Strix",

    package = "Unknown Package",

    pineapple_bush = "Pineapple Bush",

    pineapple_fruit = "Pineapple",
    
    quartz_torch = "Quartz Torch",

    rainbowcoon = "Rainbowcoon",
    
    refiner = "Refiner",
    
    research_lectern = "Cumulocator Station",

    rubber = "Rubber",
    
    scarecrow = "Scarecrow",

    sheep = "Sheep",

    shopkeeper = "Shopkeeper",

    skyflower = "Skyflower",

    skyflower_petals = "Skyflower Petals",

    skytrap = "Skytrap",
    
    smores = "S'mores",

    sky_chest = "Eldrichest",

    skyflies = "Lightning Bug",

    sky_lemur = "Lemur",

    thunder_tree = "Thunder Tree",

    thunder_log = "Thunder Log",

    vine = "Vine",

    weaver_bird = "Weaver Bird",

    weaver_nest = "Weaver Nest",

    weather_machine = "Tropospherical Relay",

    whirlwind = "Whirlwind",

    whitestaff = "White Staff"

    winnie_staff = "Shepherd's Staff",

	--[[
	-- Tea stuff.
	--]]
	
	greentea = "Green Tea",

	blacktea = "Black Tea",

	tea_leaves = "Tea Leaves",

	blacktea_leaves = "Black Tea Leaves",

	tea_bush = "Tea Bush",

	kettle = "Kettle",

	kettle_item = "Kettle",

    -- Balloon Hounds.

	[{"balloon_hound", "balloon_icehound", "balloon_firehound"}] = function(prefab)
		local suf = prefab:match("^BALLOON_(.+)$")
		return STRINGS.NAMES[suf]
	end,
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

    webber = "We can't even see the top of it.",
    wathgrithr = "",
}

Add.QuotesFor "beanstalk_sapling" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "It's a little baby beanstalk.",
    wathgrithr = "",
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

    webber = "I wonder what wonders it contains.",
    wathgrithr = "",
}

Add.QuotesFor "magic_beans_cooked" {

    GENERIC = "",
    waxwell = "I hope the legends aren't full of beans.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Not enough for my mighty belly.",
    woodie = "",
    wx78 = "",

    webber = "The wonder has been cooked out of them.",
    wathgrithr = "",
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

    webber = "How did it get up here?",
    wathgrithr = "",
}

Add.QuotesFor "sheep.ram" {

    GENERIC = "Electrifying!",
    waxwell = "The weather forecast shows a local storm.",
    wendy = "Their cup hath runneth over.",
    willow = "Shouldn't have charged him up.",
    wolfgang = "Sheep is mighty now!",
    woodie = "Looks like I'm in trouble now. Oops.",
    wx78 = "APPARENTLY EASY TO ANGER.",

    webber = "Have you any wool?",
    wathgrithr = "",
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

    webber = "We've never seen him before.",
    wathgrithr = "",
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

    webber = "It smells like one of grandma's pies!",
    wathgrithr = "",
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

    webber = "It smells like one of grandma's pies!",
    wathgrithr = "",
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

    webber = "It makes us feel strange things.",
    wathgrithr = "",
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

    webber = "It makes us feel strange things.",
    wathgrithr = "",
}

Add.QuotesFor "antlion" {

    GENERIC = "",
    waxwell = "Even my Tallbirds were a bigger success than this one.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "manta" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_fruit_tree" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_fruit" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "gustflower" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "gustflower_seeds" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "skytrap" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "live_gnome" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "whitestaff" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blackstaff" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "beanlet" {

    GENERIC = "",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "Adorable, but not very tasty.",
    wathgrithr = "",
}

Add.QuotesFor "beanlet_zealot" {

    GENERIC = "",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "You don't want to play?",
    wathgrithr = "",
}

Add.QuotesFor "bean_giant" {

    GENERIC = "",
    waxwell = "It's not even worth a hill of beans.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "flying_fish" {

    GENERIC = "",
    waxwell = "Being able to fly did not aid you at all.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "I thought grandpa was joking about fish that fly.",
    wathgrithr = "",
}

Add.QuotesFor "golden_golem" {

    GENERIC = "",
    waxwell = "How intruiging.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "owl" {

    GENERIC = "",
    waxwell = "These have a secret brotherhoot.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "What big eyes they have!",
    wathgrithr = "",
}

Add.QuotesFor "longbill" {

    GENERIC = "",
    waxwell = "With it's size it most likely has trouble ducking.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "duckraptor" {

    GENERIC = "",
    waxwell = "You will make a rather exquisite duck pâté.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "rainbowcoon" {

    GENERIC = "",
    waxwell = "The rainbow is trying to taste my food!",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_bush" {

    GENERIC = "",
    waxwell = "It needs manure, but where do I obtain that here?",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
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

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "marshmallow" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "tree_thunder" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "thunder_log" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "dragonblood_tree" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "dragonblood_sap" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "dragonblood_log" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_lamp" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "vine" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_turf" {

    GENERIC = "",
    waxwell = "It came from above.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_relic" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_water" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_quartz" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_black" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_white" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_light" {

    GENERIC = "",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "goose" {

    GENERIC = "",
    waxwell = "For others a source of wealth, for me a source of annoyance.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "monolith" {

    GENERIC = "",
    waxwell = "It's artistic value is greatly underrated.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_lyre" {

    GENERIC = "",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_egg" {

    GENERIC = "",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_rose" {

    GENERIC = "",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cotton_candy" {

    GENERIC = "",
    waxwell = "A sugary delicacy for carnivals and common folk.",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "whirlwind" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "package" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",,
    wolfgang = "",,
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "greentea" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blacktea" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "tea_bush" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "tea_leaves" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blacktea_leaves" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "kettle" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "kettle_item" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor {"balloon_hound", "balloon_icehound", "balloon_firehound"} {
	ANY = function(character, prefab)
		local suf = prefab:match("^BALLOON_(.+)$")
		return STRINGS.CHARACTERS[character].DESCRIBE[suf]
	end,
}

STRINGS.CHARACTER_TITLES.winnie = "The Curious"
STRINGS.CHARACTER_NAMES.winnie = "Winnie"
STRINGS.CHARACTER_DESCRIPTIONS.winnie = "*Is a vegetarian\n*Has a green thumb"
STRINGS.CHARACTER_QUOTES.winnie = "'Where are you, little sheep?'"
STRINGS.CHARACTERS.WINNIE = {}
STRINGS.CHARACTERS.WINNIE.DESCRIBE = {}
STRINGS.CHARACTERS.WINNIE.DESCRIBE.GENERIC = "I don't have strings yet."

STRINGS.ACTIONS.DEPLOY.PORTABLE_STRUCTURE = "Place"

STRINGS.RECIPE_DESC.COTTON_VEST = "A warm cotton vest. It falls apart in the rain."
STRINGS.RECIPE_DESC.CRYSTAL_LAMP = "A lamp made from the shell of a monster. Fancy!"
STRINGS.RECIPE_DESC.WEATHER_MACHINE = "It can almost control the weather."
STRINGS.RECIPE_DESC.COTTON_HAT = "A warm cotton hat. It falls apart in the rain."
STRINGS.RECIPE_DESC.RESEARCH_LECTERN = "It holds knowledge from far away lands."
STRINGS.RECIPE_DESC.MAGNET = "It's a magnet fueled by magic."
STRINGS.RECIPE_DESC.COTTON_CANDY = "Carnival food. Rots your teeth."
STRINGS.RECIPE_DESC.GRABBER = "A hookshot. You can grab and poke things."
STRINGS.RECIPE_DESC.BLACKSTAFF = "A black staff. Shock therapy!"
STRINGS.RECIPE_DESC.WHITESTAFF = "A white staff. For heavy lifting."

STRINGS.UPUI = {
	CLOUDGEN = {
		VERBS = 
		{
			"Deploying",
			"Decompressing",
			"Herding",
			"Replacing",
			"Assembling",
			"Insinuating",
			"Reticulating",
			"Inserting",
			"Framing",
		},
		
		NOUNS=
		{
			"clouds",
			"sheep",
			"candy",
			"giants",
			"snowflakes",
			"skeletons",
			"static batteries",
			"castles",
			"beans",
			"nature",		
		},
	},
}	


--------------------------------------------------------------------------
-- This cleans up the memory used by the temporary objects above.
--------------------------------------------------------------------------
_G.collectgarbage("step")
