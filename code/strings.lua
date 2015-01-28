local Add = modrequire "lib.addstrings"

-- Winnie stuff.
--
-- Added early so it doesn't override strings added below.

STRINGS.CHARACTER_TITLES.winnie = "The Shepherd"
STRINGS.CHARACTER_NAMES.winnie = "Winnie"
STRINGS.CHARACTER_DESCRIPTIONS.winnie = "*Dislikes meat\
*Has a green thumb\
*Is not so innocent"
STRINGS.CHARACTER_QUOTES.winnie = "\"Stay near me, little sheep.\""

STRINGS.CHARACTERS.WINNIE = modrequire "speech_winnie"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINNIE = 
{
    GENERIC = "It's Winnie!",
    ATTACKER = "She has a scary look in her eyes.",
    MURDERER = "Murderer!",
    REVIVER = "She's not so bad.",
    GHOST = "Winnie could use a heart.",
}


--This gives each prefab its own in-game name.

Add.Names {
    alien = "Aurora",
    ambrosia = "Ambrosia",
    antlion = "Antlion",
    ball_lightning = "Ball Lightning",
    balloon_firehound = "Red Hound",
    balloon_hound = "Hound",
    balloon_icehound = "Blue Hound",
    beanlet = "Beanlet",
    beanlet_armor = "Beanlet Armor",
    beanlet_hut = "Flower Hut",
    beanlet_shell = "Beanlet Shell",
    beanlet_zealot = "Zealot Beanlet",
    beanstalk = "Giant Beanstalk",
    beanstalk_chunk = "Beanstalk Chunk",
    beanstalk_exit = "Beanstalk Tip",
    beanstalk_sapling = "Beanstalk Sapling",
    beanstalk_wall = "Beanstalk Wall",
    beanstalk_wall_item = "Beanstalk Wall",
    bee_marshmallow = "Marshmallow Bee",
    bird_paradise = "Bird of Paradise",
    blackstaff = "Black Staff",
    blacktea = "Black Tea",
    blacktea_leaves = "Black Tea Leaves",
    candy_fruit = "Candy Fruit",
    cauldron = "Cauldron",
    cheshire = "Cat",
    chimera = "Chimera",
    cloud_algae = "Cloudy Algae",
    cloud_algae_fragment = "Cloudy Algae",
    cloud_bomb = "Cloudbomb",
    cloud_bush = "Cloudbush",
    cloud_coral = "Cloudy Coral",
    cloud_coral_fragment = "Cloudy Coral",
    cloud_cotton = "Cloud Cotton",
    cloud_fruit = "Cloud Fruit",
    cloud_fruit_cooked = "Cooked Cloud Fruit",
    cloud_fruit_tree = "Cloudfruit Tree",
    cloud_jelly = "Cloud Jelly",
    cloud_storage = "Cloud Chest",
    cloud_turf = "Cloud Turf",
    cloud_wall = "Cloud Wall",
    cloud_wall_item = "Cloud Wall",
    cloudcrag = "Cloudcrag",
    colored_corn = "Gem Corn",
    cotton_candy = "Cotton Candy",
    cotton_hat = "Cotton Hat",
    cotton_vest = "Cotton Vest",
    crystal_armor = "Crystal Armor",
    crystal_black = "Hematite Crystal", --
    crystal_cap = "Crystal Cap",
    crystal_fragment_black = "Hematite Fragment", --
    crystal_fragment_light = "Peridot Fragment", --
    crystal_fragment_quartz = "Quartz Fragment", --
    crystal_fragment_relic = "Erinote Fragment", --
    crystal_fragment_spire = "Hyacinth Fragment", --
    crystal_fragment_water = "Aquamarine Fragment", --
    crystal_fragment_white = "Howlite Fragment", --
    crystal_lamp = "Crystal Lamp",
    crystal_light = "Peridot Crystal", --
    crystal_quartz = "Quartz Crystal", --
    crystal_relic = "Erinote Crystal", --
    crystal_spire = "Hyacinth Crystal", --
    crystal_wall = "Crystal Wall",
    crystal_wall_item = "Crystal Wall",
    crystal_water = "Aquamarine Crystal", --
    crystal_white = "Howlite Crystal", --
    cumulostone = "Cumolostone",
    datura_petals = "Datura Petals",
    dragonblood_log = "Dragonblood Log",
    dragonblood_firepit = "Fire Pit",
    dragonblood_sap = "Dragonblood Sap",
    dragonblood_tree = "Dragonblood Tree",
    duckraptor = "Duckraptor",
    dug_tea_bush = "Tea Bush",
    flying_fish = "Flying Fish",
    flying_fish_pond = "Flying Fish Pond",
    gemcorn = "Gem Corn",
    gnome_wilson = "Garden Gnome",
    golden_amulet = "Golden Amulet",
    golden_egg = "Golden Egg",
    golden_golem = "Golden Golem",
    golden_lyre = "Golden Harp",
    golden_petals = "Golden Petals",
    golden_rose = "Golden Rose",
    golden_sunflower = "Golden Sunflower",
    golden_sunflower_seeds = "Golden Sunflower Seeds",
    goose = "Goose",
    grabber = "Grabber",
    greenbean = "Greenbean",
    greenbean_cooked = "Cooked Greenbean",
    greentea = "Green Tea",
    gummybear = "Gummy Bear",
    gummybear_den = "Log Den",
    gustflower = "Gustflower",
    gustflower_seeds = "Gustflower Seeds",
    hive_marshmallow = "Marshmallow Hive",
    jellycap_blue = "Blue Jellycap",
    jellycap_green = "Green Jellycap",
    jellycap_red = "Red Jellycap",
    jellyshroom_blue = "Blue Jellyshroom",
    jellyshroom_green = "Green Jellyshroom",
    jellyshroom_red = "Red Jellyshroom",
    kettle = "Kettle",
    kettle_item = "Kettle",
    kite = "Kite",
    lionant = "Lionant",
    lionblob = "Strange Blob",
    live_gnome = "Gnome",
    longbill = "Longbill",
    magic_beans = "Magic Beans",
    magic_beans_cooked = "Baked Beans",
    magnet = "Mag Net",
    manta = "Manta",
    manta_leather = "Manta Leather",
    marshmallow = "Marshmallow",
    monolith = "Monolith",
    mushroom_hat = "Mushroom Hat",
    octocopter_wreckage = "Wrecked Octocopter",
    owl = "Strix",
    package = "Unknown Package",
    pineapple_bush = "Pineapple Bush",
    pineapple = "Pineapple",
    potion_default = "Potion",
    quartz_torch = "Quartz Torch",
    rainbowcoon = "Rainbowcoon",
    refined_black_crystal = "Black Crystal",
    refined_white_crystal = "White Crystal",
    refiner = "Refiner",
    research_lectern = "Cumulocator Station",
    rubber = "Rubber",
    scarecrow = "Scarecrow",
    sheep = "Sheep",
    shopkeeper = "Shopkeeper",
    shopkeeper_umbrella = "Incredible Umbrella",
    chest_sky = "Eldrichest",
    sky_lemur = "Lemur",
    skyflies = "Lightning Bug",
    skyflower = "Skyflower",
    skyflower_petals = "Skyflower Petals",
    skytrap = "Skytrap",
    smores = "S'mores",
    tea_bush = "Tea Bush",
    tea_leaves = "Tea Leaves",
    thunder_log = "Thunder Log",
    thunder_pinecone = "Thunder Pinecone",
    thunder_sapling = "Thunder Tree Sapling",
    thunder_tree = "Thunder Tree",
    thunderboards = "Thundertree Boards",
    vine = "Vine",
    weather_machine = "Tropospherical Relay",
    weaver_bird = "Weaver Bird",
    weavernest = "Weaver Nest",
    whirlwind = "Whirlwind",
    whitestaff = "White Staff",
    wind_axe = "Axe of Storms",
    winnie_staff = "Shepherd's Staff",

    -- Tea names.
    whitetea = "White Tea",
    petaltea = "Petal Tea",
    mixedpetaltea = "Combo Petal Tea",
    evilpetaltea = "Dark Petal Tea",
    floraltea = "Floral Tea",
    skypetaltea = "Skypetal Tea",
    daturatea = "Datura Tea",
    cloudfruittea = "Cloudfruit Tea",
    greenertea = "Greener Tea",
    berrytea = "Berry Tea",
    berrypulptea = "Pulpy Berry Tea",
    cottontea = "Cottony Tea",
    goldtea = "Gold Tea",
    candytea = "Candy Tea",
    oolongtea = "Oolong Tea",
    chaitea = "Chai Tea",
    spoiledtea = "Spoiled Tea",
    jellytea = "Jellied Tea",
    redjellytea = "Red Jellied Tea",
    bluejellytea = "Blue Jellied Tea",
    greenjellytea = "Green Jellied Tea",
    redmushroomtea = "Red Mushy Tea",
    bluemushroomtea = "Blue Mushy Tea",
    greenmushroomtea = "Green Mushy Tea",
    dragontea = "Dragon Tea",
    herbaltea = "Herbal Tea",
    marshmallowtea = "Marshmallow Tea",
    ambrosiatea = "Ambrosia Tea",
    algaetea = "Algae Tea",

    -- Cooked food names.
    redjelly = "Red Jelly",
    greenjelly = "Green Jelly",
    crystalcandy = "Crystal Candy",

    -- Dummy name for morgue tricker.
    staticdummy = "Static",

    -- Bosses and their drops.
    superconductor = "Superconductor",
    radiant_orb = "Radiant Core",

    octocopter = "Octocopter",
    octocopterpart1 = "Rotor Blade",
    octocopterpart2 = "Rotor Plate",
    octocopterpart3 = "Rotor Hub",

    bean_giant = "Bean Giant",
    bean_brain = "Grey Legum",
    super_beans = "Jumping Beans",
}

Add.QuotesFor "alien" {
    
    GENERIC = "Is it real?",
    wathgrithr = "Is this an illusion?",
    waxwell = "They're stable. That's not supposed to happen.",
    webber = "I had a comic about something like him.",
    wendy = nil,
    wickerbottom = "I must look strange to them too.",
    willow = "They're solid? Does that mean they're flammable?",
    wolfgang = "Wolfgang is confused and scared.",
    woodie = "I swear I'm sane.",
    wx78 = "MY OPTICS ARE MALFUNCTIONING",
}

Add.QuotesFor "ambrosia" {
    
    GENERIC = "Supposedly it can bring immortality.",
    wathgrithr = "The fruit of Valhalla!",
    waxwell = "Surrounded by rumor and gossip, like me.",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "Each berry tastes different.",
    wolfgang = "Is strange tasty berry.",
    woodie = "Food of the gods.",
    wx78 = "FLAVORFUL",
}

Add.QuotesFor "antlion" {
    
    GENERIC = "What sick breeding produced this?",
    wathgrithr = nil,
    waxwell = "Even my Tallbirds were a bigger success than this one.",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "Half lion, half ant, all flammable.",
    wolfgang = "Is cat? Is bug? Is catbug.",
    woodie = "What a weirdo.",
    wx78 = nil,
}

Add.QuotesFor "ball_lightning" {
    
    GENERIC = "A wandering ball of static.",
    wathgrithr = "A follower of Thor?",
    waxwell = "A writhing collection of energy.",
    webber = "We we both scared of lightning.",
    wendy = "A spark of life in a dead land.",
    wickerbottom = "Listen to that crackling.",
    willow = "It's like a living ball of fire!",
    wolfgang = "Is zappy, floaty pest.",
    woodie = "Moving weather? That ain't fair.",
    wx78 = "STAY AWAY FROM ME",
}

