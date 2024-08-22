local require = GLOBAL.require
local Layouts = require("map/layouts").Layouts
local Static_Layouts = require("map/static_layout")

Layouts.clockwork_tower_spawner = Static_Layouts.Get("map/static_layouts/clockwork_tower_spawner")
Layouts.jaid_plant_plant_medium = Static_Layouts.Get("map/static_layouts/jaid_plant_plant_medium")
Layouts.beebeetleden_clump = Static_Layouts.Get("map/static_layouts/beebeetleden_clump")

--[[distribution of prefabs works by randomly picking a distribution prefab from a % weight pool to fill up an 'x' amount of space
this means that by adding new prefabs with their own weights, we reduce other prefabs % chance to spawn
to fix this we increase the 'x' amount of space that is allowed to be filled by the amount below]]
local function fix_distribution(room, added_distribution) 
	local total_distribution = 0 
	for _, distribution in pairs(room.contents.distributeprefabs) do 
		total_distribution = total_distribution + distribution
	end 
	--print("TOTAL DISTRIBUTION: "..tostring(total_distribution))

	if total_distribution ~= 0 then --if there was nothing else adding to the choice pool we dont need to do anything
		local distribution_increase = (total_distribution + added_distribution)/total_distribution
		local new_distribution = distribution_increase*room.contents.distributepercent

		if new_distribution > 1 then --distribution percent isnt allowed to be greater than 1 
			room.contents.distributepercent = 1
			--print("CANT INCREASE DISTRIBUTION PAST 1")
		else 
			--print("CHANGING DISTRIBUTION")
			--print("OLD: "..tostring(room.contents.distributepercent))
			--print("NEW: "..tostring(new_distribution))

			room.contents.distributepercent = new_distribution
		end 
	end 
end 

--clockwork tower
AddLevelPreInitAny(function(level)
	if level.location ~= "forest" then
		return
	end

	if not level.ordered_story_setpieces then
		level.ordered_story_setpieces = {}
	end

	Layouts["clockwork_tower_spawner"].fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN

	for i = 1, GetModConfigData("clockwork_tower_spawn_amount") do 
		table.insert(level.ordered_story_setpieces, "clockwork_tower_spawner")
	end
end)

--jaid plant 
--no need for terrain filters, bullkelp doesn't have any either
AddRoomPreInit("OceanCoastal", function(room)
	if not room.contents.countstaticlayouts then
		room.contents.countstaticlayouts = {}
	end

	if not room.contents.distributeprefabs then
		room.contents.distributeprefabs = {}
	end

	fix_distribution(room, GetModConfigData("jaid_plant_distribution"))
	--setting distribution relative to bullkelp here. ocean content is being constantly added, so distribution numbers shift around a lot!
	--tested setting bullkelp spawns to none in world gen and the jaid plant still spawned normally, so this method is fine
	room.contents.distributeprefabs["jaid_plant_plant"] = room.contents.distributeprefabs["bullkelp_plant"]*GetModConfigData("jaid_plant_distribution")
	room.contents.countstaticlayouts["jaid_plant_plant_medium"] = GetModConfigData("jaid_plant_clump_amount")
end)

--gardenslug
GLOBAL.terrain.filter.gardenslug = {WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.SCALE, WORLD_TILES.CARPET, WORLD_TILES.CHECKER}
local slugrooms = {"SinkholeForest", "SinkholeCopses", "SparseSinkholes", "SinkholeOasis", "GrasslandSinkhole", "FungusNoiseForest", "FungusNoiseMeadow"}

for _, slugroom in pairs(slugrooms) do 
	AddRoomPreInit(slugroom, function(room)
		if not room.contents.distributeprefabs then
			room.contents.distributeprefabs = {}
		end
	
		fix_distribution(room, GetModConfigData("gardenslug_distribution"))
		room.contents.distributeprefabs["gardenslug"] = GetModConfigData("gardenslug_distribution")
	end)
end 

local slugspawnrooms = {"BGSavanna", "Plain", "BarePlain", "BGCrappyForest", "CrappyDeepForest", "DeepForest", "BGForest", "Forest"}
for _, slugspawnroom in pairs(slugspawnrooms) do 
	AddRoomPreInit(slugspawnroom, function(room)
		if not room.contents.countprefabs then
			room.contents.countprefabs = {}
		end
	
		room.contents.countprefabs["gardenslug_spawner"] = 1
	end)
end 

--flintchick
GLOBAL.terrain.filter.flintchick = {WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.SCALE, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.METEOR}
GLOBAL.terrain.filter.stonechick = {WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.SCALE, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.METEOR}
local landchickrooms = {"BGChessRocky", "BGRocky", "GenericRockyNoThreat", "TallbirdNests", "RockyBuzzards", "MolesvilleRocky", "SpiderVillage", "Badlands", "HoundyBadlands",}
local waterchickrooms = {"OceanSwell", "OceanRough"}

if GetModConfigData("shallow_flintchicks") then 
	table.insert(waterchickrooms, "OceanCoastal")
end 

for _, landchickroom in pairs(landchickrooms) do 
	AddRoomPreInit(landchickroom, function(room)
		if not room.contents.distributeprefabs then
			room.contents.distributeprefabs = {}
		end
	
		--2/3 of intitial chicks are flint
		local chick_distribution = GetModConfigData("flintchick_land_distribution")

		fix_distribution(room, chick_distribution/1.5)
		room.contents.distributeprefabs["flintchick"] = chick_distribution/1.5

		fix_distribution(room, chick_distribution/3)
		room.contents.distributeprefabs["stonechick"] = chick_distribution/3
	end)
end 
for _, waterchickroom in pairs(waterchickrooms) do 
	AddRoomPreInit(waterchickroom, function(room)
		if not room.contents.distributeprefabs then
			room.contents.distributeprefabs = {}
		end

		--2/3 of intitial chicks are flint
		local chick_distribution = GetModConfigData("flintchick_water_distribution")

		fix_distribution(room, chick_distribution/1.5)
		room.contents.distributeprefabs["flintchick"] = chick_distribution/1.5

		fix_distribution(room, chick_distribution/3)
		room.contents.distributeprefabs["stonechick"] = chick_distribution/3

	end)
end 

--beebeetle
AddRoomPreInit("OceanRough", function(room)
	if not room.contents.countstaticlayouts then
		room.contents.countstaticlayouts = {}
	end

	Layouts["beebeetleden_clump"].fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN

	room.contents.countstaticlayouts["beebeetleden_clump"] = GetModConfigData("beebeetleden_clump_amount")
end)