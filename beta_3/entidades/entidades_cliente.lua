local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"

local cliente = require "gamestates.cliente"

local entidades_cliente = Class{
  __includes = {cliente}
}

function entidades_cliente:init(cam,vector,signal,eleccion,map,ip,puerto,nombre)
  self.id_player=nil
  
  cliente.init(self,ip,puerto,nombre,eleccion)
  
  self.cam=cam
	self.signal=signal
	self.vector=vector

	self.map=map
  
  
  
  self.players={}
  self.enemigos={}
  self.balas={}
  self.objetos={}
  self.arboles={}
  
  
end

function entidades_cliente:enter()
  
end

function entidades_cliente:draw()
  self:client_draw()
end

function entidades_cliente:update(dt)
  self.map:update(dt)
  
  
  
  self:client_update(dt)
  
end

function entidades_cliente:getXY()
    local cx,cy=self.cam:toWorld(love.mouse.getPosition())
    return cx,cy 
end

return entidades_cliente