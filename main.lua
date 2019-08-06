Gamestate = require "libs.hump.gamestate"
Menu = require "escenas.menu"

function love.load()
	
	
	_G.lg=love.graphics
	_G.lm=love.math
	_G.lm.setRandomSeed(love.timer.getTime())
	--_G.font = font
	_G.py=love.physics

  	Gamestate.registerEvents()
  	Gamestate.switch(Menu)

  	_G.seed = love.timer.getTime()
  	math.randomseed(seed)

end


function get_random(min,max)
	local value
	if max then
		value = math.random(min,max)
	else
		value = math.random(1,min)
	end

	return value
end

--enviar imagenes de personajes del servidor al cliente

--colocar contraseña