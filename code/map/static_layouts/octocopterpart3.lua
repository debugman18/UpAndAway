return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 6,
  height = 6,
  tilewidth = 64,
  tileheight = 64,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      filename = "../../../../../../../../../../../Users/debugman18/Documents/Modding/samplelayout/layout_source/dont_starve/ground.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../../../../../../../../Users/debugman18/Documents/Modding/samplelayout/layout_source/dont_starve/tiles.png",
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
      width = 6,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 1, 1, 0, 1, 0,
        0, 1, 0, 1, 1, 0,
        0, 0, 1, 1, 1, 1,
        0, 0, 0, 0, 1, 1,
        0, 0, 0, 0, 1, 0,
        0, 0, 0, 0, 0, 0
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
          name = "",
          type = "octocopterpart3",
          shape = "rectangle",
          x = 200,
          y = 150,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
