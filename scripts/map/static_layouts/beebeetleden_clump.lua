return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 5,
  height = 5,
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
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0
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
          name = "beebeetleden",
          type = "beebeetleden",
          shape = "rectangle",
          x = 35,
          y = 19,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "beebeetleden",
          type = "beebeetleden",
          shape = "rectangle",
          x = 294,
          y = 99,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "beebeetleden",
          type = "beebeetleden",
          shape = "rectangle",
          x = 63,
          y = 191,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "beebeetleden",
          type = "beebeetleden",
          shape = "rectangle",
          x = 259,
          y = 318,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 1,
          y = 320,
          width = 1,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
