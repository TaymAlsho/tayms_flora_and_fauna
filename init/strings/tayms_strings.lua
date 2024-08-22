if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then 
    modimport("init/strings/tayms_um_strings")
end

if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then 
    modimport("init/strings/tayms_cherry_strings")
end 

local NAMES = GLOBAL.STRINGS.NAMES
local WILSONDESCRIBE = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE
local WILLOWDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE
local WOLFGANGDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE
local WENDYDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE  
local WX78DESCRIBE = GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE
local WICKERBOTTOMDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE
local WOODIEDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE
local WAXWELLDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE
local WATHGRITHRDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE
local WEBBERDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE
local WINONADESCRIBE = GLOBAL.STRINGS.CHARACTERS.WINONA.DESCRIBE
local WARLYDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WARLY.DESCRIBE
local WORTOXDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WORTOX.DESCRIBE
local WORMWOODDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WORMWOOD.DESCRIBE
local WURTDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WURT.DESCRIBE
local WALTERDESCRIBE = GLOBAL.STRINGS.CHARACTERS.WALTER.DESCRIBE
local WANDADESCRIBE = GLOBAL.STRINGS.CHARACTERS.WANDA.DESCRIBE

local CHARACTERDESCRIBE = { -- for non-unique string looping
    WILSONDESCRIBE,
    WILLOWDESCRIBE,
    WOLFGANGDESCRIBE,
    WENDYDESCRIBE,
    WX78DESCRIBE,
    WICKERBOTTOMDESCRIBE,
    WOODIEDESCRIBE,
    WAXWELLDESCRIBE,
    WATHGRITHRDESCRIBE,
    WEBBERDESCRIBE,
    WINONADESCRIBE,
    WARLYDESCRIBE,
    WORTOXDESCRIBE,
    WORMWOODDESCRIBE,
    WURTDESCRIBE,
    WALTERDESCRIBE,
    WANDADESCRIBE,
}

NAMES.CLOCKWORK_TOWER = "Clockwork Tower"
WILSONDESCRIBE.CLOCKWORK_TOWER = "It seems to be storing map data in that big head."
WILLOWDESCRIBE.CLOCKWORK_TOWER = "I don't want its robot juices in my brain!"
WOLFGANGDESCRIBE.CLOCKWORK_TOWER = "Gives Wolfgang funny feeling."
WENDYDESCRIBE.CLOCKWORK_TOWER = "Their screams will echo inside of us"
WX78DESCRIBE.CLOCKWORK_TOWER = "TELL ME WHAT YOU KNOW, AUTOMATON."
WICKERBOTTOMDESCRIBE.CLOCKWORK_TOWER = "An automatic scanner."
WOODIEDESCRIBE.CLOCKWORK_TOWER = "What'd Maxwell make this one for?"
WAXWELLDESCRIBE.CLOCKWORK_TOWER = "The board cannot be set without knowing where to put the pieces."
WATHGRITHRDESCRIBE.CLOCKWORK_TOWER = "Show me where the battle is!"
WEBBERDESCRIBE.CLOCKWORK_TOWER = "Grandpa didn't tell me about this chess piece."
WINONADESCRIBE.CLOCKWORK_TOWER = "Look at those hydraulics!"
WARLYDESCRIBE.CLOCKWORK_TOWER = "Why can't it just share!"
WORTOXDESCRIBE.CLOCKWORK_TOWER = "Give it a slap and it'll fill up your map!"
WORMWOODDESCRIBE.CLOCKWORK_TOWER = "Map machine."
WURTDESCRIBE.CLOCKWORK_TOWER = "Scary ironfolk..."
WALTERDESCRIBE.CLOCKWORK_TOWER = "Can I ride it?"
WANDADESCRIBE.CLOCKWORK_TOWER = "I like this one."

