PrefabFiles = {
    "clockwork_tower",
    "jaid_plant_plant",
    "jaid_plant_root",
    "plantaid",
    "insect_meat",
    "gardenslug",
    "gardenslug_spawner",
    "slugling_egg",
    "slugling",
    "flintchick",
    "flintchickherd",
    "floaty_materials",
    "beebeetle",
    "beebeetleden",
    "beebeetleboulder",
    "tayms_preparedfoods",
}

Assets = {
    Asset("ATLAS", "images/minimapimages/jaid_plant_minimap.xml"),
    Asset("IMAGE", "images/minimapimages/jaid_plant_minimap.tex"),

    Asset("ATLAS", "images/minimapimages/gardenslug_minimap.xml"),
    Asset("IMAGE", "images/minimapimages/gardenslug_minimap.tex"),
}


-- MINIMAP ATLAS':
AddMinimapAtlas("images/minimapimages/jaid_plant_minimap.xml")
AddMinimapAtlas("images/minimapimages/gardenslug_minimap.xml")


-- IMPORTS:
modimport("init/strings/tayms_strings")
modimport("init/init_tuning")

modimport("postinit/prefabs/slurtle")
modimport("postinit/prefabs/forest")
modimport("postinit/prefabs/messagebottle")
modimport("postinit/components/hunter")
modimport("postinit/insect_meat_sanity")

modimport("postinit/prefabs/um_pawn")
modimport("postinit/prefabs/cherrygem")


-- CROCKPOT:
local recipes = require("tayms_preparedfoods")
local spicedfoods = require("spicedfoods")
local cooking = require("cooking")

RegisterInventoryItemAtlas("images/inventoryimages/croakuembouche.xml", "croakuembouche.tex")
RegisterInventoryItemAtlas("images/inventoryimages/nutrientpaste.xml", "nutrientpaste.tex")

AddIngredientValues({"insect_meat_raw"}, {meat = 1}, true, true)
AddIngredientValues({"insect_meat_cooked"}, {meat = 1})

for name, data in pairs(recipes) do 
    AddCookerRecipe("cookpot", data)

    if name ~= "nutrientpaste" then --warly hates nutrient paste
        AddCookerRecipe("portablecookpot", data)
    end 
end 

GLOBAL.GenerateSpicedFoods(recipes)
for name, data in pairs(spicedfoods) do 
    if not cooking.recipes.portablespicer[data.name] then
        AddCookerRecipe("portablespicer", data)
    end 
end 