local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Base = require "base.base"

local game = Class{
  __includes = Base
}

function game:init()
  
  Base:init(self,"demo",personaje_elegido)
end

function game:enter()
  
end

function game:draw()
  self.entidades:draw()
end

function game:update(dt)
  self.entidades:update(dt)
end

function game:keypressed(key)
  self.entidades:keypressed(key)
end

function game:keyreleased(key)
  self.entidades:keyreleased(key)
end

function game:mousepressed(x,y,button)
  self.entidades:mousepressed(x,y,button)
end

function game:mousereleased(x,y,button)
  self.entidades:mousereleased(x,y,button)
end

return game