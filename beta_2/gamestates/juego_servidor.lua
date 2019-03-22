local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Base = require "base.base"

local juego_servidor = Class{
	__includes = Base
}

function juego_servidor:init()
	self.eleccion_personaje=_G.detalles.personaje
	self.port=_G.detalles.port
	Base:init(self,self.eleccion_personaje)
end

function juego_servidor:draw()
	self.entidades:draw()
	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end

function juego_servidor:update(dt)
	self.entidades:update(dt)
end

function juego_servidor:keypressed(key)
	self.entidades:keypressed(key)
end

function juego_servidor:keyreleased(key)
	self.entidades:keyreleased(key)
end

function juego_servidor:mousepressed(x,y,button)
	self.entidades:mousepressed(x,y,button)
end

function juego_servidor:mousereleased(x,y,button)
	self.entidades:mousereleased(x,y,button)
end

function juego_servidor:wheelmoved(x,y)
	self.entidades:wheelmoved(x,y)
end

function juego_servidor:quit()
    self.entidades:quit()
end

return juego_servidor