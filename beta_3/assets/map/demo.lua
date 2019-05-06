return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 100,
  height = 100,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 4,
  nextobjectid = 10,
  properties = {},
  tilesets = {
    {
      name = "tiled_playa",
      firstgid = 1,
      filename = "tiled_playa.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 4,
      image = "tiled_playa.png",
      imagewidth = 128,
      imageheight = 96,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 12,
      tiles = {
        {
          id = 2,
          animation = {
            {
              tileid = 2,
              duration = 300
            },
            {
              tileid = 3,
              duration = 300
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 3,
      name = "Suelo",
      x = 0,
      y = 0,
      width = 100,
      height = 100,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJzt2ctOwzAQQNEU1EX//4fZUCmyxuOhtkMW50gVENQNFz/7OI7j8fv6On2Nvn///J28mNN20ON/9XqcW7Q9Xoceu0Qd2vkrevbupMda1R7RmInGCnOy+SobF731hDnVDr0xo8dalf1U26jto8c6o7/5aG3RY63qvirrpMc6o/NHtr96Hva7q43momh9iTrosUZvz5T1cF+yT3Y/0mujxz563MvoHjFaW/TYp7K/ct9+nWoP89U1Kvvd7L5Kj7Wq5w89rtE7h2d37Xrsk50Hez18XrtPZX7KziNtR+ZU143e2Gm7MafymcdofJyfMae3jo/uFXvvYc6nPXq/Z07Uo3p/0rZhXmU86HGdyv1h5bkea0T7qsp+K1rbmZf1+Mv6wRq9eSqbv6L5ijWyOSg7k+uwh7X5Xvzf348OAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8JkfIWoEug=="
    },
    {
      type = "objectgroup",
      id = 2,
      name = "Borrador",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 5,
          name = "Punto_inicio",
          type = "4",
          shape = "point",
          x = 263,
          y = 132,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "Arbol",
          type = "3",
          shape = "point",
          x = 189,
          y = 457,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "Roca",
          type = "2",
          shape = "point",
          x = 388,
          y = 627,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "Estrella",
          type = "1",
          shape = "point",
          x = 660,
          y = 234,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
