Gamestate = require "libs.hump.gamestate"
local Menu = require "escenas.menu"

function love.load()
	_G.lg=love.graphics
	_G.lm=love.math
	--_G.font = font
	_G.py=love.physics

  	Gamestate.registerEvents()
  	Gamestate.switch(Menu)

end