Add.QuotesFor "balloon_hound" {
    
    GENERIC = "How did you get here?",
    wathgrithr = "Full of air and rage.",
    waxwell = "I didn't make that one.",
    webber = "Stick it with a pin!",
    wendy = "Struggle all you want, you shall not get free.",
    wickerbottom = "Inflated and irate.",
    willow = "Aw, it's out of reach!",
    wolfgang = "The dog, it floats!",
    woodie = "How did it get the balloon on?",
    wx78 = "I WANT TO POP IT",
}

Add.QuotesFor "bean_giant" {
    
    GENERIC = "Someone must bring an end to this reign of giants!",
    wathgrithr = "Vegetables are no match for my might!",
    waxwell = "It's not even worth a hill of beans.",
    webber = "Yikes! Don't hurt us!",
    wendy = "Does he avenge innocent blood, or does he thirst for it?",
    wickerbottom = "Gargantuan!",
    willow = "The bigger they are...The better they burn!",
    wolfgang = "Not little plant at all!",
    woodie = "That's a big 'un, eh?",
    wx78 = "THIS BEAN IS OUT OF CONTROL",
}

Add.QuotesFor "bean_giant_statue" {
    
    GENERIC = "I wouldn't want to run into that thing.",
    wathgrithr = "I want to meet a real one.",
    waxwell = "A false idol.",
    webber = "Seems a little silly to us.",
    wendy = "What lurked up here so long ago?",
    wickerbottom = "A vanity structure.",
    willow = "That should be a statue of me. Or fire.",
    wolfgang = "Is big stone monster.",
    woodie = "What a big hoser.",
    wx78 = "IT LOOKS MEAN",
}

Add.QuotesFor "beanlet" {
    
    GENERIC = "They exist as one, much unlike their mother.",
    wathgrithr = "A tiny, fearful creature.",
    waxwell = "I'd fancy some beans on toast now.",
    webber = "A baby bean.",
    wendy = "They cower in their own body.",
    wickerbottom = "The small shall grow strong.",
    willow = "Time for cooked beans.",
    wolfgang = "Little plant runs around.",
    woodie = "It's cute.",
    wx78 = "WHAT DO YOU WANT, SMALL BEAN?",
}

Add.QuotesFor "beanlet_armor" {
    
    GENERIC = "I feel a little ashamed.",
    wathgrithr = nil,
    waxwell = "Crude, but offers a measure of help, I suppose.",
    webber = nil,
    wendy = nil,
    wickerbottom = "Pisum sativum armour.",
    willow = "Wearing plants? What's next, swimming?",
    wolfgang = "Plant clothing is tough.",
    woodie = "Doesn't go well with my plaid shirt.",
    wx78 = nil,
}

Add.QuotesFor "beanlet_hut" {
    
    GENERIC = "A floral residence.",
    wathgrithr = nil,
    waxwell = "How primitive. Barely above a mud hovel.",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "I'll huff and I'll puff and I'll burn your house down.",
    wolfgang = "Little plant man lives there.",
    woodie = "That's a right pretty shack, eh?",
    wx78 = nil,
}

Add.QuotesFor "beanlet_shell" {
    
    GENERIC = "A husk of a bean monster.",
    wathgrithr = "Rest well, little vegetable.",
    waxwell = "The carved-out exoskeleton of a beanlet.",
    webber = "A bean shell.",
    wendy = "A protective shell in pieces. Rather ineffective.",
    wickerbottom = "The remnants of a Fabaceae.",
    willow = "A trophy of slaughtered foes.",
    wolfgang = "Little plants gone.",
    woodie = "I'm sorry, friend.",
    wx78 = "IT'S ARMOR IS MINE NOW",
}

Add.QuotesFor "beanlet_zealot" {
    
    GENERIC = "They seem pretty aggressive.",
    wathgrithr = "A vegetable with a fighting spirit!",
    waxwell = "I'd fancy some beans on toast now.",
    webber = "We eat you, not the other way around!",
    wendy = "You run to your death for one that cares not for your life.",
    wickerbottom = "This bean bites back.",
    willow = "Reminds me of me, except I worship fire.",
    wolfgang = "Little plant is very angry!",
    woodie = "Not very friendly.",
    wx78 = "THIS BEAN IS ANGRY",
}

Add.QuotesFor "beanstalk" {
    
    GENERIC = "It reaches the clouds.",
    wathgrithr = "The Rainbow Bridge!",
    waxwell = "If only my brother Jack was here...",
    webber = "Wow! It goes through the clouds!",
    wendy = "All I'd have to do is let go.",
    wickerbottom = "I filed the book pertaining to this under \"youngster.\"",
    willow = "That would make a spectacular fire.",
    wolfgang = "Is big beanstalk. Reminds Wolfgang of home.",
    woodie = "Even Lucy can't chop through it.",
    wx78 = "IT HAS GROWN OUT OF CONTROL.",
}

Add.QuotesFor "beanstalk_chunk" {
    
    GENERIC = "Part of a beanstalk.",
    wathgrithr = "A piece of the Bifrost.",
    waxwell = "It's a shred of beanstalk matter.",
    webber = "A part of the beanstalk.",
    wendy = "A piece of a crumbled colossus.",
    wickerbottom = "A remnant of the beanstalk.",
    willow = "A torn piece of beanstalk.",
    wolfgang = "Piece of big plant.",
    woodie = "It's a slice of a beanstalk.",
    wx78 = "A PIECE OF BEANSTALK",
}

Add.QuotesFor "beanstalk_exit" {
    
    GENERIC = "That's the way back to the ground.",
    wathgrithr = "Once more to the realms of man.",
    waxwell = "A return to the surface.",
    webber = "Too high! I wanna go back down!",
    wendy = "End of the line.",
    wickerbottom = "How to leave this place.",
    willow = "I wonder how long it would take for fire to reach the bottom?",
    wolfgang = "Is a long way down.",
    woodie = "It's the end of a giant.",
    wx78 = "IT IS TOO FAR TO JUMP",
}

Add.QuotesFor "beanstalk_sapling" {
    
    GENERIC = "It's supposed to grow into a beanstalk.",
    wathgrithr = "It will reach the heavens someday.",
    waxwell = "Won't be long before it pierces the heavens.",
    webber = "One day it will grow tall.",
    wendy = "Soon it shall tower overhead.",
    wickerbottom = "An angiosperm in youth.",
    willow = "This will grow huge. Or burn quick.",
    wolfgang = "Is small now, big later.",
    woodie = "That'll grow right up into a monster, eh?",
    wx78 = "GROW FASTER",
}

Add.QuotesFor "beanstalk_wall" {
    ANY = "That's not very safe.",
    GENERIC = "That's not very safe.",
    wathgrithr = "A wall of plant.",
    waxwell = "It grows on its own.",
    webber = "Veggie wall.",
    wendy = "Even the ravages of time shall find you unafraid.",
    wickerbottom = "I really hope this works.",
    willow = "Plants aren't good protection.",
    wolfgang = "Wolfgang prefers mighty walls!",
    woodie = "Not very useful.",
    wx78 = "A WALL OF BEANSTALK",
}

Add.QuotesFor "beanstalk_wall_item" {
    ANY = "That's not very safe.",
    GENERIC = "That's not very safe.",
    wathgrithr = "A wall of plant.",
    waxwell = "It grows on its own.",
    webber = "Veggie wall.",
    wendy = "Even the ravages of time shall find you unafraid.",
    wickerbottom = "I really hope this works.",
    willow = "Plants aren't good protection.",
    wolfgang = "Wolfgang prefers mighty walls!",
    woodie = "Not very useful.",
    wx78 = "A WALL OF BEANSTALK",
}

Add.QuotesFor "bee_marshmallow" {
    
    GENERIC = "A flying marshmallow.",
    wathgrithr = "Do they make honey?",
    waxwell = "Living sugar. Childish.",
    webber = "A candy bee!",
    wendy = "A mindless drone made of sugar.",
    wickerbottom = "A confectionist bee.",
    willow = "It's a bee. Made of marshmallow.",
    wolfgang = "Is bee or is not too bee? ",
    woodie = "What a sweet little bee.",
    wx78 = "SUGAR BUZZ",
}

Add.QuotesFor "bird_paradise" {
    
    GENERIC = "I'm starting to hate birds.",
    wathgrithr = "It's feathers would look good on my helmet.",
    waxwell = "The colors of heaven. Quaint.",
    webber = "Look at those feathers!",
    wendy = "Even your beauty shall fade away.",
    wickerbottom = "A member of the Paradisaeidae family.",
    willow = "Those feathers would combust nicely.",
    wolfgang = "Is all feathery.",
    woodie = "Fancy feathers don't disguise your evil, bird!",
    wx78 = "ITS FEATHERS ARE ATTRACTIVE",
}

Add.QuotesFor "blackstaff" {
    
    GENERIC = "You can charge things with magic.",
    wathgrithr = "Charge!",
    waxwell = "Causes a shift in the weather.",
    webber = "You shall not come through!",
    wendy = "Madness weaponized.",
    wickerbottom = "Black magic; in staff form.",
    willow = "I am a dark wizard now.",
    wolfgang = "Makes thunder.",
    woodie = "I shouldn't mess with nature.",
    wx78 = "IT IS FOR OVERLOADING CIRCUITS",
}

Add.QuotesFor "blacktea" {
    
    GENERIC = "It's a nice strong tea.",
    wathgrithr = "It's stronger, but still not mead.",
    waxwell = "Finally, a proper brew.",
    webber = "Mother used to enjoy this.",
    wendy = "What does fate tell me?",
    wickerbottom = "Goes well with a good book.",
    willow = "I prefer hot chocolate.",
    wolfgang = "Is nearly as strong as me!",
    woodie = "I prefer a wee spot of whiskey.",
    wx78 = "A STRONG DRINK",
}

Add.QuotesFor "blacktea_leaves" {
    
    GENERIC = "Oxidized tea leaves.",
    wathgrithr = "I can brew this!",
    waxwell = "I could do with a drink.",
    webber = "Tea; without the bag.",
    wendy = "Perhaps, I shall read the future.",
    wickerbottom = "These need a good brewing.",
    willow = "Stick them in boiling water. Or fire.",
    wolfgang = "Is for making drink.",
    woodie = "Makes for a strong cuppa.",
    wx78 = "ADD HOT WATER",
}

Add.QuotesFor "candy_fruit" {
    
    GENERIC = "Growable candy.",
    wathgrithr = "Eating this would be out of character.",
    waxwell = "Not my preference, but it'll do.",
    webber = "Yum!",
    wendy = "Sweets in the shape of something healthy.",
    wickerbottom = "I'll eat it; but I'm not a fan of sweets.",
    willow = "It's sweet.",
    wolfgang = "Tasty plant!",
    woodie = "It's very sweet, eh?",
    wx78 = "IS IT CANDY OR FRUIT?",
}

Add.QuotesFor "cauldron" {
    
    GENERIC = "A big bucket for magic stuff.",
    wathgrithr = "I'm not a sorceress!",
    waxwell = "I'm a dab hand at potion brewing.",
    webber = "I heard witches eat children.",
    wendy = "Fire burn and cauldron bubble.",
    wickerbottom = "A witches brewing pot.",
    willow = "Cauldron burn, and boil and bubble.",
    wolfgang = "Is belong to witch?",
    woodie = "There must be a hag about.",
    wx78 = "I WANT TO PUT IT ON MY HEAD",
}

Add.QuotesFor "cheshire" {
    
    GENERIC = "He's way too happy.",
    wathgrithr = "It's up to no good.",
    waxwell = "Don't think you can out-grin me, furball.",
    webber = "Cats smile?",
    wendy = "Smiles are a core part of deception.",
    wickerbottom = "Curiouser and curiouser.",
    willow = "What a nice smile.",
    wolfgang = "Has big smile. Is friend.",
    woodie = "I love cats.",
    wx78 = "WHAT ARE YOU SO HAPPY ABOUT?",
}

