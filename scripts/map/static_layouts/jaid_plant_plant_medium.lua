return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 4,
  height = 4,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 55,
          y = 60,
          width = 12,
          height = 11,
          visible = true,
          properties = {}
        },
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 175,
          y = 91,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 52,
          y = 136,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 128,
          y = 205,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 198,
          y = 159,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "jaid_plant_plant",
          type = "jaid_plant_plant",
          shape = "rectangle",
          x = 124,
          y = 122,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