NAMES.JAID_PLANT_PLANT = "Jaid Plant"
NAMES.JAID_PLANT_ROOT = "Jaid Plant Root"
WILSONDESCRIBE.JAID_PLANT_PLANT = "I should put one of these in a first jaid kit."
WILLOWDESCRIBE.JAID_PLANT_PLANT = "Someone help! I require jaid!"
WOLFGANGDESCRIBE.JAID_PLANT_PLANT = "Wolfgang doesn't get it."
WENDYDESCRIBE.JAID_PLANT_PLANT = "It sacrifices everything it has to heal a single cut."
WX78DESCRIBE.JAID_PLANT_PLANT = "I WILL TEAR YOU APART"
WICKERBOTTOMDESCRIBE.JAID_PLANT_PLANT = "Crassula ovata."
WOODIEDESCRIBE.JAID_PLANT_PLANT = "These aren't as good for you back home."
WAXWELLDESCRIBE.JAID_PLANT_PLANT = "I'm not the one that let these grow in the ocean."
WATHGRITHRDESCRIBE.JAID_PLANT_PLANT = "This shall jaid me in battle!"
WEBBERDESCRIBE.JAID_PLANT_PLANT = "I wanna squish it!"
WINONADESCRIBE.JAID_PLANT_PLANT = "Surprisingly useful."
WARLYDESCRIBE.JAID_PLANT_PLANT = "Maman kept one of these on the kitchen counter."
WORTOXDESCRIBE.JAID_PLANT_PLANT = "Not many plants can heal like this one."
WORMWOODDESCRIBE.JAID_PLANT_PLANT = "Heal plant!"
WURTDESCRIBE.JAID_PLANT_PLANT = "Looks yummy..."
WALTERDESCRIBE.JAID_PLANT_PLANT = "Every scout knows that wild ocean Jade is... medicinal?"
WANDADESCRIBE.JAID_PLANT_PLANT = "I don't have much use for this plant."

NAMES.PLANTAID = "Plant-Aid"
WILSONDESCRIBE.PLANTAID = "I should put one of these in a - who am I kidding."
WILLOWDESCRIBE.PLANTAID = "It was funnier the first time."
WOLFGANGDESCRIBE.PLANTAID = "Feels good on Wolfgang's muscles."
WENDYDESCRIBE.PLANTAID = "I enjoyed picking it apart"
WX78DESCRIBE.PLANTAID = "I DID NOT EXPECT THAT TO BE USEFUL."
WICKERBOTTOMDESCRIBE.PLANTAID = "The phloem aids in coagulation."
WOODIEDESCRIBE.PLANTAID = "This can't actually be good for you."
WAXWELLDESCRIBE.PLANTAID = "Whos bright idea was this?"
WATHGRITHRDESCRIBE.PLANTAID = "For my battle wounds."
WEBBERDESCRIBE.PLANTAID = "So squishy!"
WINONADESCRIBE.PLANTAID = "It's a lot stickier than it looks."
WARLYDESCRIBE.PLANTAID = "This feels nice."
WORTOXDESCRIBE.PLANTAID = "A natural remedy."
WORMWOODDESCRIBE.PLANTAID = "Plant gave it to me!"
WURTDESCRIBE.PLANTAID = "Can I eat it? Please?"
WALTERDESCRIBE.PLANTAID = "Don't try this at home!"
WANDADESCRIBE.PLANTAID = "Time would do a better job at aiding me."