Add.QuotesFor "chimera" {
    
    GENERIC = "A wicked creature.",
    wathgrithr = "A worthy opponant.",
    waxwell = "Now that's very interesting.",
    webber = "Leave us be, beast!",
    wendy = "A grabbag of parts.",
    wickerbottom = "Lion, snake, goat; all in one.",
    willow = "That's horrid looking, even for me.",
    wolfgang = "Is creature from nightmares!",
    woodie = "That's not normal, eh?",
    wx78 = "A FREAK OF NATURE",
}

Add.QuotesFor "cloud_algae" {
    
    GENERIC = "Apparently, algae grows on clouds.",
    wathgrithr = "You should be in the sea, little plant.",
    waxwell = "With fronds like these, who needs anemones?",
    webber = "I hated this stuff at the seaside.",
    wendy = "It bleeds the land dry.",
    wickerbottom = "Odd, Chlorella is ocean based.",
    willow = "Plants. Great.",
    wolfgang = "Is plant-cloud.",
    woodie = "Bit out of place.",
    wx78 = "THIS SHOULD NOT GROW HERE",
}

Add.QuotesFor "cloud_algae_fragment" {
    
    GENERIC = "Apparently algae grows on clouds.",
    wathgrithr = "You should be in the sea, little plant.",
    waxwell = "Ocean foliage in miniature form.",
    webber = "Slimy and yucky and gross.",
    wendy = "A fragment of",
    wickerbottom = "Seaweed from the sky.",
    willow = "It's a bit of algae. Let's burn it.",
    wolfgang = "Is plant-cloud.",
    woodie = "It's a patch of algae.",
    wx78 = "I PICKED IT",
}

Add.QuotesFor "cloud_bomb" {
    
    GENERIC = "That shouldn't work.",
    wathgrithr = "The sky is exploding!",
    waxwell = "That's more like it.",
    webber = "Boom! We like!",
    wendy = "Let me blow my enemies to tiny bits.",
    wickerbottom = "Pacification; by cloud.",
    willow = "An explosive cloud, my favourite kind of cloud.",
    wolfgang = "Is for going boom.",
    woodie = "That's dangerous, eh?",
    wx78 = "BOOM",
}

Add.QuotesFor "cloud_bush" {
    
    GENERIC = "All plants produce simple sugars.",
    wathgrithr = "Is it a plant?",
    waxwell = "It's a bush, made of cloud. How unexpected.",
    webber = "A good place to hide.",
    wendy = "It grows sugary treats.",
    wickerbottom = "Now I've seen everything.",
    willow = "It has food. It can live a bit longer.",
    wolfgang = "Sweet food balls. Yum!",
    woodie = "It's got good food on it.",
    wx78 = "LIVING CLOUD PLANT",
}

Add.QuotesFor "cloud_bush.picked" {
    
    GENERIC = "No more sugar for me.",
    wathgrithr = nil,
    waxwell = "It needs manure, but where do I obtain that here?",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "I hate waiting.",
    wolfgang = "Do I have to poop on it?",
    woodie = "There's nothing left, eh?",
    wx78 = nil,
}

Add.QuotesFor "cloud_coral" {
    
    GENERIC = "A rock that grows.",
    wathgrithr = "A rock that grows.",
    waxwell = "There was a fight at some okay coral.",
    webber = "Pretty stuff!",
    wendy = "Are we in the air or under the sea?",
    wickerbottom = "Ocean life...in the clouds.",
    willow = "Coral. How interesting.",
    wolfgang = "Is plant-rock.",
    woodie = "It's a sky sea rock.",
    wx78 = "LIVING CLOUD ROCK",
}

Add.QuotesFor "cloud_coral_fragment" {
    
    GENERIC = "A rock that grows.",
    wathgrithr = "A growing rock.",
    waxwell = "It's a shard of coral.",
    webber = "Dang, it's broken.",
    wendy = "Once living rock.",
    wickerbottom = "Anthozoa pieces.",
    willow = "It's a bit of coral. Not burnable.",
    wolfgang = "Is plant-rock.",
    woodie = "Some kind of pebble.",
    wx78 = "I BROKE IT",
}

Add.QuotesFor "cloud_cotton" {
    
    GENERIC = "Like baby clouds.",
    wathgrithr = "It would make good padding for my armour.",
    waxwell = "I prefer silk.",
    webber = "Granddad's beard looked like this!",
    wendy = "I'd need a spinning wheel to sleep.",
    wickerbottom = "The wisps of a cloud.",
    willow = "Cotton is very flammable. ",
    wolfgang = "Is for make clothes.",
    woodie = "It's soft and warm.",
    wx78 = "IT IS VERY SOFT",
}

Add.QuotesFor "cloud_fruit" {
    
    GENERIC = "Cloud fruit. What else would it be?",
    wathgrithr = "The fruit of Valhalla.",
    waxwell = "I'd prefer a real banquet.",
    webber = "We need to eat healthy.",
    wendy = "Wispy outside hides a fleshy heart.",
    wickerbottom = "Tangy and mild.",
    willow = "A Cloud Fruit a day keeps the Shopkeeper away.",
    wolfgang = "Fluffy plant. Still yummy.",
    woodie = "Tasty.",
    wx78 = "IT LOOKS EDIBLE",
}

Add.QuotesFor "cloud_fruit_cooked" {
    
    GENERIC = "Cloud fruit. What else would it be?",
    wathgrithr = "The fruit of Valhalla.",
    waxwell = "Improved, but not by much.",
    webber = nil,
    wendy = "Wispy outside hides a fleshy heart.",
    wickerbottom = nil,
    willow = "A Cloud Fruit a day keeps the Shopkeeper away.",
    wolfgang = "Fluffy plant. Still yummy.",
    woodie = "Tasty.",
    wx78 = "IT LOOKS EDIBLE",
}

Add.QuotesFor "cloud_fruit_tree" {
    
    GENERIC = "It has a strange fruit on it.",
    wathgrithr = "The trees of Valhalla.",
    waxwell = "What is it rooted to?",
    webber = "I wish we were that tall.",
    wendy = "If only I were a bit taller.",
    wickerbottom = "These clouds have a biological means of reproduction.",
    willow = "I bet it would smell nice while burning.",
    wolfgang = "Is growing without dirt. Is magic?",
    woodie = "Look, Lucy, new trees!",
    wx78 = "HOW DOES IT GROW?",
}

Add.QuotesFor "cloud_jelly" {
    
    GENERIC = "Goopy planty matter.",
    wathgrithr = "Ugh, too sweet for me.",
    waxwell = "That's not proper jelly.",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "I'm not sure if that will burn or not.",
    wolfgang = "Is wobbly.",
    woodie = "It's plant slime, eh?",
    wx78 = "ERROR: TOAST NOT FOUND",
}

Add.QuotesFor "cloud_storage" {
    
    GENERIC = "A light and fluffy chest.",
    wathgrithr = "A cloud to hold my belongings!",
    waxwell = "I can hide my plundeer in that.",
    webber = "My toy chest was bigger than this.",
    wendy = "Thieves could simply reach through it.",
    wickerbottom = "A fluffy container.",
    willow = "For holding stuff.",
    wolfgang = "Is roomy.",
    woodie = "Good for storing stuff, eh?",
    wx78 = "CLOUD STORAGE",
}

Add.QuotesFor "cloud_turf" {
    
    GENERIC = "The ground... Err, cloud beneath my feet.",
    wathgrithr = "Like walking on air.",
    waxwell = "It came from above.",
    webber = "Spongy.",
    wendy = "Shall I dig the earth from under me.",
    wickerbottom = "Sopping wet.",
    willow = "Cloud. Always cloud.",
    wolfgang = "Is soft ground.",
    woodie = "It's some cloud from the floor.",
    wx78 = "I SHOULD FALL THROUGH THIS",
}

Add.QuotesFor "cloud_wall" {
    
    GENERIC = "I have to ask why.",
    wathgrithr = "The walls of Valhalla.",
    waxwell = "About as useful as a chocolate kettle.",
    webber = "Soft but I'm not sure if we're safe.",
    wendy = "It's practically not there.",
    wickerbottom = "A barrier of water.",
    willow = "Flimsy and damp. Useless.",
    wolfgang = "Is not mighty enough.",
    woodie = "Better than nothing, I suppose.",
    wx78 = "A WALL OF FOG",
}

Add.QuotesFor "cloudcrag" {
    
    GENERIC = "Super condensed cloud.",
    wathgrithr = "The mountains of Valhalla.",
    waxwell = "It has cloud inside it. And outside it. It's just cloud.",
    webber = "A hole in the clouds.",
    wendy = "Are you rock or air?",
    wickerbottom = "A crack in the clouds.",
    willow = "It's more cloud.",
    wolfgang = "Is mound of cloud.",
    woodie = "It's a lump of cloud.",
    wx78 = "SOLID CLOUDS",
}

Add.QuotesFor "colored_corn" {
    
    GENERIC = "Rainbow colored corn.",
    wathgrithr = "It's pretty, but still a vegetable.",
    waxwell = "What a myriad of hues.",
    webber = "I might cook this.",
    wendy = "A menagerie of colours that's hard as rock.",
    wickerbottom = "Amazing maize.",
    willow = "Something to eat while enjoying fire.",
    wolfgang = "Is tasty rock.",
    woodie = "It's a weird sweet.",
    wx78 = "COLOURFUL VEGETABLE",
}

Add.QuotesFor "cotton_candy" {
    
    GENERIC = "A bunch of fluffy sugar.",
    wathgrithr = "All fluff and no substance.",
    waxwell = "A sugary delicacy for carnivals and common folk.",
    webber = "Yum! A special treat at the carnival.",
    wendy = "Wispy and sweet like dreams. Disgusting...",
    wickerbottom = "A fairground favourite.",
    willow = "A tasty treat is second only to fire.",
    wolfgang = "Is like tasty cloud.",
    woodie = "Not had this before.",
    wx78 = "IT IS STRUCTURALLY UNSOUND",
}

Add.QuotesFor "cotton_hat" {
    
    GENERIC = "A warm, fluffy cotton hat.",
    wathgrithr = "I prefer my helm.",
    waxwell = "A gentleman wears only a top hat.",
    webber = "Matches my beard, when I have one.",
    wendy = "It traps the warmth to the point of cooking my flesh.",
    wickerbottom = "The cotton gets tangled in my bun.",
    willow = "I should have burned that cotton.",
    wolfgang = "Soft on head.",
    woodie = "Had something similar back home.",
    wx78 = "IT IS NOT WATERPROOF",
}

Add.QuotesFor "cotton_vest" {
    
    GENERIC = "It's silly looking, but very warm.",
    wathgrithr = "This looks ridiculous.",
    waxwell = "That's not even slightly dapper.",
    webber = "Snug as a bug in a rug.",
    wendy = "Sweltering heat to survive this frozen land.",
    wickerbottom = "Comfy and water absorbent.",
    willow = "It's warm, at least.",
    wolfgang = "Is comfy!",
    woodie = "Nice and warm, eh?",
    wx78 = "I LOOK LIKE A SHEEP",
}

Add.QuotesFor "crystal_armor" {
    
    GENERIC = "It's a bit heavy, but quite useful.",
    wathgrithr = "Armor made from precious mineral.",
    waxwell = "Protects me from plebians.",
    webber = "Ouch! This is heavy and pointy.",
    wendy = "Look into it, and you can see yourself die.",
    wickerbottom = "Imagine how many books I could buy with this!",
    willow = "Might save my life, I guess.",
    wolfgang = "My mighty body is even mightier!",
    woodie = "Heavy and tough. Like my curse.",
    wx78 = "SHINY AND PROTECTIVE",
}

