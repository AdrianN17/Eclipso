local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Base = require "base.base"
local Base_cliente = require "base.base_cliente"

local game = Class{
  __includes = {Base,Base_cliente}
}

function game:init()
  
  --transformar data de string a table
  
  local data=(loadstring)(_G.configuracion)()
  
  --print(1,type(_G.configuracion),_G.configuracion)

  if data==nil then
    love.event.quit()
  else
    
    if data.tipo == "server" then
      Base:init(self,data.mapa,data.personaje,data.ip,data.puerto,data.cantidad,data.nombre,data.cantidad_enemigos)
    else
      Base_cliente:init(self,data.personaje,data.ip,data.puerto,data.nombre)
    end
    
  end
  
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