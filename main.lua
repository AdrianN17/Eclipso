Gamestate = require "libs.hump.gamestate"
Servidor = require "entidades.servidor"

function love.load()
	
	
	_G.lg=love.graphics
	_G.lm=love.math
	--_G.font = font
	_G.py=love.physics

  	Gamestate.registerEvents()
  	Gamestate.switch(Servidor,2,25,"acuaris","192.168.0.3")

end

--enviar imagenes de personajes del servidor al cliente

--colocar contraseña