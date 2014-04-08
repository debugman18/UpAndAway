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

	mushroom_hat = "Mushroom Hat",
    
    octocopter = "Octocopter",

    octocopter_wreckage = "Wrecked Octocopter",

    octocopterpart1 = "Rotor Blade",

    octocopterpart2 = "Rotor Plate",

    octocopterpart3 = "Rotor Hub",

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

    weavernest = "Weaver Nest",

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
<<<<<<< HEAD
    willow = "Half lion, half ant, all flammable.",
    wolfgang = "Is colorful hallucination.",
=======
    willow = "",
    wolfgang = "Is small now, big later.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "It's a little baby beanstalk.",
    wathgrithr = "",
}

Add.QuotesFor "beanstalk_chunk" {

    GENERIC = "Part of a beanstalk.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Piece of big plant.",
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
<<<<<<< HEAD
    willow = "It's like a living ball of fire!",
    wolfgang = "Is zappy, floaty pest.",
=======
    willow = "",
    wolfgang = "Is a long way down.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "That should be a statue of me. Or fire.",
    wolfgang = "Is big stone monster.",
=======
    willow = "",
    wolfgang = "Not enough for my mighty belly.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "The bigger they are... The better they burn!",
    wolfgang = "Not little plant at all!",
=======
    willow = "",
    wolfgang = "Not enough for my mighty belly.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "The wonder has been cooked out of them.",
    wathgrithr = "",
}

Add.QuotesFor "scarecrow" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "A trophy of slaughtered foes.",
    wolfgang = "Little plants gone.",
=======
    willow = "",
    wolfgang = "Does not scare Wolfgang!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "sheep" {

<<<<<<< HEAD
    GENERIC = "They seem pretty aggressive.",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "Reminds me of me, except I worship fire.",
    wolfgang = "Little plant is very angry!",
    woodie = "",
    wx78 = "",
=======
    GENERIC = "They make me feel sleepy.",
    waxwell = "It's cuteness disgusts me greatly.",
    wendy = " Ignorance. The worst kind of darkness.",
    wickerbottom = "Ovis Aris. Reminds me of farms.",
    willow = "Cotton. Very flammable.",
    wolfgang = "Little sheep is made of soft.",
    woodie = "Ooh! Lambchops!",
    wx78 = "DOCILE MAMMAL. HARD TO FRIGHTEN.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    webber = "How did it get up here?",
    wathgrithr = "",
}

Add.QuotesFor "sheep.ram" {

<<<<<<< HEAD
    GENERIC = "They exist as one, much unlike their mother.",
    waxwell = "I'd fancy some beans on toast now.",
    wendy = "",
    wickerbottom = "",
    willow = "Time for cooked beans.",
    wolfgang = "Little plant runs around.",
    woodie = "",
    wx78 = "",
=======
    GENERIC = "Electrifying!",
    waxwell = "The weather forecast shows a local storm.",
    wendy = "Their cup hath runneth over.",
    willow = "Shouldn't have charged him up.",
    wolfgang = "Sheep is mighty now!",
    woodie = "Looks like I'm in trouble now. Oops.",
    wx78 = "APPARENTLY EASY TO ANGER.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    webber = "Have you any wool?",
    wathgrithr = "",
}

Add.QuotesFor "shopkeeper" {

<<<<<<< HEAD
    GENERIC = "Part of a beanstalk.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "A torn piece of a Beanstalk.",
    wolfgang = "Piece of big plant.",
    woodie = "",
    wx78 = "",
=======
    GENERIC = "Odd place to set up a store.",
    waxwell = "I forgot to thank you for that book you sold me.",
    wendy = "A deceiver at heart.",
    wickerbottom = "Perhaps he has some books for sale.",
    willow = "I like the flag on his umbrella.",
    wolfgang = "Is talking umbrella.",
    woodie = "Men like this ran my lumber yard.",
    wx78 = "A PEDDLER OF GOODS.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    webber = "We've never seen him before.",
    wathgrithr = "",
}

Add.QuotesFor "skyflower" {

<<<<<<< HEAD
    GENERIC = "That's the way back to the ground.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "I wonder how long it would take for fire to reach the bottom?",
    wolfgang = "Is a long way down.",
    woodie = "",
    wx78 = "",
=======
    GENERIC = "They smell of dreams.",
    waxwell = "The urge of stomping on them is still present.",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "Their pollen smells different to each person. For me, it is like a new book.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    webber = "It smells like one of grandma's pies!",
    wathgrithr = "",
}

