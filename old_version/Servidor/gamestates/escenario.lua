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
	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)
end

function escenario:update(dt)
	self.entidades:update(dt)
end

function escenario:keypressed(key)
	self.entidades:keypressed(key)
end

return escenario