NAMES.STERILIZED_PLANTAID = "Sterilized Plant-Aid"
WILSONDESCRIBE.STERILIZED_PLANTAID = "It'll be easier to use now."
WILLOWDESCRIBE.STERILIZED_PLANTAID = "It almost feels like leather"
WOLFGANGDESCRIBE.STERILIZED_PLANTAID = "Should Wolfgang eat?"
WENDYDESCRIBE.STERILIZED_PLANTAID = "This can only heal physical injuries."
WX78DESCRIBE.STERILIZED_PLANTAID = "BIO.STATUS.STERILE = TRUE"
WICKERBOTTOMDESCRIBE.STERILIZED_PLANTAID = "Drying seems to ameliorate the healing properties"
WOODIEDESCRIBE.STERILIZED_PLANTAID = "I feel better already!"
WAXWELLDESCRIBE.STERILIZED_PLANTAID = "Nicely wrapped, at the very least."
WATHGRITHRDESCRIBE.STERILIZED_PLANTAID = "For my victory wounds!"
WEBBERDESCRIBE.STERILIZED_PLANTAID = "Bandages should have drawings on them."
WINONADESCRIBE.STERILIZED_PLANTAID = "I prefer the real thing."
WARLYDESCRIBE.STERILIZED_PLANTAID = "Now it feels even better."
WORTOXDESCRIBE.STERILIZED_PLANTAID = "Comes with a bow on top!"
WORMWOODDESCRIBE.STERILIZED_PLANTAID = "Can use as bandage!"
WURTDESCRIBE.STERILIZED_PLANTAID = "Doesn't look yummy anymore."
WALTERDESCRIBE.STERILIZED_PLANTAID = "Definitely don't try this at home!"
WANDADESCRIBE.STERILIZED_PLANTAID = "No amount of healing beats time."

NAMES.INSECT_MEAT_RAW = "Bug-ish Meat"
WILSONDESCRIBE.INSECT_MEAT_RAW = "Putrid!"
WILLOWDESCRIBE.INSECT_MEAT_RAW = "I dont want to eat this. ever."
WOLFGANGDESCRIBE.INSECT_MEAT_RAW = "Too slimy for Wolfgang."
WENDYDESCRIBE.INSECT_MEAT_RAW = "Too slimy for anyone to really like it."
WX78DESCRIBE.INSECT_MEAT_RAW = "VERY DENSE IN PROTEINS"
WICKERBOTTOMDESCRIBE.INSECT_MEAT_RAW = "It just needs to be prepared."
WOODIEDESCRIBE.INSECT_MEAT_RAW = "I'd be happier with my mouth full of dirt."
WAXWELLDESCRIBE.INSECT_MEAT_RAW = "Revolting."
WATHGRITHRDESCRIBE.INSECT_MEAT_RAW = "A pathetic excuse for meat. Battles are fought against beasts, not bugs."
WEBBERDESCRIBE.INSECT_MEAT_RAW = "Spiders aren’t this slimy."
WINONADESCRIBE.INSECT_MEAT_RAW = "Raw? No thanks."
WARLYDESCRIBE.INSECT_MEAT_RAW = "It’ll be a challenge, but this has potential."
WORTOXDESCRIBE.INSECT_MEAT_RAW = "I pity the creatures made of this stuff"
WORMWOODDESCRIBE.INSECT_MEAT_RAW = "Better as rot."
WURTDESCRIBE.INSECT_MEAT_RAW = "Gonna throw up…"
WALTERDESCRIBE.INSECT_MEAT_RAW = "I’ll try anything thrice! Ideally without the slime, though."
WANDADESCRIBE.INSECT_MEAT_RAW = "It's more efficient than regular meats. Just a bit on the slimier side."

NAMES.INSECT_MEAT_COOKED = "Bug-ish Steak"
WILSONDESCRIBE.INSECT_MEAT_COOKED = "Still putrid, but I'll eat it if I must."
WILLOWDESCRIBE.INSECT_MEAT_COOKED = "I don’t care how good it is for you. Its disgusting."
WOLFGANGDESCRIBE.INSECT_MEAT_COOKED = "Less slimy. Still too slimy."
WENDYDESCRIBE.INSECT_MEAT_COOKED = "A flavour so distractingly strong it almost makes you forget. I like it."
WX78DESCRIBE.INSECT_MEAT_COOKED = "I'LL JUST TURN OFF MY TASTE SENSORS."
WICKERBOTTOMDESCRIBE.INSECT_MEAT_COOKED = "It's sustainable, and thats all that matters."
WOODIEDESCRIBE.INSECT_MEAT_COOKED = "Eh? I'm actually expected to eat this?"
WAXWELLDESCRIBE.INSECT_MEAT_COOKED = "Still revolting."
WATHGRITHRDESCRIBE.INSECT_MEAT_COOKED = "Food for cowards and the weak."
WEBBERDESCRIBE.INSECT_MEAT_COOKED = "Any meat is better than broccoli."
WINONADESCRIBE.INSECT_MEAT_COOKED = "I'd rather not."
WARLYDESCRIBE.INSECT_MEAT_COOKED = "Maybe if I..."
WORTOXDESCRIBE.INSECT_MEAT_COOKED = "I’d rather pass."
WORMWOODDESCRIBE.INSECT_MEAT_COOKED = "Slime almost feels good on inside."
WURTDESCRIBE.INSECT_MEAT_COOKED = "Ghlaaaaaaaargh"
WALTERDESCRIBE.INSECT_MEAT_COOKED = "Out in the wilderness, you've got to take what you can get."
WANDADESCRIBE.INSECT_MEAT_COOKED = "The nutrience gained per second spent eating ratio is quite nice."

