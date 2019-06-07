return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 100,
  height = 100,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 10,
  nextobjectid = 16,
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
      data = "eJzt2dlKBDEQQNEexQf//4d9mYGhSVUq6aQVPAfEdUD6mtXHcRyP59vH2/vWx6/PPwfeGHPuoMfvinq8tzj3+D702KXV4Tx/tb726qTHWtUerTFTGSuMyearbFxU1xPGVDtEY0aPtSr7qXOjcx891uk9897aosda1X1V1kmPdXrnj2x/9XXY767Wm4ta60ulgx5zoj1T1sN9yT7Z/UjURo999PhbeveIrbVFj30q+yv37fep9jBf3aOy3x25r9Ljmur5Q497ROfw7K5dj32y82DUw/9r96nMT9l5pHeuZ0x13YjGTtRNjzmV/3n0xkf284yJ1vHevWJ1X8aY2R7R9/W4ptWjen9SmccYUxkPetwne869Z63Heq31uLLfitZ2Pa7JeoyuI3pcFz3X3vPunUX0mJPNQa0zR7WXHnOitXn09Y/1v9q/FP3dj7xej7XMLwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADDnB3GaBh8="
    },
    {
      type = "tilelayer",
      id = 4,
      name = "Suelo2",
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
      data = "eJztwTEBAAAAwqD1T+1lC6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAbnEAAAQ=="
    },
    {
      type = "objectgroup",
      id = 8,
      name = "Objetos",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
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
          type = "5",
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
          type = "2",
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
          type = "3",
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
        },
        {
          id = 10,
          name = "Punto_enemigo_agua",
          type = "4",
          shape = "point",
          x = 520,
          y = 452,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "Punto_enemigo_agua",
          type = "4",
          shape = "point",
          x = 624,
          y = 811,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 5,
      name = "Balas",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      id = 6,
      name = "Enemigos",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      id = 7,
      name = "Personajes",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    },
    {
      type = "objectgroup",
      id = 9,
      name = "Arboles",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    }
  }
}
