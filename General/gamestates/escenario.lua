local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Base = require "base.base"

local escenario = Class{
	__includes = Base
}

function escenario:init()
	Base:init(self,"mapas/sinnombre.lua")
end

function escenario:draw()
	self.entidades:draw()
end

function escenario:update(dt)
	self.entidades:update(dt)
end

function escenario:keypressed(key)
	self.entidades:keypressed(key)
end

function escenario:keyreleased(key)

end

function escenario:mousepressed(x,y,button)

end

function escenario:mousereleased(x,y,button)

end

return escenario