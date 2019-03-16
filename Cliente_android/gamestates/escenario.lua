local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Base = require "base.base"

local escenario = Class{
	__includes = Base
}

function escenario:init(eleccion)
	if eleccion then
		self.eleccion_personaje=eleccion
	end
	Base:init(self,"mapas/sinnombre.lua",self.eleccion_personaje)
end

function escenario:draw()
	self.entidades:draw()
	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end

function escenario:update(dt)
	self.entidades:update(dt)
end

function escenario:touchpressed( id, x, y, dx, dy, pressure )
	self.entidades:touchpressed( id, x, y, dx, dy, pressure)
end

function escenario:touchreleased( id, x, y, dx, dy, pressure )
	self.entidades:touchreleased( id, x, y, dx, dy, pressure)
end

return escenario