Add.QuotesFor "skyflower_petals" {

<<<<<<< HEAD
    GENERIC = "It's supposed to grow into a beanstalk.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "This will grow huge. Or burn quick.",
    wolfgang = "Is small now, big later.",
    woodie = "",
    wx78 = "",
=======
    GENERIC = "They smell of dreams.",
    waxwell = "I'll make a bouquet for Charlie with these.",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "Their pollen smells different to each person. For me, it is like a new book.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

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
<<<<<<< HEAD
    willow = "It's a bee. Made of marshmallow.",
    wolfgang = "Is bee or is not too bee? ",
=======
    willow = "",
    wolfgang = "What is creature? Where is from?",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I am a dark wizard now.",
    wolfgang = "Makes thunder.",
=======
    willow = "",
    wolfgang = "Is tough skin.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Stick them in boiling water. Or fire.",
    wolfgang = "Is for making drink.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I prefer Hot Chocolate.",
    wolfgang = "Is nearly as strong as me!",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

<<<<<<< HEAD
Add.QuotesFor "candy_fruit" {

    GENERIC = "Growable candy.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "It's sweet.",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cauldron" {
=======
Add.QuotesFor "cloud_fruit" {
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    GENERIC = "Cloud fruit. What else would it be?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Cauldron burn and boil and bubble.",
    wolfgang = "Is belong to witch?",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Plants. Great.",
    wolfgang = "Is plant-cloud.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_algae_fragment" {

    GENERIC = "Apparently algae grows on clouds.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "It's a bit of algae. Let's burn it.",
    wolfgang = "Is plant-cloud.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It has food. It can live a bit longer.",
    wolfgang = "Sweet food balls. Yum!",
=======
    willow = "",
    wolfgang = "Is a trap.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Coral. How interesting.",
    wolfgang = "Is plant-rock.",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_coral_fragment" {

    GENERIC = "A rock that grows.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "It's a bit of coral. Not burnable.",
    wolfgang = "Is plant-rock.",
=======
    willow = "",
    wolfgang = "Garden man lives?",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Cotton is very flammable. ",
    wolfgang = "Is for make clothes.",
=======
    willow = "",
    wolfgang = "Does things. Is always changing.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I bet it would smell nice while burning.",
    wolfgang = "Is growing without dirt. Is magic?",
=======
    willow = "",
    wolfgang = "Makes thunder.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "A Cloud Fruit a day keeps the Shopkeeper away.",
    wolfgang = "Fluffy plant. Still yummy.",
    woodie = "",
=======
    willow = "",
    wolfgang = "",
    woodie = "Is swarm of bugs. ",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "weaver_bird" {

    GENERIC = "It makes large nests to keep warm.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Cloud. Always cloud.",
    wolfgang = "Is soft ground.",
=======
    willow = "",
    wolfgang = "Is little birdie.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's more cloud.",
    wolfgang = "Is mound of cloud.",
=======
    willow = "",
    wolfgang = "Wolfgang has bean green before!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Something to eat while enjoying fire.",
    wolfgang = "Is tasty rock.",
=======
    willow = "",
    wolfgang = "Little plants gone.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "A tasty treat is second only to fire.",
    wolfgang = "Is like tasty cloud.",
=======
    willow = "",
    wolfgang = "Little plant runs around.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I should have burned that cotton.",
    wolfgang = "Soft on head.",
=======
    willow = "",
    wolfgang = "Little plant is very angry!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's warm, at least.",
    wolfgang = "Is comfy!",
=======
    willow = "",
    wolfgang = "Not little plant at all!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's dark. Fire is light. I know which is better.",
    wolfgang = "Is dark jewel.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Piece of crystal.",
    wolfgang = "Is cracked.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's slightly glowing.",
    wolfgang = "Is broken.",
=======
    willow = "",
    wolfgang = "Mean birds. More than tallest bird!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Someone broke it. Good.",
    wolfgang = "Is pebble.",
=======
    willow = "",
    wolfgang = "Why long bill? Wolfgang still funny.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Ancient junk.",
    wolfgang = "Is just a piece.",
=======
    willow = "",
    wolfgang = "So many claws.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "rainbowcoon" {

    GENERIC = "Colorful, but it's a ploy for my food.",
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
<<<<<<< HEAD
    willow = "Hah, it's broken! Good.",
    wolfgang = "Is smashed.",
=======
    willow = "",
    wolfgang = "Sweet food balls. Yum!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Smashed.",
    wolfgang = "Is not whole.",
=======
    willow = "",
    wolfgang = "Do I have to poop on it?",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I love lamps.",
    wolfgang = "Pretty rock makes light!",
=======
    willow = "",
    wolfgang = "Is not right.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It glows like fire.",
    wolfgang = "Is bright!",
=======
    willow = "",
    wolfgang = "It has many arms!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "octocopter_wreckage" {

    GENERIC = "Now it's mostly octopus.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "I wish rocks could burn.",
    wolfgang = "Is stone.",
=======
    willow = "",
    wolfgang = "Is broken!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "octocopterpart1" {

    GENERIC = "A rotor blade.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Broken ancient junk.",
    wolfgang = "Is old.",
=======
    willow = "",
    wolfgang = "Is for flying.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "octocopterpart2" {

    GENERIC = "A rotor plate.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "A big shiny rock.",
    wolfgang = "Is spiky, shiny rock.",
=======
    willow = "",
    wolfgang = "Soon Wolfgang flies.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "octocopterpart3" {

    GENERIC = "A rotor hub.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "I don't like water.",
    wolfgang = "Is pretty blue.",
=======
    willow = "",
    wolfgang = "Octopus needs this.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "White is boring. Red is better.",
    wolfgang = "Is blank. Like thoughts.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's cloud rock. Why is nothing in this place good to burn?",
    wolfgang = "Is rock and is cloud.",
=======
    willow = "",
    wolfgang = "Is bee or is not too bee? ",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Finally, decent fire material.",
    wolfgang = "Is good wood.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "thunder_tree" {

    GENERIC = "Looks fragile, but dangerous.",
    waxwell = "I was rather shocked the first time I discovered these.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "It's all sticky, ugh.",
    wolfgang = "Does not taste of blood.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Dragons and trees go together like a forest on fire.",
    wolfgang = "Strange tree.",
=======
    willow = "",
    wolfgang = "Is tickly to touch.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I want it as a pet.",
    wolfgang = "So many claws.",
=======
    willow = "",
    wolfgang = "Is mound of cloud.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "What an strange creature.",
    wolfgang = "Is fish out of water.",
=======
    willow = "",
    wolfgang = "Is big stone monster.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Will it hatch into a metal bird?",
    wolfgang = "Is not for eating.",
=======
    willow = "",
    wolfgang = "Pretty rock makes light!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Metal doesn't burn.",
    wolfgang = "Metal Giant!",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "The only music I like is the sound of fire burning.",
    wolfgang = "What pretty noises.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "No good to me.",
    wolfgang = "Is from shiny plant.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Roses have thorns. They're okay in my book.",
    wolfgang = "Shiny flower has sharp thorns.",
    woodie = "",
=======
    willow = "",
    wolfgang = "",
    woodie = "Little plant.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "weavernest" {

    GENERIC = "A warm nest made by birds.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "A bit of fire would spice those up.",
    wolfgang = "This grow big shiny plant.",
=======
    willow = "",
    wolfgang = "Bird lives here.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "jellyshroom_red" {

    GENERIC = "You jelly?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "It's nothing like the sun. Lame.",
    wolfgang = "Is big yellow flower.",
=======
    willow = "",
    wolfgang = "Is squeezy.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "jellyshroom_blue" {

    GENERIC = "You jelly?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "There's a goose on the loose.",
    wolfgang = "Egg is not tasty. Bird is though.",
=======
    willow = "",
    wolfgang = "Is squishy.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "jellyshroom_green" {

    GENERIC = "You jelly?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Hey, hands off!",
    wolfgang = "Is lazy thing.",
=======
    willow = "",
    wolfgang = "Is squidgy.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's bean fun.",
    wolfgang = "Wolfgang has bean green before!",
=======
    willow = "",
    wolfgang = "Is rock and is cloud.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "ball_lightning" {

    GENERIC = "A wandering ball of static.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Time for tea.",
    wolfgang = "Is not even green.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I could plant them. Or burn them.",
    wolfgang = "Is for blowy flower.",
=======
    willow = "",
    wolfgang = "Is soft ground.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It makes wind. Not a fan.",
    wolfgang = "Plant makes whoosh.",
=======
    willow = "",
    wolfgang = "Is old.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_relic" {

    GENERIC = "I get a weird feeling from that crystal.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Bees live there. I could smoke 'em out.",
    wolfgang = "Taste of bug.",
=======
    willow = "",
    wolfgang = "Is just a piece.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Boring. Let's burn something.",
    wolfgang = "Is squishy.",
=======
    willow = "",
    wolfgang = "Is pretty blue.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_water" {

    GENERIC = "It looks like it has water inside.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
    willow = "",
    wolfgang = "Is smashed.",
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
<<<<<<< HEAD
    willow = "Red is my favourite colour.",
    wolfgang = "Is squeezy.",
=======
    willow = "",
    wolfgang = "Is stone.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_quartz" {

    GENERIC = "I bet it conducts electricity.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "I could make a drink.",
    wolfgang = "Gets Wolfgang into hot water!",
=======
    willow = "",
    wolfgang = "Is pebble.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I could make a drink.",
    wolfgang = "Gets Wolfgang into hot water!",
=======
    willow = "",
    wolfgang = "Is dark jewel.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_black" {

    GENERIC = "It looks like there's a dark storm inside.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Mayybe lightning will strike it.",
    wolfgang = "Is for flying.",
=======
    willow = "",
    wolfgang = "Is cracked.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "What in the hell is that?",
    wolfgang = "Is not right.",
=======
    willow = "",
    wolfgang = "Is blank. Like thoughts.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_white" {

    GENERIC = "I feel lighter just being near it.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Those things can move?",
    wolfgang = "Garden man lives?",
=======
    willow = "",
    wolfgang = "Is not whole.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Ha, it has a big nose!",
    wolfgang = "Why long bill? Wolfgang still funny.",
=======
    willow = "",
    wolfgang = "Is bright!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_light" {

    GENERIC = "It glows with a strange light.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Magic doesn't stop fire.",
    wolfgang = "Not enough for my mighty belly.",
=======
    willow = "",
    wolfgang = "Is broken.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_spire" {

    GENERIC = "It's a large crystal.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "Magic doesn't stop fire.",
    wolfgang = "Not enough for my mighty belly.",
=======
    willow = "",
    wolfgang = "Is spiky, shiny rock.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "crystal_fragment_spire" {

    GENERIC = "It's a large crystal.",
    waxwell = "Dare I say they look crystal clear.",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "It's attracted to metal. I'm attracted to fire.",
    wolfgang = "",
=======
    willow = "",
    wolfgang = "Is shiny rock.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "refined_black_crystal" {

    GENERIC = "A large chunk of black crystal.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "It's a piece of skin. Hard to burn.",
    wolfgang = "Is tough skin.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "refined_white_crystal" {

    GENERIC = "A large chunk of white crystal.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "That's new.",
    wolfgang = "What is creature? Where is from?",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I eat mine charred.",
    wolfgang = "Is soft treat!",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's crashed. I might be able to fix it.",
    wolfgang = "Is broken!",
=======
    willow = "",
    wolfgang = "What pretty noises.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I've heard of flying pigs, but never flying octopi.",
    wolfgang = "It has many arms!",
=======
    willow = "",
    wolfgang = "Is not for eating.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I need this for flying.",
    wolfgang = "Is for flying.",
=======
    willow = "",
    wolfgang = "Shiny flower has sharp thorns.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "A part of a broken Octocopter.",
    wolfgang = "Soon Wolfgang flies.",
=======
    willow = "",
    wolfgang = "Is big yellow flower.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "The last piece of an Octocopter.",
    wolfgang = "Octopus needs this.",
=======
    willow = "",
    wolfgang = "This grow big shiny plant.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "A silent, deadly predator. Like me.",
    wolfgang = "Mean birds. More than tallest bird!",
=======
    willow = "",
    wolfgang = "Is from shiny plant.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}


Add.QuotesFor "colored_corn" {

    GENERIC = "Rainbow colored corn.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "What's in it? I hope it's fire.",
    wolfgang = "What is inside?",
=======
    willow = "",
    wolfgang = "Is tasty rock.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Touch my stuff and I'll burn you good!",
    wolfgang = "Is pretty, but food is mine!",
=======
    willow = "",
    wolfgang = "Is like tasty cloud.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's been improved. Fire would improve it more.",
    wolfgang = "Is better now.",
=======
    willow = "",
    wolfgang = "Is stretchy.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's good, but not as good as fire.",
    wolfgang = "Much nicer.",
=======
    willow = "",
    wolfgang = "Is fast air!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "You can't refine fire.",
    wolfgang = "Is to change stuff.",
    woodie = "",
=======
    willow = "",
    wolfgang = "",
    woodie = "Is belong to witch?",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "cloud_cotton" {

    GENERIC = "Like baby clouds.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "It shows me where clouds are, I guess.",
    wolfgang = "Finds clouds?",
=======
    willow = "",
    wolfgang = "Is for make clothes.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Smells bad when burning.",
    wolfgang = "Is stretchy.",
=======
    willow = "",
    wolfgang = "Soft on head.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Why scare crows when you can burn them?",
    wolfgang = "Does not scare Wolfgang!",
=======
    willow = "",
    wolfgang = "Is comfy!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

<<<<<<< HEAD
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

Add.QuotesFor "sky_chest" {

    GENERIC = "I wonder who's it is?",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "Put stuff in there and it stays there. It's magic.",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "skyflies" {
=======
Add.QuotesFor "package" {
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    GENERIC = "There's something in it.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "I prefer fireflies.",
    wolfgang = "",
    woodie = "Is swarm of bugs. ",
=======
    willow = "",
    wolfgang = "What is inside?",
    woodie = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

<<<<<<< HEAD
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

Add.QuotesFor "sky_lemur" {

    GENERIC = "",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
    willow = "Must be up to monkey business.",
    wolfgang = "",
    woodie = "",
    wx78 = "",

    webber = "",
    wathgrithr = "",
}

Add.QuotesFor "skytrap" {
=======
Add.QuotesFor "greentea" {
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13

    GENERIC = "A healthy green tea.",
    waxwell = "",
    wendy = "",
    wickerbottom = "",
<<<<<<< HEAD
    willow = "A trap with no fire is no trap at all.",
    wolfgang = "Is a trap.",
=======
    willow = "",
    wolfgang = "Is not even green.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "See, fire improves everything.",
    wolfgang = "Wolfgang is always ready for s'mores.",
=======
    willow = "",
    wolfgang = "Is nearly as strong as me!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "I could burn that.",
    wolfgang = "Get leaves, make drink.",
=======
    willow = "",
    wolfgang = "",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
    willow = " Leave me alone.",
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
<<<<<<< HEAD
    willow = "Will this even burn?",
    wolfgang = "Is tickly to touch.",
=======
    willow = "",
    wolfgang = "Is for making drink.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Why doesn't the lightning burn it?",
    wolfgang = "Is crackly tree.",
=======
    willow = "",
    wolfgang = "Is for flying.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's made of plant, and therefore I can burn it.",
    wolfgang = "Little plant.",
=======
    willow = "",
    wolfgang = "Gets Wolfgang into hot water!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It does stuff. Not burning, sadly.",
    wolfgang = "Is... technical.",
=======
    willow = "",
    wolfgang = "Gets Wolfgang into hot water!",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "Weave all the homes you want, I'll burn them all.",
    wolfgang = "Is little birdie.",
=======
    willow = "",
    wolfgang = "Is plant-cloud.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "A bird made it. ",
    wolfgang = "Bird lives here.",
=======
    willow = "",
    wolfgang = "Is plant-rock.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "It's made of wind, fire's frenemy.",
    wolfgang = "Is fast air!",
=======
    willow = "",
    wolfgang = "Finds clouds?",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
<<<<<<< HEAD
    willow = "You just can't get the staff any more.",
    wolfgang = "Does things. Is always changing.",
=======
    willow = "",
    wolfgang = "Is to change stuff.",
>>>>>>> cdeae0d863cb5ecd94b592d2674a671ce0f40f13
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
    wolfgang = "Is... technical.",
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