Add.QuotesFor "crystal_black" {
    
    GENERIC = "It looks like there's a dark storm inside.",
    wathgrithr = "A black crystal.",
    waxwell = "Black, like my heart.",
    webber = "He likes this. I don't.",
    wendy = nil,
    wickerbottom = "This crystal is full of impurities.",
    willow = "It's dark. Fire is light. I know which is better.",
    wolfgang = "Is dark jewel.",
    woodie = "Contains the dark void.",
    wx78 = "DARK CRYSTAL",
}

Add.QuotesFor "crystal_cap" {
    
    GENERIC = "I'm not sure I want to wear that.",
    wathgrithr = "It's almost as good as mine!",
    waxwell = "A crystal on my head will put me ahead.",
    webber = "Don't I look swell?",
    wendy = "Beware. For the abyss looks into you.",
    wickerbottom = "This is not smart if it shatters.",
    willow = "Use your brain, protect your head.",
    wolfgang = "Stone helps head.",
    woodie = "Clashes with my hair.",
    wx78 = "DECORATION FOR MY HEAD MODULE",
}

Add.QuotesFor "crystal_fragment_black" {
    
    GENERIC = "It looks like there's a dark storm inside.",
    wathgrithr = "Like a piece of the night sky.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "He doesn't like it in pieces. I do.",
    wendy = "I see faces shifting across its surface.",
    wickerbottom = "The shards of impure crystals.",
    willow = "Piece of crystal.",
    wolfgang = "Is cracked.",
    woodie = "Something broke it, eh?",
    wx78 = "DARK CRYSTAL",
}

Add.QuotesFor "crystal_fragment_light" {
    
    GENERIC = "It glows with a strange light.",
    wathgrithr = "Twinkle, twinkle.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "I don't like this in pieces. He does.",
    wendy = "The shine dims, but is still there.",
    wickerbottom = "The remnants of a crystal.",
    willow = "It's slightly glowing.",
    wolfgang = "Is broken.",
    woodie = "There's a faint light coming off it.",
    wx78 = "LIGHT CRYSTAL",
}

Add.QuotesFor "crystal_fragment_quartz" {
    
    GENERIC = "I bet it conducts electricity.",
    wathgrithr = "A piece of crystal.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "Eh, never liked this stuff.",
    wendy = "It still attempts to hold in the light.",
    wickerbottom = "I understand this, crystal clear.",
    willow = "Someone broke it. Good.",
    wolfgang = "Is pebble.",
    woodie = "Just a shard of crystal.",
    wx78 = "SHINY CRYSTAL",
}

Add.QuotesFor "crystal_fragment_relic" {
    
    GENERIC = "I get a weird feeling from that crystal.",
    wathgrithr = "An ancient piece of crystal.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "I wonder who made this.",
    wendy = "Some things are better left unknown.",
    wickerbottom = "Something from yesteryear.",
    willow = "Ancient junk.",
    wolfgang = "Is just a piece.",
    woodie = "It's been shattered.",
    wx78 = "OLD CRYSTAL",
}

Add.QuotesFor "crystal_fragment_spire" {
    
    GENERIC = "It's a large crystal.",
    wathgrithr = nil,
    waxwell = "Dare I say they look crystal clear.",
    webber = "Why do pretty things break?",
    wendy = nil,
    wickerbottom = "A stalagmite of crystal.",
    willow = "Looks like you were cut down to size.",
    wolfgang = "Is shiny rock.",
    woodie = "Not quite as big any more.",
    wx78 = "FORMERLY TALL CRYSTAL",
}

Add.QuotesFor "crystal_fragment_water" {
    
    GENERIC = "It looks like it has water inside.",
    wathgrithr = "It's damp to the touch.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "Might put this in a glass of juice.",
    wendy = "Now to harness the storm.",
    wickerbottom = "Isn't this technically ice?",
    willow = "Hah, it's broken! Good.",
    wolfgang = "Is smashed.",
    woodie = "Just a trickle inside.",
    wx78 = "WET CRYSTAL",
}

Add.QuotesFor "crystal_fragment_white" {
    
    GENERIC = "I feel lighter just being near it.",
    wathgrithr = "A shard of winter.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "Now who broke this?",
    wendy = "Even broken, it is without flaw.",
    wickerbottom = "Broken shards of a crystal.",
    willow = "Smashed.",
    wolfgang = "Is not whole.",
    woodie = "It's dim.",
    wx78 = "WHITE CRYSTAL",
}

Add.QuotesFor "crystal_lamp" {
    
    GENERIC = "It's magically lit by crystals.",
    wathgrithr = "It has a fire within.",
    waxwell = "Even the light is crystal clear.",
    webber = "Shiny light for the night.",
    wendy = "Bottled lightning.",
    wickerbottom = "This would be great to read next to!",
    willow = "I love lamps.",
    wolfgang = "Pretty rock makes light!",
    woodie = "It's bright.",
    wx78 = "ITS LIGHT IS COMFORTING",
}

Add.QuotesFor "crystal_light" {
    
    GENERIC = "It glows with a strange light.",
    wathgrithr = "Like a star.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "It makes me safe. Not him though.",
    wendy = "Its shine rises from its depths.",
    wickerbottom = "It give off a comforting light.",
    willow = "It glows like fire.",
    wolfgang = "Is bright!",
    woodie = "It's quite bright, eh?",
    wx78 = "LIGHT CRYSTAL",
}

Add.QuotesFor "crystal_quartz" {
    
    GENERIC = "I bet it conducts electricity.",
    wathgrithr = "A crystal.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "I think this is quartz.",
    wendy = "It radiates with heat.",
    wickerbottom = "A somewhat precious gemstone.",
    willow = "I wish rocks could burn.",
    wolfgang = "Is stone.",
    woodie = "It's a wee rock.",
    wx78 = "SHINY CRYSTAL",
}

Add.QuotesFor "crystal_relic" {
    
    GENERIC = "I get a weird feeling from that crystal.",
    wathgrithr = "Old and probably powerful.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "I should be an historian.",
    wendy = "Lost knowledge made known.",
    wickerbottom = "A piece of history in my hands.",
    willow = "Broken ancient junk.",
    wolfgang = "Is old.",
    woodie = "Wonder who made that, eh?",
    wx78 = "OLD CRYSTAL",
}

Add.QuotesFor "crystal_spire" {
    
    GENERIC = "It's a large crystal.",
    wathgrithr = "A spire worthy of the gods!",
    waxwell = "Dare I say they look crystal clear.",
    webber = "Gee whiz! I'll be a billionaire!",
    wendy = "But what do you support?",
    wickerbottom = "My word, that would be worth a fortune!",
    willow = "A big shiny rock.",
    wolfgang = "Is spiky, shiny rock.",
    woodie = "It's a big, pointy rock.",
    wx78 = "TALL CRYSTAL",
}

Add.QuotesFor "crystal_wall" {
    ANY = "A crystalline wall.",
    GENERIC = "A crystalline wall.",
    wathgrithr = "It sparkles.",
    waxwell = "It's a bit of an eyeful, but it's reliable.",
    webber = "A bull couldn't break this.",
    wendy = "My image distorts across its surface.",
    wickerbottom = "I'd like to see them get through that!",
    willow = "Might protect me from enemies I can't burn.",
    wolfgang = "Is tough, like Wolfgang.",
    woodie = "Strong and durable.",
    wx78 = "A WALL OF CRYSTAL",
}

Add.QuotesFor "crystal_water" {
    
    GENERIC = "It looks like it has water inside.",
    wathgrithr = "I can hear the sea inside.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "A water gem.",
    wendy = "A swirling torrent dwells within.",
    wickerbottom = "Isn't this technically ice?",
    willow = "I don't like water.",
    wolfgang = "Is pretty blue.",
    woodie = "It rages like the sea.",
    wx78 = "WET CRYSTAL",
}

Add.QuotesFor "crystal_white" {
    
    GENERIC = "I feel lighter just being near it.",
    wathgrithr = "Like winter snow.",
    waxwell = "Dare I say they look crystal clear.",
    webber = "I like this. He doesn't.",
    wendy = "Unnaturally flawless.",
    wickerbottom = "Tabula rasa crystal.",
    willow = "White is boring. Red is better.",
    wolfgang = "Is blank. Like thoughts.",
    woodie = "It glows like the sun.",
    wx78 = "WHITE CRYSTAL",
}

Add.QuotesFor "cumulostone" {
    
    GENERIC = "A rock that seems to pulse with light.",
    wathgrithr = "The building blocks of Valhalla.",
    waxwell = "Stone and cloud enmeshed.",
    webber = "I wonder what this is?",
    wendy = "It crackles with energy.",
    wickerbottom = "A magnet for clouds.",
    willow = "It's cloud rock. Why is nothing in this place good to burn?",
    wolfgang = "Is rock and is cloud.",
    woodie = "It's rock. Wood's better.",
    wx78 = "SOFT ROCK",
}

Add.QuotesFor "datura_petals" {
    
    GENERIC = "It smells of nightmares.",
    wathgrithr = nil,
    waxwell = "It smells like innocence. Ripe for the taking. ",
    webber = "We had these in our garden.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "Solanaceae petals.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",
}

Add.QuotesFor "dragonblood_firepit" {
    
    GENERIC = "That's a little too hot.",
    wathgrithr = nil,
    waxwell = "It doesn't last long, but it's hot enough to nearly warm my heart.",
    webber = "We don't like that fire.",
    wendy = "It's so mesmerizing.",
    wickerbottom = nil,
    willow = "What an amazing fire!",
    wolfgang = "Fire much bigger than Wolfgang.",
    woodie = "This would have been a treat on cold nights in Canada.",
    wx78 = "MY CASE IS WARMING QUICKLY",
}

Add.QuotesFor "dragonblood_log" {
    
    GENERIC = "It emits a slight warmth.",
    wathgrithr = "The tree dragon has fallen!",
    waxwell = "It has latent properties.",
    webber = "All logs look the same to us.",
    wendy = "It's petrified.",
    wickerbottom = "I'm guessing this comes from a Daemonorops.",
    willow = "Finally, decent fire material.",
    wolfgang = "Is good wood.",
    woodie = "Not my usual fare, but I'll take it.",
    wx78 = "IT IS VERY WARM",
}

Add.QuotesFor "dragonblood_sap" {
    
    GENERIC = "Warm, gooey tree sap.",
    wathgrithr = "Warm and sticky, but it doesn't smell like blood.",
    waxwell = "How sappy.",
    webber = "Yuck! Probably not as nice as maple.",
    wendy = "Blood from a tree. Now to get blood from a stone.",
    wickerbottom = "Isn't sap technically blood?",
    willow = "It's all sticky, ugh.",
    wolfgang = "Does not taste of blood.",
    woodie = "Maybe I can make some syrup.",
    wx78 = "TREE BLOOD",
}

Add.QuotesFor "dragonblood_tree" {
    
    GENERIC = "I wonder if it breathes fire?",
    wathgrithr = "It doesn't look like a dragon.",
    waxwell = "No matter what I do, the days just dragon.",
    webber = "Looks fun to climb!",
    wendy = "If it bleeds, does it feel?",
    wickerbottom = "If I have to identify this, I'm guessing Daemonorops.",
    willow = "Dragons and trees go together like a forest on fire.",
    wolfgang = "Strange tree.",
    woodie = "Now that's a beauty, eh?",
    wx78 = "A STRANGE TREE",
}

