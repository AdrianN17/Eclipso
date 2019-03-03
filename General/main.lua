local Gamestate = require "libs.hump.gamestate"
local Escenario = require "gamestates.escenario"

function love.load()

	--inicio


	Gamestate.registerEvents()
    Gamestate.switch(Escenario)
end