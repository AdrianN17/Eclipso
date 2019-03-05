local Gamestate = require "libs.hump.gamestate"
local Escenario = require "gamestates.escenario"

function love.load()

	--inicio
	_G.lg=love.graphics

	Gamestate.registerEvents()
    Gamestate.switch(Escenario)
end