Add.QuotesFor "duckraptor" {
    
    GENERIC = "A nightmare duck! What next?",
    wathgrithr = "Fight me, duck creature!",
    waxwell = "You will make a rather exquisite duck pâté.",
    webber = "Will it breath fire or just quack?",
    wendy = "A monster of greed and rage.",
    wickerbottom = "I could never imagine something like that!",
    willow = "I want it as a pet.",
    wolfgang = "So many claws.",
    woodie = "This bird shows its vile nature.",
    wx78 = "IT IS DIFFERENT NOW",
}

Add.QuotesFor "dug_tea_bush" {
    
    GENERIC = "Tea leaves grow on this bush.",
    wathgrithr = "It grows tea.",
    waxwell = "I should put this back in the dirt.",
    webber = nil,
    wendy = "From this grows the drink of diviners.",
    wickerbottom = nil,
    willow = "I could burn that.",
    wolfgang = "Get leaves, make drink.",
    woodie = "It's got tea on it.",
    wx78 = "I CAN USE ITS LEAVES",
}

Add.QuotesFor "flying_fish" {
    
    GENERIC = "But do they have lungs?",
    wathgrithr = "A skyfaring fish.",
    waxwell = "Being able to fly did not aid you at all.",
    webber = "Look a fish that flies!",
    wendy = "A creature of two worlds, that belongs in neither.",
    wickerbottom = "Who studies this; an ornithologist or an ichthyologist?",
    willow = "What a strange creature.",
    wolfgang = "Is fish out of water.",
    woodie = "It's suspiciously birdlike.",
    wx78 = "I HOPE IT SUFFOCATES",
}

Add.QuotesFor "flying_fish_pond" {
    
    GENERIC = nil,
    wathgrithr = "Can they swim?",
    waxwell = "The home of hopeless, damp creatures.",
    webber = "I don't have my water wings.",
    wendy = "What can I fish from empty void?",
    wickerbottom = "Where the flying fish come to sleep.",
    willow = "Fish live there. Watery cowards.",
    wolfgang = "Where oh where did the fishie go?",
    woodie = "Smells a bit fishy.",
    wx78 = "IT LOOKS EMPTY",
}

Add.QuotesFor "golden_amulet" {
    
    GENERIC = "An amulet of luck.",
    wathgrithr = "An amulet of Freyja.",
    waxwell = "It's not magical.",
    webber = "Mum would like this.",
    wendy = "What use shall this one have?",
    wickerbottom = "My husband gave me something similar to this.",
    willow = "It's nice enough, I guess.",
    wolfgang = "Is shiny neck jewelery.",
    woodie = "It's very pretty, eh?",
    wx78 = "IT MATCHES MY CHASSIS",
}

Add.QuotesFor "golden_egg" {
    
    GENERIC = "It's warm. And gold. Mostly gold.",
    wathgrithr = "Good for winter nights.",
    waxwell = "I am beyond wealth.",
    webber = "Look at that!",
    wendy = "All that glitters isn't gold.",
    wickerbottom = "Will I get a golden Anatidae from this?",
    willow = "Will it hatch into a metal bird?",
    wolfgang = "Is not for eating.",
    woodie = "I don't think there's a bird in that, thankfully.",
    wx78 = "I LIKE YOU, EGG",
}

Add.QuotesFor "golden_golem" {
    
    GENERIC = "It's worthless as long as it wants to kill me.",
    wathgrithr = "Imagine how many spears I could make from this!",
    waxwell = "How intruiging.",
    webber = "Don't eat us! We don't want to be three!",
    wendy = "Its shine hides the stains of victims past.",
    wickerbottom = "A monster from myth.",
    willow = "Metal doesn't burn.",
    wolfgang = "Metal Giant!",
    woodie = "Very shiny.",
    wx78 = "WE ARE BROTHERS",
}

Add.QuotesFor "golden_lyre" {
    
    GENERIC = "A boring golden harp.",
    wathgrithr = "It plays the music of battle!",
    waxwell = "Plays a beautiful tune, yet participates in dull conversations.",
    webber = "I think that's a harp.",
    wendy = "What say you, soothsayer?",
    wickerbottom = "An angelic harp.",
    willow = "The only music I like is the sound of fire burning.",
    wolfgang = "What pretty noises.",
    woodie = "I know a thing or two about music.",
    wx78 = "MUSIC IS OVERRATED",
}

Add.QuotesFor "golden_petals" {
    
    GENERIC = "Golden flower petals.",
    wathgrithr = "Flowers of the gods!",
    waxwell = "Aurelian flakes.",
    webber = "I hope this never rots.",
    wendy = "Am I to be taken a fool?",
    wickerbottom = "I wonder if this colour attracts bees?",
    willow = "No good to me.",
    wolfgang = "Is from shiny plant.",
    woodie = "All that glitters.",
    wx78 = "I KILLED IT",
}

Add.QuotesFor "golden_rose" {
    
    GENERIC = "A rose with golden petals.",
    wathgrithr = "Flowers of the gods!",
    waxwell = "I'll leave one out for Charlie.",
    webber = "Roses are red and gold somehow too.",
    wendy = "A gift for a lady. Why would they grow here?",
    wickerbottom = "A rose by any other name will smell as sweet.",
    willow = "Roses have thorns. They're okay in my book.",
    wolfgang = "Shiny flower has sharp thorns.",
    woodie = "I bet Lucy would like one.",
    wx78 = "IT IS VERY NICE",
}

Add.QuotesFor "golden_sunflower" {
    
    GENERIC = "A sunflower made of gold.",
    wathgrithr = "It shines like my spear.",
    waxwell = "The golden sun rises in the east.",
    webber = "These grew in the gardens close to home.",
    wendy = "Shines as the sun.",
    wickerbottom = "Helianthus annuus; gold version.",
    willow = "It's nothing like the sun. Lame.",
    wolfgang = "Is big yellow flower.",
    woodie = "A miracle of nature, eh?",
    wx78 = "SOLAR FLOWER",
}

Add.QuotesFor "golden_sunflower_seeds" {
    
    GENERIC = "I can make a gold farm!",
    wathgrithr = "A good snack, for some people.",
    waxwell = "The gift that keeps on giving.",
    webber = "We can make the world better, one seed at a time.",
    wendy = "They shine with a gilded light.",
    wickerbottom = "Helianthus annuus seeds.",
    willow = "A bit of fire would spice those up.",
    wolfgang = "This grow big shiny plant.",
    woodie = "More farming?",
    wx78 = "I CAN PLANT THEM",
}

Add.QuotesFor "goose" {
    
    GENERIC = "I wonder if it lays golden eggs?",
    wathgrithr = "Lay me an egg!",
    waxwell = "For others a source of wealth, for me a source of annoyance.",
    webber = "Honk yourself.",
    wendy = "Are you golden or merely gilded?",
    wickerbottom = "A member of Anatidae. Too noisy.",
    willow = "There's a goose on the loose.",
    wolfgang = "Egg is not tasty. Bird is though.",
    woodie = "Golden presents aren't enough to sway me, fiend!",
    wx78 = "EGG SOURCE DETECTED",
}

Add.QuotesFor "grabber" {
    
    GENERIC = "This reminds me of someone.",
    wathgrithr = "To reach far-off things.",
    waxwell = "Useful for reaching far away things.",
    webber = "Grab-O-hand.",
    wendy = "It possesses Death's iron grip.",
    wickerbottom = "Extends my range of acquisition.",
    willow = "Now you're over there, now you're not!",
    wolfgang = "Makes things closer.",
    woodie = "Good for reaching stuff.",
    wx78 = "EXTENDABLE ARM MODULE",
}

Add.QuotesFor "greenbean" {
    
    GENERIC = "Green and nutritious.",
    wathgrithr = "Disgusting!",
    waxwell = "The flesh of a beanlet. Lovely.",
    webber = "Mother used to try and feed us these.",
    wendy = "It looks afraid.",
    wickerbottom = "A bit bland.",
    willow = "It's bean fun.",
    wolfgang = "Wolfgang has bean green before!",
    woodie = "Good on toast.",
    wx78 = "HEALTHY",
}

Add.QuotesFor "greentea" {
    
    GENERIC = "A healthy green tea.",
    wathgrithr = "I prefer mead.",
    waxwell = "I prefer it black, but this will do.",
    webber = "I really don't think we'll like this.",
    wendy = "Perhaps I can calm my nerves.",
    wickerbottom = "An acquired taste; but worth it.",
    willow = "Time for tea.",
    wolfgang = "Is not even green.",
    woodie = "I guess one won't kill me.",
    wx78 = "A HOT DRINK",
}

Add.QuotesFor "gummybear" {
    
    GENERIC = "How beary nice to meet you.",
    wathgrithr = nil,
    waxwell = "They can't bear the presence of others.",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "I wonder if they burn or melt.",
    wolfgang = "Wolfgang knew dancing bear in circus.",
    woodie = "They're nothing like the bears back home.",
    wx78 = nil,
}

Add.QuotesFor "gummybear_den" {
    
    GENERIC = "I couldn't fit in it if I tried.",
    wathgrithr = nil,
    waxwell = "Who's been sleeping in their den?",
    webber = nil,
    wendy = nil,
    wickerbottom = nil,
    willow = "Arson is a favourite pastime of mine.",
    wolfgang = "Reminds me of tale from childhood.",
    woodie = "What a waste of wood.",
    wx78 = nil,
}

Add.QuotesFor "gustflower" {
    
    GENERIC = "I should steer clear of it.",
    wathgrithr = "It makes its own wind.",
    waxwell = "...Reap the whirlwind.",
    webber = "Windy flower.",
    wendy = "They send any threats away with powerful winds.",
    wickerbottom = "A breezy bloomer.",
    willow = "It makes wind. Not a fan.",
    wolfgang = "Plant makes whoosh.",
    woodie = "What a windbag.",
    wx78 = "WIND PLANT",
}

Add.QuotesFor "gustflower_seeds" {
    
    GENERIC = "I can plant this somewhere.",
    wathgrithr = "I can plant the wind itself.",
    waxwell = "Those who sow the air...",
    webber = "Isn't life amazing?",
    wendy = "They shake with the power of a gale.",
    wickerbottom = "I can plant some more wind flowers with these.",
    willow = "I could plant them. Or burn them.",
    wolfgang = "Is for blowy flower.",
    woodie = "I don't grow stuff.",
    wx78 = "FOR PLANTING THE WIND PLANT",
}

Add.QuotesFor "hive_marshmallow" {
    
    GENERIC = "A giant marshmallow.",
    wathgrithr = "Full of candy bees.",
    waxwell = "Wretched, full of scum and villainy.",
    webber = "Buzzy bees making treats.",
    wendy = "The home of the mindless drones.",
    wickerbottom = "A hive of activity.",
    willow = "Bees live there. I could smoke 'em out.",
    wolfgang = "Taste of bug.",
    woodie = "Bees. Keep them away from your face.",
    wx78 = "A HIVE OF SUGAR",
}

Add.QuotesFor "jellyshroom_blue" {
    
    GENERIC = "You jelly?",
    wathgrithr = "It's still a vegetable.",
    waxwell = "Reproduces through spores.",
    webber = "Yum! Blue flavour!",
    wendy = "Blue gelatin.",
    wickerbottom = "A cerulean sweet.",
    willow = "Boring. Let's burn something.",
    wolfgang = "Is squishy.",
    woodie = "Is that safe to eat?",
    wx78 = "BLUE GUMMY CANDY",
}

Add.QuotesFor "jellyshroom_green" {
    
    GENERIC = "You jelly?",
    wathgrithr = "It's still a vegetable.",
    waxwell = "I'm green with envy.",
    webber = "Yum! Lime flavour!",
    wendy = "Ugh. Too many sweets.",
    wickerbottom = "A guppie green gummy.",
    willow = "Green plants burn slower.",
    wolfgang = "Is squidgy.",
    woodie = "Green is nice.",
    wx78 = "GREEN GUMMY CANDY",
}

