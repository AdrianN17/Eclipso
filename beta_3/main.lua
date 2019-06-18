local Gamestate = require "libs.hump.gamestate"
--local Menu = require "escenas.menu"
local Game = require "escenas.game"
local img= require "assets.img.img"
local mime = require "mime"

function love.load(arg)
  --transformar de base 64 a string
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