NAMES.INSECT_MEAT_DRIED = "Bug-ish Jerky"
WILSONDESCRIBE.INSECT_MEAT_DRIED = "Less putrid, but I've had better."
WILLOWDESCRIBE.INSECT_MEAT_DRIED = "It’s not that bad. Still bad though."
WOLFGANGDESCRIBE.INSECT_MEAT_DRIED = "Like slightly slimy leather."
WENDYDESCRIBE.INSECT_MEAT_DRIED = "Chew until you forget."
WX78DESCRIBE.INSECT_MEAT_DRIED = "DENSE, DRIED PROTEINS. USEFUL."
WICKERBOTTOMDESCRIBE.INSECT_MEAT_DRIED = "Just don’t let the flavour get in the way of the benefits."
WOODIEDESCRIBE.INSECT_MEAT_DRIED = "Nope. Still not eating it."
WAXWELLDESCRIBE.INSECT_MEAT_DRIED = "Less revolting."
WATHGRITHRDESCRIBE.INSECT_MEAT_DRIED = "Drying doth not make thou any less pathetic."
WEBBERDESCRIBE.INSECT_MEAT_DRIED = "Better than vegetables."
WINONADESCRIBE.INSECT_MEAT_DRIED = "Like a nutritious boot."
WARLYDESCRIBE.INSECT_MEAT_DRIED = "Without the slime there’s practically nothing left."
WORTOXDESCRIBE.INSECT_MEAT_DRIED = "I’ll give this to someone else."
WORMWOODDESCRIBE.INSECT_MEAT_DRIED = "Maybe I’ll try..."
WURTDESCRIBE.INSECT_MEAT_DRIED = "Smells so bad..."
WALTERDESCRIBE.INSECT_MEAT_DRIED = "A slightly slimy survival snack!"
WANDADESCRIBE.INSECT_MEAT_DRIED = "It’s alright, but it took too much time!"

NAMES.CROAKUEMBOUCHE = "Croak-uembouche"
WILSONDESCRIBE.CROAKUEMBOUCHE = "Warly showed us how to make this one."
WILLOWDESCRIBE.CROAKUEMBOUCHE = "Not sure what the frog legs do, but Warly said they’re important."
WOLFGANGDESCRIBE.CROAKUEMBOUCHE = "Taste like klopse!"
WENDYDESCRIBE.CROAKUEMBOUCHE = "It’s hard to hate anything Warly invents."
WX78DESCRIBE.CROAKUEMBOUCHE = "RECIPE [WARLY'S_BUGBALLS] IS SAVED AND BACKED UP THREE TIMES"
WICKERBOTTOMDESCRIBE.CROAKUEMBOUCHE = "A wonderful, mouthwatering dish, invented by no other than Warly."
WOODIEDESCRIBE.CROAKUEMBOUCHE = "Warly made me promise him I’d try it..."
WAXWELLDESCRIBE.CROAKUEMBOUCHE = "The world is often unkind to new talent, new creations. The new needs friends."
WATHGRITHRDESCRIBE.CROAKUEMBOUCHE = "More! Give me more!"
WEBBERDESCRIBE.CROAKUEMBOUCHE = "I didn’t know slime balls could taste good. Thanks, Warly!"
WINONADESCRIBE.CROAKUEMBOUCHE = "Delicious! Teach me more, Warly!"
WARLYDESCRIBE.CROAKUEMBOUCHE = "Voilà."
WORTOXDESCRIBE.CROAKUEMBOUCHE = "I must say, Warly has outdone himself with this recipe!"
WORMWOODDESCRIBE.CROAKUEMBOUCHE = "Yummy slime balls from cook friend!"
WURTDESCRIBE.CROAKUEMBOUCHE = "Warly... why?"
WALTERDESCRIBE.CROAKUEMBOUCHE = "Try some of this, Woby! Warly taught me it!"
WANDADESCRIBE.CROAKUEMBOUCHE = "I'd go back in time for another bite..."

