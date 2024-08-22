local foods = 
{
    croakuembouche = 
    {
        test = function(cooker, names, tags) return (names.insect_meat_raw or names.insect_meat_cooked) and (names.froglegs or names.froglegs_cooked) end,
		priority = 2,
		weight = 1,
		foodtype = FOODTYPE.MEAT,
		health = 40,
		hunger = 60,
		perishtime = TUNING.PERISH_SLOW,
		sanity = 10,
		cooktime = 2,
        floater = {"small", 0.05, 0.7},
		potlevel = "low",
		tags = {"insectmeat", "meat", "tolerableinsect"},
		overridebuild = "croakuembouche",
    },

	nutrientpaste = 
    {
        test = function(cooker, names, tags) return (names.insect_meat_raw or names.insect_meat_cooked) and ((names.insect_meat_raw or names.insect_meat_cooked) >= 2) and not tags.inedible end,
		priority = 1,
		weight = 1,
		foodtype = FOODTYPE.MEAT,
		health = 20,
		hunger = 120,
		perishtime = TUNING.PERISH_SLOW,
		sanity = 0,
		cooktime = 1,
        floater = {"small", 0.05, 0.7},
		tags = {"insectmeat", "meat", "nutrientpaste"},
		overridebuild = "nutrientpaste",
    },

	-- tteok-bug-ki ?
}

for recipe, data in pairs(foods) do
    data.name = recipe
	data.cookbook_atlas = "images/cookbookimages/"..recipe..".xml"
	data.cookbook_tex = recipe..".tex"
end

return foods