local prefab_spawns = {
  {
    name = "CT",
    type = "clockwork_tower",
    shape = "rectangle",
    x = 160,
    y = 160,
    width = 0,
    height = 0,
    visible = true,
    properties = {}
  }
}

local taymid = KnownModIndex:GetModActualName("Taym's Flora and Fauna")
if KnownModIndex:IsModEnabled("workshop-2039181790") and GetModConfigData("clockwork_tower_pawns", taymid) then 
  --(0, 160), (320, 160)
  table.insert(prefab_spawns, 
  {
    name = "UP",
    type = "um_pawn_nightmare",
    shape = "rectangle",
    x = 0,
    y = 160,
    width = 0,
    height = 0,
    visible = true,
    properties = {
      ["scenario"] = "um_modified_pawn"
    }
  })
  table.insert(prefab_spawns, 
  {
    name = "UP",
    type = "um_pawn_nightmare",
    shape = "rectangle",
    x = 320,
    y = 160,
    width = 0,
    height = 0,
    visible = true,
    properties = {
      ["scenario"] = "um_modified_pawn"
    }
  })
end

return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 5,
  height = 5,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../../../../../../stuff/DST CODE/tileset/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../../../../../../stuff/DST CODE/tileset/tiles.png",
      imagewidth = 512,
      imageheight = 128,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 11, 11, 0, 0,
        11, 11, 10, 11, 11,
        0, 10, 10, 10, 11,
        11, 11, 10, 0, 11,
        0, 11, 11, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = prefab_spawns
    }
  }
}