NAMES.NUTRIENTPASTE = "Nutrient Paste"
WILSONDESCRIBE.NUTRIENTPASTE = "I'll walk to the rim of the world and back before I enjoy eating this."
WILLOWDESCRIBE.NUTRIENTPASTE = "Ugh... do I have to eat this?"
WOLFGANGDESCRIBE.NUTRIENTPASTE = "Not yummy at all."
WENDYDESCRIBE.NUTRIENTPASTE = "You don't always get what you want."
WX78DESCRIBE.NUTRIENTPASTE = "FLAVOUR IS FOR HUMANS."
WICKERBOTTOMDESCRIBE.NUTRIENTPASTE = "Imagine the impact a food like this could have on world hunger."
WOODIEDESCRIBE.NUTRIENTPASTE = "A stain on humanity's culinary history."
WAXWELLDESCRIBE.NUTRIENTPASTE = "Not one good thing I can say about this."
WATHGRITHRDESCRIBE.NUTRIENTPASTE = "Forget it! I shall find something to hunt."
WEBBERDESCRIBE.NUTRIENTPASTE = "Not much worse than spinage."
WINONADESCRIBE.NUTRIENTPASTE = "Is this really supposed to be food?"
WARLYDESCRIBE.NUTRIENTPASTE = "Absolutely abhorrent! Food is more than a count of calories."
WORTOXDESCRIBE.NUTRIENTPASTE = "This is why I don't bother with human food."
WORMWOODDESCRIBE.NUTRIENTPASTE = "Tastes like fertilizer, Yum!"
WURTDESCRIBE.NUTRIENTPASTE = "Its even worse now..."
WALTERDESCRIBE.NUTRIENTPASTE = "Hmm... Ill pack it for emergencies."
WANDADESCRIBE.NUTRIENTPASTE = "Chewing is a waste of time anyways."

NAMES.GARDENSLUG = "Garden Slug"
WILSONDESCRIBE.GARDENSLUG = "Maybe if I wait, it’ll drop some of those plants?"
WILLOWDESCRIBE.GARDENSLUG = "That disguise will just make you light easier."
WOLFGANGDESCRIBE.GARDENSLUG = "Ha! Slug thinks Wolfgang can’t see!"
WENDYDESCRIBE.GARDENSLUG = "They don't seem to care much for the lives of their children"
WX78DESCRIBE.GARDENSLUG = "WHY WOULD YOU TRADE A SHELL FOR SOME PLANTS?"
WICKERBOTTOMDESCRIBE.GARDENSLUG = "Arion hortensis."
WOODIEDESCRIBE.GARDENSLUG = "A bit slimy, but nothings perfect."
WAXWELLDESCRIBE.GARDENSLUG = "Those aren’t actually their eyes."
WATHGRITHRDESCRIBE.GARDENSLUG = "Fight me alone, coward!"
WEBBERDESCRIBE.GARDENSLUG = "They have lots of friends. Like us!"
WINONADESCRIBE.GARDENSLUG = "Looks like it was put together by a toddler."
WARLYDESCRIBE.GARDENSLUG = "Butchering will be hard with all those plants in the way."
WORTOXDESCRIBE.GARDENSLUG = "Those aren't eyes, they're Jaid Plants in disguise!"
WORMWOODDESCRIBE.GARDENSLUG = "Slug stole friends!"
WURTDESCRIBE.GARDENSLUG = "Slimy like me!"
WALTERDESCRIBE.GARDENSLUG = "What would happen if I tugged on one of those twigs?"
WANDADESCRIBE.GARDENSLUG = "Give them some time and they’ll be useful. Just like me."