Add.QuotesFor "jellyshroom_red" {
    
    GENERIC = "You jelly?",
    wathgrithr = "It's still a vegetable.",
    waxwell = "I'm seeing red.",
    webber = "Yum! Strawberry flavour!",
    wendy = "Ugh. Too many sweets.",
    wickerbottom = "A crimson confection.",
    willow = "Red is my favourite colour.",
    wolfgang = "Is squeezy.",
    woodie = "Red like my hair.",
    wx78 = "RED GUMMY CANDY",
}

Add.QuotesFor "kettle" {
    
    GENERIC = "A kettle, for brewing tea.",
    wathgrithr = "Brews hot beverages.",
    waxwell = "For use in brewing a cuppa.",
    webber = "Where is the plug?",
    wendy = "It howls like a banshee when it's ready.",
    wickerbottom = "A water boiling vessel.",
    willow = "I could make a drink.",
    wolfgang = "Gets Wolfgang into hot water!",
    woodie = "For making tea.",
    wx78 = "IT IS SCREAMING",
}

Add.QuotesFor "kettle_item" {
    
    GENERIC = "A kettle, for brewing tea.",
    wathgrithr = "Brews hot beverages.",
    waxwell = "For use in brewing a cuppa.",
    webber = "Where is the plug?",
    wendy = "It howls like a banshee when it's ready.",
    wickerbottom = "A water boiling vessel.",
    willow = "I could make a drink.",
    wolfgang = "Gets Wolfgang into hot water!",
    woodie = "For making tea.",
    wx78 = "IT IS SCREAMING",
}

Add.QuotesFor "kite" {
    
    GENERIC = "Cloth tied to a string.",
    wathgrithr = "It soars above the clouds!",
    waxwell = "I wonder who owned this.",
    webber = "I had two of these.",
    wendy = "Shall I tempt fate?",
    wickerbottom = "Ah, to be young again!",
    willow = "Maybe lightning will strike it.",
    wolfgang = "Is for flying.",
    woodie = "No time to play with kites, there are trees to chop!",
    wx78 = "A CHILDREN'S TOY",
}

Add.QuotesFor "lionant" {
    
    GENERIC = "Probably nothing to worry about.",
    wathgrithr = "A beast from Hel!",
    waxwell = "Interesting, but not particularly useful.",
    webber = "We hate bugs. Well I do.",
    wendy = "That's just....silly.",
    wickerbottom = "A Myrmeleontidae. Wow, I'm surprised I could pronounce that!",
    willow = nil,
    wolfgang = nil,
    woodie = "What a weirdo.",
    wx78 = "THIS IS AN ABOMINATION",
}

Add.QuotesFor "lionblob" {
    
    GENERIC = "Is that supposed to be a joke?",
    wathgrithr = "What foul thing is this?",
    waxwell = "In all my many twisted dreams, I've never seen such as this.",
    webber = "A blob.",
    wendy = "What is your purpose?",
    wickerbottom = "A blob of ant lion.",
    willow = "What in the hell is that?",
    wolfgang = "Is not right.",
    woodie = "That's beyond nature.",
    wx78 = "STOMP",
}

Add.QuotesFor "live_gnome" {
    
    GENERIC = "Is that a gnome?",
    wathgrithr = "The small man lives!",
    waxwell = "I petrified a few once.",
    webber = "Gnoming around are we?",
    wendy = "Zealots of order.",
    wickerbottom = "I have a few porcelain versions in my garden.",
    willow = "Those things can move?",
    wolfgang = "Garden man lives?",
    woodie = "It's a little man, eh?",
    wx78 = "ARE YOU AN AUTOMATON?",
}

Add.QuotesFor "longbill" {
    
    GENERIC = "Are those claws on its wings?",
    wathgrithr = "What a large beak.",
    waxwell = "With its size it most likely has trouble ducking.",
    webber = "Is that a woodpecker?",
    wendy = "It looks for fights.",
    wickerbottom = "A Melanocharitida with a beautiful tweet.",
    willow = "Ha, it has a big nose!",
    wolfgang = "Why long bill? Wolfgang still funny.",
    woodie = "Die, nasally-challenged monster!",
    wx78 = "DUCK-BASED ORGANISM",
}

Add.QuotesFor "magic_beans" {
    
    GENERIC = "Oldest marketing scam in the book!",
    wathgrithr = "I should bury them.",
    waxwell = "I hope the legends aren't full of beans.",
    webber = "Magic! In beans!",
    wendy = "A trickster's gift.",
    wickerbottom = "Worth exactly one bovine.",
    willow = "Magic doesn't stop fire.",
    wolfgang = "Not enough for my mighty belly.",
    woodie = "Magic? Not sure about that.",
    wx78 = "ONLY SUPERSTITION",
}

Add.QuotesFor "magic_beans_cooked" {
    
    GENERIC = "I don't even know why I did that.",
    wathgrithr = "What a waste.",
    waxwell = "I guess we'll never know if they were real or not.",
    webber = "Well that was stupid of us.",
    wendy = nil,
    wickerbottom = "I've cooked all the charm out of them.",
    willow = "Magic doesn't stop fire.",
    wolfgang = "Not enough for my mighty belly.",
    woodie = "No good for growing now.",
    wx78 = "THEY ARE DEAD NOW",
}

Add.QuotesFor "magnet" {
    
    GENERIC = "It's quite magnetic.",
    wathgrithr = "How does it work?",
    waxwell = "A pair of poles produces power.",
    webber = "Come to me metal.",
    wendy = "Come to me.",
    wickerbottom = "Thank goodness my glasses are non-ferrous.",
    willow = "It's attracted to metal. I'm attracted to fire.",
    wolfgang = "Is metal flycatcher.",
    woodie = "It's a bugzapper.",
    wx78 = "KEEP IT AWAY FROM ME",
}

Add.QuotesFor "manta" {
    
    GENERIC = "Aren't you supposed to be in the ocean?",
    wathgrithr = "Why are you so far from home?",
    waxwell = "Not something you sea every day.",
    webber = "I think I saw this at the aquarium.",
    wendy = "To fly without a care. If only.",
    wickerbottom = "A Manta, from Mobulidae.",
    willow = "That's new.",
    wolfgang = "What is creature? Where is from?",
    woodie = "Very majestic, eh?",
    wx78 = "A ROAMING SEA CREATURE",
}

Add.QuotesFor "manta_leather" {
    
    GENERIC = "Skin from a flying manta.",
    wathgrithr = "This could be useful.",
    waxwell = "It's no skin off my nose.",
    webber = "Doesn't help me swim though.",
    wendy = "What shall I make from this flesh?",
    wickerbottom = "My word, this stinks.",
    willow = "It's a piece of skin. Hard to burn.",
    wolfgang = "Is tough skin.",
    woodie = "Reminds me of the women back home.",
    wx78 = "I STOLE ITS SKIN",
}

Add.QuotesFor "marshmallow" {
    
    GENERIC = "Maybe just one. For science!",
    wathgrithr = "I don't have much of a sweet tooth.",
    waxwell = "Contrary to the name, these do not contain marsh.",
    webber = "We need a stick and fire and we'd be good to go.",
    wendy = "Yet another way to rot me further.",
    wickerbottom = "The modern version of a Althaea officinalis product.",
    willow = "I eat mine charred.",
    wolfgang = "Is soft treat!",
    woodie = "Good on campfires.",
    wx78 = "SQUISHY",
}

Add.QuotesFor "monolith" {
    
    GENERIC = "What is this? A giant golden potato?",
    wathgrithr = "A monument to Freyja.",
    waxwell = "It's artistic value is greatly underrated.",
    webber = "Tall rock.",
    wendy = nil,
    wickerbottom = "Is this a natural obelisk?",
    willow = "Why would anyone waste time making that when they could be setting fires?",
    wolfgang = "Is...art?",
    woodie = "Now that's right fancy.",
    wx78 = "IT'S FULL OF STARS",
}

Add.QuotesFor "mushroom_hat" {
    
    GENERIC = "I feel silly, oh so silly.",
    wathgrithr = "A helmet of vegetables.",
    waxwell = "Why would I want to wear that?",
    webber = "This makes me feel really sick.",
    wendy = nil,
    wickerbottom = "A mycologist's head piece.",
    willow = "This is awful.",
    wolfgang = "There is mush room on my head. Hah.",
    woodie = "Not my usual fare, but it'll do.",
    wx78 = "HEAD FUNGUS",
}

Add.QuotesFor "octocopter" {
    
    GENERIC = "Half machine, half octopus.",
    wathgrithr = "I can use it to travel between realms.",
    waxwell = "A bionic octopus. Clever.",
    webber = "A flying octopus.",
    wendy = "Rise.",
    wickerbottom = "Never seen that in my teuthology encyclopaedias.",
    willow = "I've heard of flying pigs, but never flying octopi.",
    wolfgang = "It has many arms!",
    woodie = "It's a flying sea creature.",
    wx78 = "I HATE ITS FLESHY PARTS",
}

Add.QuotesFor "octocopter_wreckage" {
    
    GENERIC = "Now it's mostly octopus.",
    wathgrithr = "Poor thing.",
    waxwell = "This could work to my advantage.",
    webber = "If only I was eaten by that instead.",
    wendy = "Perhaps I can make my own monster...",
    wickerbottom = "I pity it...on some level.",
    willow = "It's crashed. I might be able to fix it.",
    wolfgang = "Is broken!",
    woodie = "It's hurt. Sorry, friend.",
    wx78 = "IT IS BETTER OFF THIS WAY",
}

Add.QuotesFor "octocopterpart1" {
    
    GENERIC = "A rotor blade.",
    wathgrithr = "This could be a fine sword.",
    waxwell = "Better get my oct together.",
    webber = "A piece from the flying octopus.",
    wendy = "Slice the air.",
    wickerbottom = "A part from an octopoda.",
    willow = "I need this for flying.",
    wolfgang = "Is for flying.",
    woodie = "What's that?",
    wx78 = "I SHOULD ATTACH IT TO MY BODY",
}

Add.QuotesFor "octocopterpart2" {
    
    GENERIC = "A rotor plate.",
    wathgrithr = "Aha, a shield!",
    waxwell = "Better get my oct together.",
    webber = "A piece from the flying octopus.",
    wendy = "Hold it down.",
    wickerbottom = "A piece from an octopoda.",
    willow = "A part of a broken Octocopter.",
    wolfgang = "Soon Wolfgang flies.",
    woodie = "Not for eating off of.",
    wx78 = "A METAL PLATE",
}

Add.QuotesFor "octocopterpart3" {
    
    GENERIC = "A rotor hub.",
    wathgrithr = "Maybe I should fix the poor thing.",
    waxwell = "Better get my oct together.",
    webber = "A piece from the flying octopus.",
    wendy = "Bring it together.",
    wickerbottom = "A procurement from an octopoda.",
    willow = "The last piece of an Octocopter.",
    wolfgang = "Octopus needs this.",
    woodie = "Looks mechanical, eh?",
    wx78 = "IT LOOKS IMPORTANT",
}

Add.QuotesFor "owl" {
    
    GENERIC = "Their eyes are unsettling...",
    wathgrithr = "A being cloaked in feathers.",
    waxwell = "These have a secret brotherhoot.",
    webber = "An owl!",
    wendy = "Zealots of madness.",
    wickerbottom = "Minerva's pet; my favourite creature!",
    willow = "A silent, deadly predator. Like me.",
    wolfgang = "Mean birds. More than tallest bird!",
    woodie = "I am not fond of them.",
    wx78 = "BIRD HUMANOID",
}

