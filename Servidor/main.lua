local Gamestate = require "libs.hump.gamestate"
local Escenario = require "gamestates.escenario"

function love.load()

	--inicio
	_G.lg=love.graphics
	_G.lm=love.math

	Gamestate.registerEvents()
    Gamestate.switch(Escenario)
end

--bugs

--bug tamaño iceber
--bug pegar melee