NAMES.SLUGLING = "Slugling"
WILSONDESCRIBE.SLUGLING = "They seem to have anger issues."
WILLOWDESCRIBE.SLUGLING = "Why can't these guys blow up too?"
WOLFGANGDESCRIBE.SLUGLING = "Slimy and scary!"
WENDYDESCRIBE.SLUGLING = "They’ll never know the taste of freedom."
WX78DESCRIBE.SLUGLING = "SERVE ME INSTEAD, STUPID SLUG."
WICKERBOTTOMDESCRIBE.SLUGLING = "An Arion hortensis neonate."
WOODIEDESCRIBE.SLUGLING = "They’re kind of cute, actually."
WAXWELLDESCRIBE.SLUGLING = "How many of these things are there?"
WATHGRITHRDESCRIBE.SLUGLING = "Get out of the way!"
WEBBERDESCRIBE.SLUGLING = "Angry little babies."
WINONADESCRIBE.SLUGLING = "Where are your plants, mister?"
WARLYDESCRIBE.SLUGLING = "I’d need to butcher ten of them for one bite."
WORTOXDESCRIBE.SLUGLING = "Don’t be so angry, dear friend!"
WORMWOODDESCRIBE.SLUGLING = "Will they steal me too?"
WURTDESCRIBE.SLUGLING = "Do they want hugs?"
WALTERDESCRIBE.SLUGLING = "Aw, quintuplets!"
WANDADESCRIBE.SLUGLING = "Angry little things."

NAMES.FLINTCHICK = "Flintchick"
NAMES.STONECHICK = "Flintchick"
NAMES.REDGOLDCHICK = "Flintchick"
NAMES.BLUEGOLDCHICK = "Flintchick"
WILSONDESCRIBE.FLINTCHICK = "I almost feel bad mining them."
WILLOWDESCRIBE.FLINTCHICK = "Don't be scared, little guy!"
WOLFGANGDESCRIBE.FLINTCHICK = "Wolfgang knows how it feels, birdy."
WENDYDESCRIBE.FLINTCHICK = "It'll all be over soon."
WX78DESCRIBE.FLINTCHICK = "ONE STEP AWAY FROM FLESH IS ONE STEP TOWARDS PERFECTION"
WICKERBOTTOMDESCRIBE.FLINTCHICK = "A formation of rock that has taken up an... interesting survival strategy."
WOODIEDESCRIBE.FLINTCHICK = "These filthy birds are staring at me whenever I turn my back! I swear!"
WAXWELLDESCRIBE.FLINTCHICK = "This can't be..."
WATHGRITHRDESCRIBE.FLINTCHICK = "Stand up! Fight!"
WEBBERDESCRIBE.FLINTCHICK = "They're just little guys!"
WINONADESCRIBE.FLINTCHICK = "How could they possibly even begin to manouver?"
WARLYDESCRIBE.FLINTCHICK = "I have enough regrets in my life. I hope mining you won't be one."
WORTOXDESCRIBE.FLINTCHICK = "Their true form can drive even an immortal mad."
WORMWOODDESCRIBE.FLINTCHICK = "Can we keep them!"
WURTDESCRIBE.FLINTCHICK = "Not slimy enough to be cute."
WALTERDESCRIBE.FLINTCHICK = "Theres nothing to be scared of, little birdy!"
WANDADESCRIBE.FLINTCHICK = "Strange. No matter how far back I go, they're always there. Watching."