Add.QuotesFor "package" {
    
    GENERIC = "There's something in it.",
    wathgrithr = "Oh, a surprise!",
    waxwell = "There's something in there.",
    webber = "Being small is not always a good thing.",
    wendy = "What's in the box?!",
    wickerbottom = "Easy to carry and store; life couldn't be simpler!",
    willow = "What's in it? I hope it's fire.",
    wolfgang = "What is inside?",
    woodie = "Is it for me?",
    wx78 = "CONTENTS UNKNOWN",
}

Add.QuotesFor "pineapple_bush" {
    
    GENERIC = nil,
    wathgrithr = nil,
    waxwell = "Not many fruits grow close to the ground.",
    webber = "A pineapple bush",
    wendy = nil,
    wickerbottom = "This bush grows Ananas comosus.",
    willow = "More fruit. Better than starving.",
    wolfgang = "Is little spiky fruit bush.",
    woodie = "Not many fruits grow on the ground.",
    wx78 = "IT GROWS PINEAPPLES",
}

Add.QuotesFor "pineapple_fruit" {
    
    GENERIC = nil,
    wathgrithr = "I won't eat something this sharp.",
    waxwell = "A fruit after my own heart.",
    webber = "Dad had an ukulele shaped like one of these.",
    wendy = "A fruit that eats you back.",
    wickerbottom = "Ananas comosus; lovely taste.",
    willow = "It's all spiky. My kind of plant.",
    wolfgang = "Pointy fruit!",
    woodie = "Never seen the like of this before, eh?",
    wx78 = "TANGY",
}

Add.QuotesFor "quartz_torch" {
    
    GENERIC = nil,
    wathgrithr = "A magical torch?",
    waxwell = "Hmm. Not even I am sure of this.",
    webber = "My portable night light.",
    wendy = "And a light shall shine in the dark.",
    wickerbottom = "Now this, I don't understand.",
    willow = "Needs fire.",
    wolfgang = "Is glowing rock on stick.",
    woodie = "Thankfully it can't burn trees.",
    wx78 = "HOW DOES IT BURN?",
}

Add.QuotesFor "rainbowcoon" {
    
    GENERIC = "Colorful, but it's a ploy for my food.",
    wathgrithr = "A colourful mischief-maker.",
    waxwell = "The rainbow is trying to taste my food!",
    webber = "Looks like he fell in buckets of paint.",
    wendy = "A thief in deceptively cheery colours.",
    wickerbottom = "Look at that hue.",
    willow = "Touch my stuff and I'll burn you good!",
    wolfgang = "Is pretty, but food is mine!",
    woodie = "Colourful little thief.",
    wx78 = "STAY AWAY FROM MY NUTRIENTS",
}

Add.QuotesFor "refined_black_crystal" {
    
    GENERIC = "A large chunk of black crystal.",
    wathgrithr = "It's better now!",
    waxwell = nil,
    webber = "He really likes this. I don't",
    wendy = nil,
    wickerbottom = "I've made the darkness stronger.",
    willow = "It's been improved. Fire would improve it more.",
    wolfgang = "Is better now.",
    woodie = "It looks nicer, eh?",
    wx78 = "FANCY DARK CRYSTAL",
}

Add.QuotesFor "refined_white_crystal" {
    
    GENERIC = "A large chunk of white crystal.",
    wathgrithr = "It's better now!",
    waxwell = "A solid, flawless chunk of gleaming crystal.",
    webber = "I really like this. He doesn't.",
    wendy = "Can you really improve that which is flawless.",
    wickerbottom = "A refined and pure crystal.",
    willow = "It's good, but not as good as fire.",
    wolfgang = "Much nicer.",
    woodie = "It's gotten brighter.",
    wx78 = "FANCY WHITE CRYSTAL",
}

Add.QuotesFor "refiner" {
    
    GENERIC = "A refiner. It crushes things into pieces.",
    wathgrithr = "Finally, a machine to break things!",
    waxwell = "There's nothing as refined as me.",
    webber = "Makes things better.",
    wendy = "Destroy. Then improve.",
    wickerbottom = "A device to remove the impurities.",
    willow = "You can't refine fire.",
    wolfgang = "Is to change stuff.",
    woodie = "Put stuff in, get stuff out, eh?",
    wx78 = "LET'S BE FRIENDS",
}

Add.QuotesFor "research_lectern" {
    
    GENERIC = "I'm not even sure what's real anymore.",
    wathgrithr = "A machine of myths and magic!",
    waxwell = "This is a new branch of science.",
    webber = "A book stand.",
    wendy = "Or I could look up.",
    wickerbottom = "I never saw a lectern like that at university.",
    willow = "Make stuff? I prefer to destroy stuff.",
    wolfgang = "Is cloud-science. Fluffiest kind of science.",
    woodie = "More of that nasty science stuff.",
    wx78 = "I WILL LEARN IMPOSSIBLE THINGS",
}

Add.QuotesFor "rubber" {
    
    GENERIC = "It doesn't conduct electricity very well.",
    wathgrithr = "It's useless as armor.",
    waxwell = "Good for erasing pencil.",
    webber = "Stretchy; like gum.",
    wendy = "This is rubber, I'm glue.",
    wickerbottom = "Caoutchouc, if it's natural that is.",
    willow = "Smells bad when burning.",
    wolfgang = "Is stretchy.",
    woodie = "It's rough and stretchable.",
    wx78 = "IT DOES NOT CONDUCT ELECTRICITY",
}

Add.QuotesFor "scarecrow" {
    
    GENERIC = "It doesn't seem like it's working.",
    wathgrithr = "A target for my spear!",
    waxwell = "Crows aren't actually bothered by them.",
    webber = "Scaring things is fun.",
    wendy = "Not at all frightening.",
    wickerbottom = "An avian pest deterrent.",
    willow = "Why scare crows when you can burn them?",
    wolfgang = "Does not scare Wolfgang!",
    woodie = "A friend against the onslaught of feathered monsters.",
    wx78 = "I AM NOT SCARED",
}

Add.QuotesFor "sheep" {
    
    GENERIC = "They make me feel sleepy.",
    wathgrithr = "A passive beast.",
    waxwell = "It's cuteness disgusts me greatly.",
    webber = "I count fourteen, then I fall asleep!",
    wendy = " Ignorance. The worst kind of darkness.",
    wickerbottom = "Nice to meet ewe.",
    willow = "Cotton. Very flammable.",
    wolfgang = "Little sheep is made of soft.",
    woodie = "Very fluffy, eh?",
    wx78 = "DOCILE MAMMAL. HARD TO FRIGHTEN.",
}

Add.QuotesFor "sheep.ram" {
    
    GENERIC = "Electrifying!",
    wathgrithr = "A sheep with a warrior's heart.",
    waxwell = "The weather forecast shows a local storm.",
    webber = "A male sheep.",
    wendy = "Their cup hath runneth over.",
    wickerbottom = "Is it a ram or a wether? I don't want to know.",
    willow = "Shouldn't have charged him up.",
    wolfgang = "Sheep is mighty now!",
    woodie = "Looks like I'm in trouble now. Oops.",
    wx78 = "APPARENTLY EASY TO ANGER.",
}

Add.QuotesFor "shopkeeper" {
    
    GENERIC = "Odd place to set up a store.",
    wathgrithr = "Another traveller from the mortal world.",
    waxwell = "I forgot to thank you for that book you sold me.",
    webber = "Hello sir, can you help?",
    wendy = "A deceiver at heart.",
    wickerbottom = "A barterer.",
    willow = "I like the flag on his umbrella.",
    wolfgang = "Is talking umbrella.",
    woodie = "Men like this ran my lumber yard.",
    wx78 = "A PEDDLER OF GOODS.",
}    

Add.QuotesFor "chest_sky" {
    
    GENERIC = "I wonder whose it is?",
    wathgrithr = "I don't trust it.",
    waxwell = "Very fancy.",
    webber = "To put stuff we don't need.",
    wendy = "To transform some into others.",
    wickerbottom = "I can store what I don't need.",
    willow = "Put stuff in there and it stays there. It's magic.",
    wolfgang = "Is magic box.",
    woodie = "That's ominous, eh?",
    wx78 = "IT BEHAVES STRANGELY",
}

Add.QuotesFor "sky_lemur" {
    
    GENERIC = nil,
    wathgrithr = "Mmm, monkey meat.",
    waxwell = "For you, there's no esc-ape.",
    webber = "Stop monkeying around!",
    wendy = "What is your purpose?",
    wickerbottom = "A flying Lemuroidea.",
    willow = "Must be up to monkey business.",
    wolfgang = "Is my mate, the primate.",
    woodie = "What a cheeky fella.",
    wx78 = "STRIPED FLESHLING",
}

Add.QuotesFor "skyflies" {
    
    GENERIC = "I wonder how they light up like that?",
    wathgrithr = "Bright bugs.",
    waxwell = "An improvement on fireflies.",
    webber = "Flying bugs.",
    wendy = "Small lights of innocence.",
    wickerbottom = "A fly from the sky.",
    willow = "I prefer fireflies.",
    wolfgang = "Is hot swarm of bugs.",
    woodie = "They're warm.",
    wx78 = "SPARKLY",
}

Add.QuotesFor "skyflower" {
    
    GENERIC = "They smell of dreams.",
    wathgrithr = "The smell of victory!",
    waxwell = "The urge of stomping on them is still present.",
    webber = "Why do they only grow up here?",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "It's amazing the places things can grow.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",
}

Add.QuotesFor "skyflower.datura" {
    
    GENERIC = "It smells of nightmares.",
    wathgrithr = "Smells like defeat.",
    waxwell = "It smells like innocence. Ripe for the taking.",
    webber = "It makes us feel strange things.",
    wendy = "A flower to fuel hatred. Smells like a rose.",
    wickerbottom = "This one is designed to trigger a hate response. Smells like a burned book.",
    willow = "The stupid thing smells like winter mint.",
    wolfgang = "Smells like wimpy tears.",
    woodie = " It smells of wet fur and old pine.",
    wx78 = "IT OVERLOADS MY SENSORS WITH LIFE.",
}

Add.QuotesFor "skyflower_petals" {
    
    GENERIC = "They smell of dreams.",
    wathgrithr = "I should make myself a crown.",
    waxwell = "I'll make a bouquet for Charlie with these.",
    webber = "He hates me. He hates me not.",
    wendy = "A pretty flower to bring brief pleasure. Smells like decay.",
    wickerbottom = "Petals from a flower from the clouds.",
    willow = "Mmm. Smells like ashes.",
    wolfgang = "Pretty flower smells like beef.",
    woodie = "Ahh. Freshly fallen timber and pine needles.",
    wx78 = "YOUR TRICKS SHALL NOT WORK ON ME.",
}

Add.QuotesFor "skytrap" {
    
    GENERIC = "Something about that flower is off.",
    wathgrithr = "Suspicious.",
    waxwell = "Don't think you fool me.",
    webber = "I know what it's like being trapped.",
    wendy = "A Ya-Te-Veo?",
    wickerbottom = "Why do things need to cause harm?",
    willow = "A trap with no fire is no trap at all.",
    wolfgang = "Is a trap.",
    woodie = "Not too sure about that.",
    wx78 = "DANGER DETECTED",
}

Add.QuotesFor "smores" {
    
    GENERIC = "A messy ball of chocolate and cream.",
    wathgrithr = "It makes a real mess.",
    waxwell = "I prefer mine on the stick.",
    webber = "Granddad made these on fishing trips!",
    wendy = "A fireside treat.",
    wickerbottom = "A camping consumable.",
    willow = "See, fire improves everything.",
    wolfgang = "Wolfgang is always ready for s'mores.",
    woodie = "That's a right yummy treat.",
    wx78 = "STICKY BUT DELICIOUS",
}

