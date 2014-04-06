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

    blackstaff = "Black Staff",

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

    whitestaff = "White Staff",

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

    GENERIC = "It's supposed to grow into a beanstalk.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is small now, big later.",
    woodie = "",
    wx78 = "",

    webber = "It's a little baby beanstalk.",
    wathgrithr = "",
}

Add.QuotesFor "beanstalk_exit" {

    GENERIC = "That's the way back to the ground.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is a long way down.",
    woodie = "",
    wx78 = "",

    webber = "Don't look down, don't look down.",
    wathgrithr = "",
}

Add.QuotesFor "magic_beans" {

    GENERIC = "Oldest marketing scam in the book!",
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

    GENERIC = "I don't even know why I did that.",
    waxwell = "I guess we'll never know if they were real or not.",
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

    GENERIC = "What sick breeding produced this?",
    waxwell = "Even my Tallbirds were a bigger success than this one.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is cat? Is bug? Is catbug.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "manta" {

    GENERIC = "Aren't you supposed to be in the ocean?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "What is creature? Where is from?",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "manta_leather" {

    GENERIC = "Skin from a flying manta.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is tough skin.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "magnet" {

    GENERIC = "It's quite magnetic.",
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

Add.QuotesFor "cloud_fruit_tree" {

    GENERIC = "It has a strange fruit on it.",
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

Add.QuotesFor "cloud_fruit" {

    GENERIC = "Cloud fruit. What else would it be?",
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

Add.QuotesFor "gustflower" {

    GENERIC = "I should steer clear of it.",
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

Add.QuotesFor "gustflower_seeds" {

    GENERIC = "I can plant this somewhere.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is for blowy flower.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "skytrap" {

    GENERIC = "Something about that flower is off.",
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

Add.QuotesFor "live_gnome" {

    GENERIC = "Is that a gnome?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Garden man lives?",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "whitestaff" {

    GENERIC = "Packages objects through magic.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Does things. Is always changing.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blackstaff" {

    GENERIC = "You can charge things with magic.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Makes thunder.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "skyflies" {

    GENERIC = "I wonder how they light up like that?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "Is swarm of bugs. ",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "weaver_bird" {

    GENERIC = "It makes large nests to keep warm.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is little birdie.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "greenbean" {

    GENERIC = "Green and nutricious.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Wolfgang has bean green before!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "beanlet_shell" {

    GENERIC = "A husk of a bean monster.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Little plants gone.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "beanlet" {

    GENERIC = "They exist as one, much unlike their mother.",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Little plant runs around.",
    woodie = "",
    wx78 = "",

    webber = "Adorable, but not very tasty.",
    wathgrithr = "",
}

Add.QuotesFor "beanlet_zealot" {

    GENERIC = "They seem pretty aggressive.",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Little plant is very angry!",
    woodie = "",
    wx78 = "",

    webber = "You don't want to play?",
    wathgrithr = "",
}

Add.QuotesFor "bean_giant" {

    GENERIC = "Someone must bring an end to this reign of giants!",
    waxwell = "It's not even worth a hill of beans.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Not little plant at all!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "flying_fish" {

    GENERIC = "But do they have lungs?",
    waxwell = "Being able to fly did not aid you at all.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
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
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "owl" {

    GENERIC = "Their eyes are unsettling...",
    waxwell = "These have a secret brotherhoot.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Mean birds. More than tallest bird!",
    woodie = "",
    wx78 = "",

    webber = "What big eyes they have!",
    wathgrithr = "",
}

Add.QuotesFor "longbill" {

    GENERIC = "Are those claws on its wings?",
    waxwell = "With it's size it most likely has trouble ducking.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Why long bill? Wolfgang still funny.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "duckraptor" {

    GENERIC = "A nightmare duck! What next?",
    waxwell = "You will make a rather exquisite duck pâté.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "rainbowcoon" {

    GENERIC = "It's a sneaky little animal.",
    waxwell = "The rainbow is trying to taste my food!",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is pretty, but food is mine!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_bush" {

    GENERIC = "All plants produce simple sugars.",
    waxwell = "Heavenly treats await me.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Sweet food balls. Yum!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_bush.picked" {

    GENERIC = "No more sugar for me.",
    waxwell = "It needs manure, but where do I obtain that here?",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Do I have to poop on it?",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "lionblob" {

    GENERIC = "Is that supposed to be a joke?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is not right.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "octocopter" {

    GENERIC = "Half machine, half octopus.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "It has many arms!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "hive_marshmallow" {

    GENERIC = "A giant marshmallow.",
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

Add.QuotesFor "bee_marshmallow" {

    GENERIC = "A flying marshmallow.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is bee or is not too bee? ",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}


Add.QuotesFor "marshmallow" {

    GENERIC = "Maybe just one. For science!",
    waxwell = "Contrary to the name, these do not contain marsh.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is soft treat!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "smores" {

    GENERIC = "A messy ball of chocolate and cream.",
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

    GENERIC = "Looks fragile, but dangerous.",
    waxwell = "I was rather shocked the first time I discovered these.",
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

    GENERIC = "It ripples with elecricity.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is tickly to touch.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloudcrag" {

    GENERIC = "Super condensed cloud.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is mound of cloud.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "bean_giant_statue" {

    GENERIC = "I wouldn't want to run into that thing.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is big stone monster.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_lamp" {

    GENERIC = "It's magically lit by crystals.",
    waxwell = "Even the light is crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Pretty rock makes light!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "dragonblood_tree" {

    GENERIC = "I wonder if it breathes fire?",
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

    GENERIC = "Warm, gooey tree sap.",
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

    GENERIC = "It emits a slight warmth.",
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

    GENERIC = "A sentient vine!",
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

Add.QuotesFor "cumulostone" {

    GENERIC = "A rock that seems to pulse with light.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is rock and is cloud.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_turf" {

    GENERIC = "The ground... Err, cloud beneath my feet.",
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

    GENERIC = "I get a weird feeling from that crystal.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_water" {

    GENERIC = "It looks like it has water inside.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_quartz" {

    GENERIC = "I bet it conducts electricity.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_black" {

    GENERIC = "It looks like there's a dark storm inside.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_white" {

    GENERIC = "I feel lighter just being near it.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_light" {

    GENERIC = "It glows with a strange light.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "goose" {

    GENERIC = "I wonder if it lays golden eggs?",
    waxwell = "For others a source of wealth, for me a source of annoyance.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "monolith" {

    GENERIC = "What is this? A giant golden potato?",
    waxwell = "It's artistic value is greatly underrated.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is...art?",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_lyre" {

    GENERIC = "A boring golden harp.",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_egg" {

    GENERIC = "It's warm. And gold. Mostly gold.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is not for eating.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_rose" {

    GENERIC = "A rose with golden petals.",
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

Add.QuotesFor "golden_sunflower" {

    GENERIC = "A sunflower made of gold.",
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

Add.QuotesFor "golden_sunflower_seeds" {

    GENERIC = "I can make a gold farm!",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "This grow big shiny plant.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "golden_petals" {

    GENERIC = "Golden flower petals.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is from shiny plant.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cotton_candy" {

    GENERIC = "A bunch of fluffy sugar.",
    waxwell = "A sugary delicacy for carnivals and common folk.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "rubber" {

    GENERIC = "It doesn't conduct electricity very well.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is stretchy.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "whirlwind" {

    GENERIC = "Who knows where that thing could send me.",
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

Add.QuotesFor "cauldron" {

    GENERIC = "A big bucket for magic stuff.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "",
    woodie = "Is belong to witch?",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_cotton" {

    GENERIC = "Like baby clouds.",
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

Add.QuotesFor "cotton_hat" {

    GENERIC = "A warm, fluffy cotton hat.",
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

Add.QuotesFor "cotton_vest" {

    GENERIC = "It's silly looking, but very warm.",
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

    GENERIC = "There's something in it.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "What is inside?",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "greentea" {

    GENERIC = "A healthy green tea.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is not even green.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blacktea" {

    GENERIC = "It's a nice strong tea.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is nearly as strong as me!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "tea_bush" {

    GENERIC = "Tea leave grow on this bush.",
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

    GENERIC = "Regular old tea leaves.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Put in water.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "blacktea_leaves" {

    GENERIC = "Oxidized tea leaves.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is for making drink.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "kite" {

    GENERIC = "Cloth tied to a string.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is for flying.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "kettle" {

    GENERIC = "A kettle, for brewing tea.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Gets Wolfgang into hot water!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "kettle_item" {

    GENERIC = "A kettle, for brewing tea.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Gets Wolfgang into hot water!",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_algae" {

    GENERIC = "Apparently algae grows on clouds.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is plant-cloud.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_coral" {

    GENERIC = "A rock that grows.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is plant-rock.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "research_lectern" {

    GENERIC = "I'm not even sure what's real anymore.",
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

Add.QuotesFor "refiner" {

    GENERIC = "A refiner. It crushes things into pieces.",
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

Add.QuotesFor "weather_machine" {

    GENERIC = "It's not a very consistent weather machine.",
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
