local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Base = require "base.base"

local escenario = Class{
	__includes = Base
}

function escenario:init(value)
	Base:init(self,"mapas/sinnombre.lua",value)
end

function escenario:draw()
	self.entidades:draw()
	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end

function escenario:update(dt)
	self.entidades:update(dt)
end

return escenario