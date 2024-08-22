if not GLOBAL.STRINGS.CHARACTERS.WATHOM then 
    return
end 

local WATHOMDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WATHOM.DESCRIBE 
local WINKYDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WINKY.DESCRIBE
local WIXIEDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WIXIE.DESCRIBE 

local CHARACTERDESCRIBE = {
    WATHOMDESCRIBE, 
    WINKYDESCRIBE,
    WIXIEDESCRIBE,
}

WATHOMDESCRIBE.CLOCKWORK_TOWER = "Still chess. I hate chess."
WATHOMDESCRIBE.JAID_PLANT_PLANT = "Plant, medicinal."
WATHOMDESCRIBE.PLANTAID = "Plant matter, stimulates healing."
WATHOMDESCRIBE.STERILIZED_PLANTAID = "Dried plant matter, stimulates greater healing."
WATHOMDESCRIBE.INSECT_MEAT_RAW = "Meat, nutritious." -- insect meat foods: liked
WATHOMDESCRIBE.INSECT_MEAT_COOKED = "Have had worse. Much, much worse."
WATHOMDESCRIBE.INSECT_MEAT_DRIED = "Meat, nutritious and dried. Stimulates healing."
WATHOMDESCRIBE.CROAKUEMBOUCHE = "Meats, drizzled in spinal fluid. Taught by the chef."
WATHOMDESCRIBE.NUTRIENTPASTE = "Meats, blended and cooked. Extremely nutritious."
WATHOMDESCRIBE.GARDENSLUG = "Disguised, hidden in plain sight."
WATHOMDESCRIBE.SLUGLING = "A pitiful defense mechanism."
WATHOMDESCRIBE.FLINTCHICK = "Rockbird. Origin… deep, deep underground. Magical potential, frightening."
WATHOMDESCRIBE.BEEBEETLE = "Bee, semi-aquatic."
WATHOMDESCRIBE.KILLERBEEBEETLE = "Bee, semi-aquatic and angry."
WATHOMDESCRIBE.BEEBEETLEDEN = "Bee den. Runs miles deep."
WATHOMDESCRIBE.BEEBEETLEBOULDER = "Flesh, transformed into something sweeter."

WINKYDESCRIBE.CLOCKWORK_TOWER = "Give me whatever's in your head! It's mine!"
WINKYDESCRIBE.JAID_PLANT_PLANT = "Almost looks edible..."
WINKYDESCRIBE.PLANTAID = "Not edible. Very bitter. I'll just use it like everyone else."
WINKYDESCRIBE.STERILIZED_PLANTAID = "I wouldn't say sterilizing anything matters, but it works."
WINKYDESCRIBE.INSECT_MEAT_RAW = "Super slimy, smells nice too." -- insect meat foods: loved
WINKYDESCRIBE.INSECT_MEAT_COOKED = "I wish every steak smelt this nice!"
WINKYDESCRIBE.INSECT_MEAT_DRIED = "Less fragrant, but more chewy as a compromise."
WINKYDESCRIBE.CROAKUEMBOUCHE = "All a rat could ever ask for."
WINKYDESCRIBE.NUTRIENTPASTE = "No one else really seems to like it. More for me!"
WINKYDESCRIBE.GARDENSLUG = "Found you! Now, give me those plants!"
WINKYDESCRIBE.SLUGLING = "Out of the way, your mother has something I want!"
WINKYDESCRIBE.FLINTCHICK = "It's trying to be cute. Shouldn't have been so shiny, though."
WINKYDESCRIBE.BEEBEETLE = "Make me more honey!"
WINKYDESCRIBE.KILLERBEEBEETLE = "Don't stop me from taking whats mine!"
WINKYDESCRIBE.BEEBEETLEDEN = "That honey is mine!"
WINKYDESCRIBE.BEEBEETLEBOULDER = "I'd get my family to bring it home, but they'd eat it before we are halfway there."

WIXIEDESCRIBE.CLOCKWORK_TOWER = "Stomp, stomp, stomp. Ya ever tried being quiet?"
WIXIEDESCRIBE.JAID_PLANT_PLANT = "Can't go wrong with a bandage plant."
WIXIEDESCRIBE.PLANTAID = "It'll heal a scratch or two."
WIXIEDESCRIBE.STERILIZED_PLANTAID = "Like a bandage, but... worse."
WIXIEDESCRIBE.INSECT_MEAT_RAW = "Ugh. Could I just throw this one out?" -- insect meat foods: disliked
WIXIEDESCRIBE.INSECT_MEAT_COOKED = "Somehow still slimy. So, so slimy."
WIXIEDESCRIBE.INSECT_MEAT_DRIED = "Dry and slimy at the same time."
WIXIEDESCRIBE.CROAKUEMBOUCHE = "Huh. Can't believe Warly figured out how to make this stuff taste good."
WIXIEDESCRIBE.NUTRIENTPASTE = "I'd rather slingshot it away, but I'd also rather not get that smell everywhere."
WIXIEDESCRIBE.GARDENSLUG = "You were there this entire time?"
WIXIEDESCRIBE.SLUGLING = "Stop blocking my shots!"
WIXIEDESCRIBE.FLINTCHICK = "Cute. Almost too cute..."
WIXIEDESCRIBE.BEEBEETLE = "Pick one or the other, weirdo."
WIXIEDESCRIBE.KILLERBEEBEETLE = "What's she so mad about?"
WIXIEDESCRIBE.BEEBEETLEDEN = "Weirdo home."
WIXIEDESCRIBE.BEEBEETLEBOULDER = "If only it could fit in my slingshot."

for _, CHARACTER in pairs(CHARACTERDESCRIBE) do 
    CHARACTER.JAID_PLANT_ROOT = CHARACTER.JAID_PLANT_PLANT

    CHARACTER.STONECHICK = CHARACTER.FLINTCHICK
    CHARACTER.REDGOLDCHICK = CHARACTER.FLINTCHICK
    CHARACTER.BLUEGOLDCHICK = CHARACTER.FLINTCHICK

    CHARACTER.FLOATY_FLINT = CHARACTER.FLINT
    CHARACTER.FLOATY_ROCKS = CHARACTER.ROCKS 
    CHARACTER.FLOATY_NITRE = CHARACTER.NITRE 
    CHARACTER.FLOATY_GOLDNUGGET = CHARACTER.GOLDNUGGET

    CHARACTER.HIBEEBEETLE = CHARACTER.BEEBEETLE
    CHARACTER.HIBEEBEETLEBOULDER = CHARACTER.BEEBEETLEBOULDER
end 