Add.QuotesFor "tea_bush" {
    
    GENERIC = "Tea leaves grow on this bush.",
    wathgrithr = "It grows tea.",
    waxwell = "Perfect!",
    webber = "Smells like tea.",
    wendy = "From this grows the drink of diviners.",
    wickerbottom = "I could use those leaves for a beverage.",
    willow = "I could burn that.",
    wolfgang = "Get leaves, make drink.",
    woodie = "It's got tea on it.",
    wx78 = "I CAN USE ITS LEAVES",
}

Add.QuotesFor "tea_leaves" {
    
    GENERIC = "Regular old tea leaves.",
    wathgrithr = "I can brew it!",
    waxwell = "I prefer bagged tea.",
    webber = "Oh! So they don't come in a bag!",
    wendy = "Time to set the kettle.",
    wickerbottom = "These need a good stewing.",
    willow = " Leave me alone.",
    wolfgang = "Put in water.",
    woodie = "Dip them in hot water.",
    wx78 = "ADD HOT WATER",
}

Add.QuotesFor "thunder_log" {
    
    GENERIC = "It ripples with elecricity.",
    wathgrithr = "It sparks.",
    waxwell = "Still retains a measure of static.",
    webber = "This log sounds funny.",
    wendy = "Electrified.",
    wickerbottom = "A wooden battery; electricity is stored.",
    willow = "Will this even burn?",
    wolfgang = "Is tickly to touch.",
    woodie = "That's a right strange log.",
    wx78 = "I NEED TO KEEP IT AWAY FROM MY CIRCUITS",
}    

Add.QuotesFor "thunder_tree" {
    
    GENERIC = "Looks fragile, but dangerous.",
    wathgrithr = "Planted by Thor himself.",
    waxwell = "It has evolved to conduct lightning.",
    webber = "Yikes! It gathers lightning.",
    wendy = "It rumbles agianst its rooted restraints.",
    wickerbottom = "A tree with bio electricity; amazing!",
    willow = "Why doesn't the lightning burn it?",
    wolfgang = "Is crackly tree.",
    woodie = "Ah, I like a challenge.",
    wx78 = "I SHOULD BE CAREFUL",
}

Add.QuotesFor "thunderboards" {
    
    GENERIC = "Flat lightning.",
    wathgrithr = "Blessed by Thor.",
    waxwell = "I'm getting a bit board of this.",
    webber = nil,
    wendy = nil,
    wickerbottom = "Flat electrical boards",
    willow = "I called down the thunder.",
    wolfgang = "Is tickly flat wood.",
    woodie = "They still have a spark in them.",
    wx78 = "FLAT BUT STILL HAZARDOUS",
}

Add.QuotesFor "vine" {
    
    GENERIC = "A sentient vine!",
    wathgrithr = "A leafy serpent.",
    waxwell = "I heard about these on the vine.",
    webber = "A fine vine.",
    wendy = "The land itself despises my presence.",
    wickerbottom = "Often found on...*ahem*..wicker work.",
    willow = "It's made of plant, and therefore I can burn it.",
    wolfgang = "Little plant.",
    woodie = "Lucy, let's have some fun.",
    wx78 = "MOVING PLANT MATTER",
}

Add.QuotesFor "weather_machine" {
    
    GENERIC = "It's not a very consistent weather machine.",
    wathgrithr = "Too scientific. Where's my lightning?",
    waxwell = "Ah, now that's quite fascinating.",
    webber = "It's good to know things.",
    wendy = "What is your purpose?",
    wickerbottom = "Let's play dice with the atmosphere.",
    willow = "It does stuff. Not burning, sadly.",
    wolfgang = "Is...technical.",
    woodie = "More science? I'd rather go and chop wood.",
    wx78 = "I CONTROL THE ELEMENTS",
}

Add.QuotesFor "weaver_bird" {
    
    GENERIC = "It makes large nests to keep warm.",
    wathgrithr = "It keeps a warm home.",
    waxwell = "It's quite adept at twisting grass.",
    webber = "A yellow bird. Tweet!",
    wendy = "You build against the wind. You shall lose.",
    wickerbottom = "A golden Ploceidae.",
    willow = "Weave all the homes you want, I'll burn them all.",
    wolfgang = "Is little birdie.",
    woodie = "Weaver? More like w-evil.",
    wx78 = "HE IS AN ADEPT WEAVER",
}

Add.QuotesFor "weavernest" {
    
    GENERIC = "A warm nest made by birds.",
    wathgrithr = "A cozy home for little birds.",
    waxwell = "What a tangled nest he weaves.",
    webber = "I wonder if there are any eggs?",
    wendy = "One strong gust shall undo your work.",
    wickerbottom = "A home for Ploceidae.",
    willow = "A bird made it. ",
    wolfgang = "Bird lives here.",
    woodie = "The lair of a devil.",
    wx78 = "I CAN DO BETTER",
}

Add.QuotesFor "whirlwind" {
    
    GENERIC = "Who knows where that thing could send me.",
    wathgrithr = "A gift from Yggdrasill itself.",
    waxwell = "That could send me up and away from here.",
    webber = "Ah! And no cellar to hide in.",
    wendy = "Whisk me away from this miserable place.",
    wickerbottom = "That reminds me of an anemology book I need to read.",
    willow = "It's made of wind, fire's frenemy.",
    wolfgang = "Is fast air!",
    woodie = "Bit windy, eh?",
    wx78 = "WOOSH",
}

Add.QuotesFor "whitestaff" {
    
    GENERIC = "Packages objects through magic.",
    wathgrithr = "It moves the immovable.",
    waxwell = "I used to move mountains without any help. Look at me now.",
    webber = "I like this staff.",
    wendy = "Now I just need an egg, a duck and a hare.",
    wickerbottom = "Sometimes you've got to move mountains.",
    willow = "You just can't get the staff any more.",
    wolfgang = "Does things. Is always changing.",
    woodie = "Makeshift post office.",
    wx78 = "FOR MOVING THINGS",
}

Add.QuotesFor "wind_axe" {
    
    GENERIC = "It feels tingly.",
    wathgrithr = "An artifact of Thor!",
    waxwell = "The power of the wind.",
    webber = "You can never have enough logs.",
    wendy = "Nature's wrath in the palm of my hand.",
    wickerbottom = "Sharp as a diamond.",
    willow = "I'd prefer an Axe of Infernos.",
    wolfgang = "Yes! I like this new weapon!",
    woodie = "Not a patch on Lucy.",
    wx78 = "THIS IS A BAD IDEA",
}

Add.QuotesFor "winnie_staff" {
    
    GENERIC = nil,
    wathgrithr = "For herding mindless beasts.",
    waxwell = "I now command the beasts of the world.",
    webber = "Follow the leader!",
    wendy = "To lead the ignorant masses.",
    wickerbottom = "A shepherds staff",
    willow = "I could probably make a torch out of this.",
    wolfgang = "Is big carved stick.",
    woodie = "I'm quite good at making staves.",
    wx78 = "FOLLOW ME, MEATSACKS",
    winnie = "For herding my animal friends.",
}

-- Dunno if we'll ever need this, but I think it's gold.
Add.QuotesFor "rabbit_tea" {
    
    GENERIC = "Ew, it's got a hare in it!",
    wathgrithr = "Ew, it's got a hare in it!",
    waxwell = "Ew, it's got a hare in it!",
    webber = "Ew, it's got a hare in it!",
    wendy = "Ew, it's got a hare in it!",
    wickerbottom = "Ew, it's got a hare in it!",
    willow = "Ew, it's got a hare in it!",
    wolfgang = "Ew, it's got a hare in it!",
    woodie = "Ew, it's got a hare in it!",
    wx78 = "Ew, it's got a hare in it!",
    winnie = "Ew, it's got a hare in it!",
}

Add.QuotesFor "bean_brain" {
    
    GENERIC = "What a strange looking bean...",

}

Add.QuotesFor "bean_brain.inedible" {
    
    GENERIC = "There's not enough left to eat.",

}

------------------------------------------------------------------------


-- If the prefab names weren't in a table, this would cause issues with the
-- processing script for automatic quote adding.
Add.QuotesFor {"balloon_icehound", "balloon_firehound"} {
    ANY = function(character)
        return STRINGS.CHARACTERS[character].DESCRIBE.BALLOON_HOUND
    end,
}


------------------------------------------------------------------------

Add.StringsBy "ANY" {
    ANNOUNCE_CANFIX = "\nI think I can fix this!",
}

Add.StringsBy "GENERIC" {
	ACTIONFAIL = {
		CLIMB = {
			GENERIC = "I can't do that.",
			INVALID = "INVALID CLIMBING TARGET. THIS IS A BUG.",
			INUSE = "I should wait for the current poll to end.",
			GATHERPARTY = "I must gather my party before venturing forth.",
			COOLDOWN = "Someone already tried this too recently.",
		},
	},
}

------------------------------------------------------------------------

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
STRINGS.RECIPE_DESC.WHITESTAFF = "A white staff, for heavy lifting."
STRINGS.RECIPE_DESC.REFINED_WHITE_CRYSTAL = "A smoothed white gemstone."
STRINGS.RECIPE_DESC.REFINED_BLACK_CRYSTAL = "A pointy carved black gemstone."
STRINGS.RECIPE_DESC.THUNDERBOARDS = "Shocking blue planks of wood."
STRINGS.RECIPE_DESC.BEANSTALK_WALL_ITEM = "Grow your own walls."
STRINGS.RECIPE_DESC.CRYSTAL_WALL_ITEM = "Elegant yet durable."
STRINGS.RECIPE_DESC.REFINER = "Smash, crunch, create."
STRINGS.RECIPE_DESC.WIND_AXE = "Stormy weather in your hands."
STRINGS.RECIPE_DESC.BEANLET_ARMOR = "Armor that takes the weight off."
STRINGS.RECIPE_DESC.MUSHROOM_HAT = "For the fungi in all of us."
STRINGS.RECIPE_DESC.CLOUD_WALL_ITEM = "Its usefulness is questionable."

STRINGS.POTION_NAMES = {
    "Mysterious",
    "Strange",
    "Interesting",
    "Alluring",
    "Enticing",
    "Odd",
}

STRINGS.GUMMYBEAR_NAMES = { 
    "Moisty", 
    "Yummy", 
    "Chewy", 
    "Sticky", 
    "Skippy", 
    "Laughy", 
    "Cutey", 
    "Cuddly", 
    "Gnawry", 
    "Gooey", 
    "Jumpy", 
    "Play-y", 
    "Stabby", 
    "Cutty", 
    "Devourer-y", 
    "Hungry", 
    "Tenderly", 
}

STRINGS.WINNIE_SHEEP_NAMES = {
    "Facy",
    "Mariane",
    "Sedgewic",
    "Charlie",
    "Bear",
}

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
    CRAFTING = {
        NEEDRESEARCHLECTERN = ("Use a %s to build a prototype!"):format( STRINGS.NAMES.RESEARCH_LECTERN ),
    },
	CLIMBINGSCREEN = {
		UP = {
			TITLE = "Up and Away",
			BODY = "The land above is strange and foreign. Do you want to continue?",
			BUTTONS = {
				YES = "YES",
				NO = "NO",
				REGEN = "REGEN",
			},
			REGEN = {
				TITLE = "Warning!",
				BODY = "You are about to erase your cloud world.\nAre you sure you want to continue?",
				BUTTONS = {
					YES = "YES",
					NO = "NO",
				},
			}
		},
		DOWN = {
			TITLE = "Up and Away",
			BODY = "Would you like to return to the world below?",
			BUTTONS = {
				YES = "YES",
				NO = "NO",
			},
		},
	},
}   
