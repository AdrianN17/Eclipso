local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Base = require "base.base"

local escenario = Class{
	__includes = Base
}

function escenario:init()
	Base:init(self,"mapas/sinnombre.lua",3)
end

function escenario:draw()
	self.entidades:draw()
	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end

function escenario:update(dt)
	self.entidades:update(dt)
end

function escenario:keypressed(key)
	self.entidades:keypressed(key)
end

function escenario:keyreleased(key)
	self.entidades:keyreleased(key)
end

function escenario:mousepressed(x,y,button)
	self.entidades:mousepressed(x,y,button)
end

function escenario:mousereleased(x,y,button)
	self.entidades:mousereleased(x,y,button)
end

function escenario:wheelmoved(x,y)
	self.entidades:wheelmoved(x,y)
end

return escenario