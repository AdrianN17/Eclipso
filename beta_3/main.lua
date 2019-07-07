local Gamestate = require "libs.hump.gamestate"
--local Menu = require "escenas.menu"
local Game = require "escenas.game"
local img= require "assets.img.img"
local mime = require "mime"

function love.load(arg)
  --transformar de base 64 a string
  
--[[local data=
  "cmV0dXJuIHtwZXJzb25hamUgPSAxLCBtYXBhID0gJ2FjdWFyaXMnICwgbm9tYnJlID0gJ3BsYXllcicsIGlwID0gJzE5Mi4xNjguMC41JywgcHVlcnRvID0gJzIyMTIyJywgdGlwbyA9ICdzZXJ2ZXInLCBjYW50aWRhZCA9ICcxJyAsIGNhbnRpZGFkX2VuZW1pZ29zPSAyNSB9"]]
  
  _G.configuracion = mime.unb64(arg[1])
  
	--inicio

	--[[local font=love.graphics.newImageFont("assets/font/Imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")]]

	_G.lg=love.graphics
	_G.lm=love.math
	--_G.font = font
	_G.py=love.physics
  _G.img=img


  

	Gamestate.registerEvents()
  Gamestate.switch(Game)
end

--colocar muros en las paredes con un chainshape