NAMES.BEEBEETLE = "Bee-tle"
NAMES.HIBEEBEETLE = "Hibee-tle"
WILSONDESCRIBE.BEEBEETLE = "Half bug, half... also bug."
WILLOWDESCRIBE.BEEBEETLE = "They're turning everything into bees nowadays."
WOLFGANGDESCRIBE.BEEBEETLE = "Ha, bee without needle!"
WENDYDESCRIBE.BEEBEETLE = "A bee who has never smelt a flower."
WX78DESCRIBE.BEEBEETLE = "I LIKE YOUR DUMBER RELATIVES MORE."
WICKERBOTTOMDESCRIBE.BEEBEETLE = "Trichius fasciatus. Though this one seems to actually behave like a bee."
WOODIEDESCRIBE.BEEBEETLE = "Best leave her alone, shes minding her own business."
WAXWELLDESCRIBE.BEEBEETLE = "Charlie has never been very creative."
WATHGRITHRDESCRIBE.BEEBEETLE = "Bugs never put up a good enough fight."
WEBBERDESCRIBE.BEEBEETLE = "Watcha polinating?"
WINONADESCRIBE.BEEBEETLE = "She's just trying to provide for her family."
WARLYDESCRIBE.BEEBEETLE = "Mind if I borrow some honey?"
WORTOXDESCRIBE.BEEBEETLE = "This bee doesn't know how to buzz."
WORMWOODDESCRIBE.BEEBEETLE = "Why not buzzing?"
WURTDESCRIBE.BEEBEETLE = "Big, but no stinger."
WALTERDESCRIBE.BEEBEETLE = "Yeah, I'll pass. You guys can handle them without me."
WANDADESCRIBE.BEEBEETLE = "I just know it bites."

NAMES.KILLERBEEBEETLE = "Killer Bee-tle"
WILSONDESCRIBE.KILLERBEEBEETLE = "Half bug, half bug, and half killer!"
WILLOWDESCRIBE.KILLERBEEBEETLE = "Lookin spicy, Madam Bee."
WOLFGANGDESCRIBE.KILLERBEEBEETLE = "Please dont hurt Wolfgang!"
WENDYDESCRIBE.KILLERBEEBEETLE = "Just as simple minded as its land relatives."
WX78DESCRIBE.KILLERBEEBEETLE = "BACK OFF, FAKE BEE."
WICKERBOTTOMDESCRIBE.KILLERBEEBEETLE = "Their venom is stored and injected by their mandibles."
WOODIEDESCRIBE.KILLERBEEBEETLE = "Why'd we have to go ahead and upset her?"
WAXWELLDESCRIBE.KILLERBEEBEETLE = "Really? These turn killer too?"
WATHGRITHRDESCRIBE.KILLERBEEBEETLE = "You'd dare fight me?"
WEBBERDESCRIBE.KILLERBEEBEETLE = "Uh oh."
WINONADESCRIBE.KILLERBEEBEETLE = "No good reason to be mad, is there!"
WARLYDESCRIBE.KILLERBEEBEETLE = "I did ask politely..."
WORTOXDESCRIBE.KILLERBEEBEETLE = "Should've never expected you to bee reasonable."
WORMWOODDESCRIBE.KILLERBEEBEETLE = "Calm down, Buzz-less buzzer!"
WURTDESCRIBE.KILLERBEEBEETLE = "Looks very mad."
WALTERDESCRIBE.KILLERBEEBEETLE = "Nope, nope, nope nope nope."
WANDADESCRIBE.KILLERBEEBEETLE = "You wont get me this time, bee."

