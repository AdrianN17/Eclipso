local Gamestate = require "libs.hump.gamestate"
local Menu = require "gamestates.menu"

function love.load()

	--inicio
	_G.lg=love.graphics
	_G.lm=love.math

	Gamestate.registerEvents()
    Gamestate.switch(Menu)
end

