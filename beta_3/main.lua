local Gamestate = require "libs.hump.gamestate"
local Menu = require "escenas.menu"
local img= require "assets.img.img"

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
  _G.img=img


	Gamestate.registerEvents()
  Gamestate.switch(Menu)
end

function love.keypressed(k)
   if k == 'escape' then
      love.event.quit()
   end
end