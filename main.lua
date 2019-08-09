Gamestate = require "libs.hump.gamestate"
Menu = require "escenas.menu"

function love.load()
	
	
	_G.lg=love.graphics
	_G.lm=love.math
	_G.lm.setRandomSeed(love.timer.getTime())
	--_G.font = font
	_G.py=love.physics
	_G.version_juego = "Beta 5.4.0"

  	Gamestate.registerEvents()
  	Gamestate.switch(Menu)

  	love.graphics.setDefaultFilter( 'nearest', 'nearest' )


end

--enviar imagenes de personajes del servidor al cliente

--colocar contraseña