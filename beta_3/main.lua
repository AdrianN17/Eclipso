local Gamestate = require "libs.hump.gamestate"
local Menu = require "escenas.menu"

function love.load()

	--inicio

	--[[local font=love.graphics.newImageFont("assets/font/Imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")]]

	_G.lg=love.graphics
	_G.lm=love.math
	--_G.font = font
	_G.py=love.physics


	Gamestate.registerEvents()
  Gamestate.switch(Menu)
end