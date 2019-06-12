local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Base = require "base.base"
--local Base_cliente = require "base.base_cliente"

local game = Class{
  __includes = Base
}

function game:init()
  
  --coger data de filesystem
  
  local data=nil
	if love.filesystem.getInfo("Game_data.lua") then
    data =love.filesystem.load("Game_data.lua")()
    --print(data.personaje,data.mapa,data.tipo)
  end
  
  
  Base:init(self,data.mapa,data.personaje,data.ip,data.puerto,data.nombre)
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

function game:quit()
  self.entidades:quit()
end

return game