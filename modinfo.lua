name = "Taym's Flora and Fauna"
description = "Enhances DST's wildlife by introducing new animals and plants to discover while exploring the world!"
author = "Taym"
version = "1.0.0"

forumthread = ""

api_version = 10

client_only_mod = false 
all_clients_require_mod = true 
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -11


configuration_options = {
    {
        name = "",
        label = "Clockwork Tower",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "clockwork_tower_reveal_range",
        label = "Clockwork Tower Reveal Range",
        hover = "Changes the area of the map revealed after defeating a Clockwork Tower",
        options = { --all multiples of 30 since radius step per loop is 30 
            { description = "Very Small",  data = 30*2},
            { description = "Smaller", data = 30*4},
            { description = "Normal",  data = 30*5},
            { description = "Larger (might lag!)",  data = 30*7}
        },
        default = 30*5
    },
    {
        name = "clockwork_tower_spawn_amount",
        label = "Amount of Clockwork Towers",
        hover = "Changes the amount of Clockwork Towers that spawn on the map (tries to spawn 3 by default)",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 2},
            { description = "Normal", data = 3},
            { description = "More",  data = 5}
        },
        default = 3
    },


    {
        name = "",
        label = "Jaid Plant",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "jaid_plant_distribution",
        label = "Jaid Plant Spread",
        hover = "Changes the amount of Jaid Plants spread throughout the ocean",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 0.1},
            { description = "Normal", data = 0.3},
            { description = "More",  data = 0.6}
        },
        default = 0.3
    },
    {
        name = "jaid_plant_clump_amount",
        label = "Jaid Plant Clump Amount",
        hover = "Changes the amount of Jaid Plant clumps spread throughout the ocean",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 2},
            { description = "Normal", data = 5},
            { description = "More",  data = 10}
        },
        default = 5
    },


    {
        name = "",
        label = "Garden Slug",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "gardenslug_bottle_chance",
        label = "Garden Slug Reveal Chance",
        hover = "Changes the chance that a read bottle will reveal the hiding spot of a Garden Slug.",
        options = { 
            { description = "None",  data = 0},
            { description = "Low",  data = 0.0375},
            { description = "Normal", data = 0.075},
            { description = "High", data = 0.15},
            { description = "Very High", data = 0.25},
        },
        default = 0.075
    },
    {
        name = "gardenslug_hunt",
        label = "Garden Slug Hunt Spawn",
        hover = "Allows the Garden Slug to spawn from regular hunts. WARNING: NOT CURRENTLY COMPATIBLE WITH INSIGHT",
        options = { 
            { description = "Off",  data = false},
            { description = "On",  data = true},
        },
        default = false
    },
    {
        name = "gardenslug_distribution",
        label = "Garden Slug Spread",
        hover = "Changes the amount of Gardenslugs initially found in the caves (wont effect hunts)",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 0.025},
            { description = "Normal", data = 0.05},
            { description = "More",  data = 0.15},
        },
        default = 0
    },
    {
        name = "gardenslug_drop_time",
        label = "Garden Slug Shed Rate",
        hover = "Changes the amount of time before a sapling/grass tuft is shed. Default is around 20 days.",
        options = { 
            { description = "10 Days",  data = 10},
            { description = "15 Days",  data = 15},
            { description = "20 Days", data = 20},
            { description = "30 Days",  data = 30}, 
            { description = "60 Days",  data = 60}
        },
        default = 20
    },
    {
        name = "gardenslug_max",
        label = "Max Garden Slugs",
        hover = "Changes the max amount of Garden Slugs that can be on the surface at the same time.",
        options = { 
            { description = "1",  data = 1},
            { description = "3", data = 3},
            { description = "5",  data = 5},
            { description = "10",  data = 10},
        },
        default = 3
    },


    {
        name = "",
        label = "Flintchick",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "flintchick_land_distribution",
        label = "Flintchick Land Spread",
        hover = "Changes the amount of Flintchick herds found on land",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 0.025},
            { description = "Normal", data = 0.05},
            { description = "More",  data = 0.1}
        },
        default = 0.05
    },
    {
        name = "flintchick_water_distribution",
        label = "Flintchick Ocean Spread",
        hover = "Changes the amount of Flintchick herds found on the ocean",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 0.02},
            { description = "Normal", data = 0.04},
            { description = "More",  data = 0.08}
        },
        default = 0.04
    },
    {
        name = "shallow_flintchicks",
        label = "Shallow Water Flintchicks",
        hover = "Enables the spawning of Flintchicks on shallow water. They only spawn in deeper ocean parts by default.",
        options = { 
            { description = "Off",  data = false},
            { description = "On",  data = true},
        },
        default = false
    },
    {
        name = "flintchick_respawn_time",
        label = "Flintchick Respawn Time",
        hover = "Changes the amount of time a Flintchick herd needs to spawn a new Flintchick. Default is around 15 days.",
        options = { 
            { description = "Short",  data = 5},
            { description = "Normal", data = 15},
            { description = "Long",  data = 25},
            { description = "Very Long",  data = 40},
        },
        default = 15
    },


    {
        name = "",
        label = "Bee-tle",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "beebeetleden_clump_amount",
        label = "Bee-tle Den Clump Amount",
        hover = "Changes the amount of Bee-tle Den clumps that can be found in the ocean.",
        options = { 
            { description = "None",  data = 0},
            { description = "Less",  data = 5},
            { description = "Normal", data = 10},
            { description = "More",  data = 15}
        },
        default = 10
    },


    {
        name = "",
        label = "Uncompromising Mode",
        hover = "",
        options = {{ description = "",  data = 0}},
        default = 0
    },
    {
        name = "clockwork_tower_pawns",
        label = "Clockwork Tower Pawns",
        hover = "Lets the Clockwork Tower spawn Damaged Pawns. WITHOUT UM INSTALLED, THIS DOES NOTHING!",
        options = { 
            { description = "Off",  data = false},
            { description = "On",  data = true},
        },
        default = true
    },
    {
        name = "plantaid_nerf",
        label = "Uncompromising Plant-Aid Nerf",
        hover = "Slightly reduces Plant-Aid healing and changes it to heal gradually. WITHOUT UM INSTALLED, THIS DOES NOTHING!",
        options = { 
            { description = "Off",  data = false},
            { description = "On",  data = true},
        },
        default = true
    },
}