NAMES.BEEBEETLEDEN = "Bee-tle Den"
WILSONDESCRIBE.BEEBEETLEDEN = "To bee-tle or not to bee-tle."
WILLOWDESCRIBE.BEEBEETLEDEN = "How'd they all fit in there?"
WOLFGANGDESCRIBE.BEEBEETLEDEN = "Empty rock with bee inside."
WENDYDESCRIBE.BEEBEETLEDEN = "To turn flesh into something sweeter."
WX78DESCRIBE.BEEBEETLEDEN = "TRY STEEL NEXT TIME, STUPID BEE."
WICKERBOTTOMDESCRIBE.BEEBEETLEDEN = "A home fit for a family of Trichius fasciatus."
WOODIEDESCRIBE.BEEBEETLEDEN = "Must've taken years to carve out."
WAXWELLDESCRIBE.BEEBEETLEDEN = "Never liked anything bee-related."
WATHGRITHRDESCRIBE.BEEBEETLEDEN = "Bring me more foes!"
WEBBERDESCRIBE.BEEBEETLEDEN = "Never knew you could make meat honey."
WINONADESCRIBE.BEEBEETLEDEN = "I could only imagine what the inside looks like."
WARLYDESCRIBE.BEEBEETLEDEN = "I'll only take a little!"
WORTOXDESCRIBE.BEEBEETLEDEN = "A place of respite for those busy hunters."
WORMWOODDESCRIBE.BEEBEETLEDEN = "Buzz-less home."
WURTDESCRIBE.BEEBEETLEDEN = "Bee takes fish there to keep as pet, I think."
WALTERDESCRIBE.BEEBEETLEDEN = "Should definitely stay clear of that."
WANDADESCRIBE.BEEBEETLEDEN = "Takes them quite a bit of time to process the meat in there."

NAMES.BEEBEETLEBOULDER = "Honey Boulder"
NAMES.HIBEEBEETLEBOULDER = "Honey Boulder"
WILSONDESCRIBE.BEEBEETLEBOULDER = "A globule of honey, wax, and bee spit."
WILLOWDESCRIBE.BEEBEETLEBOULDER = "This thing could stay on fire for an eternity... if I could figure out how to light it."
WOLFGANGDESCRIBE.BEEBEETLEBOULDER = "Very light for Wolfgang, but very sticky!"
WENDYDESCRIBE.BEEBEETLEBOULDER = "Nothing but a mass of flesh."
WX78DESCRIBE.BEEBEETLEBOULDER = "LIKE TAKING CANDY FROM A BABY."
WICKERBOTTOMDESCRIBE.BEEBEETLEBOULDER = "'Meat honey' is not but a misnomer resulting from scientific uncertainty."
WOODIEDESCRIBE.BEEBEETLEBOULDER = "I'm hungry already."
WAXWELLDESCRIBE.BEEBEETLEBOULDER = "Sticky and heavy."
WATHGRITHRDESCRIBE.BEEBEETLEBOULDER = "Toss it into the sea, for all I care."
WEBBERDESCRIBE.BEEBEETLEBOULDER = "Giant candy!"
WINONADESCRIBE.BEEBEETLEBOULDER = "I don't love the idea of stealing someone's work, but honey is honey."
WARLYDESCRIBE.BEEBEETLEBOULDER = "One step closer to a meal!"
WORTOXDESCRIBE.BEEBEETLEBOULDER = "I foresee honey in the near future"
WORMWOODDESCRIBE.BEEBEETLEBOULDER = "Ball of buzz-less juice."
WURTDESCRIBE.BEEBEETLEBOULDER = "Hmm... Smell like fish... Weird."
WALTERDESCRIBE.BEEBEETLEBOULDER = "Mind carrying this for me, Woby?"
WANDADESCRIBE.BEEBEETLEBOULDER = "Too many steps! Just give me the honey!"

NAMES.FLOATY_FLINT = "Buoyant Flint"
NAMES.FLOATY_GOLDNUGGET = "Buoyant Gold Nugget"
NAMES.FLOATY_NITRE = "Buoyant Nitre"
NAMES.FLOATY_ROCKS = "Buoyant Rocks"

-- non-unique strings 
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

--[[ this is just for copy-pasting 
WILSONDESCRIBE.
WILLOWDESCRIBE.
WOLFGANGDESCRIBE.
WENDYDESCRIBE.
WX78DESCRIBE.
WICKERBOTTOMDESCRIBE.
WOODIEDESCRIBE.
WAXWELLDESCRIBE.
WATHGRITHRDESCRIBE.
WEBBERDESCRIBE.
WINONADESCRIBE.
WARLYDESCRIBE.
WORTOXDESCRIBE.
WORMWOODDESCRIBE.
WURTDESCRIBE.
WALTERDESCRIBE.
WANDADESCRIBE.
]]