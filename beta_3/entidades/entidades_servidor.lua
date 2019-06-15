local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local libe= require "self_libs.lib_entities"
local servidor = require "gamestates.servidor"

local objetos_mapa  = {  Estrella = require "entidades.logica.objetos.estrella",
                        Arbol = require "entidades.logica.objetos.arbol",
                        Roca  = require "entidades.logica.objetos.roca",
                        Punto_inicio = require "entidades.logica.objetos.punto_inicio",
                        Punto_enemigo_agua = require "entidades.logica.objetos.punto_enemigo_agua"
                      }
                      

local entidades_servidor = Class{
  __includes = {libe,servidor}
}

local personajes={}
local enemigos={}
local objetos={}



function entidades_servidor:init(cam,vector,signal,eleccion,map,ip,puerto,cantidad,nombre,map_name)
  
  --datos de base
  self.cam=cam
	self.signal=signal
	self.vector=vector

	self.map=map
  
  --gameobjects
  
  self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  self.gameobject.arboles={}
  
  --objetos auxiliares
  
  self.respawn_points={}
  self.respawn_points_enemigos={}
  
  
  
  --fisicas
  
  self.world = love.physics.newWorld(0, 0, false)
  self.world:setCallbacks(self:callbacks())
  
  --personajes
  
  self.personajes={
		require "entidades.logica.personajes.Aegis",
		require "entidades.logica.personajes.Solange"
	}
  
  libe.init(self)
  
  self:map_read(objetos_mapa,enemigos_mapa)
  
  self:custom_layers()
  
  self:close_map()
  
  self.personajes[eleccion](self,self.respawn_points[1].x,self.respawn_points[1].y,1,nombre)
  
  self.cantidad_enemigos=0
  self.max_cantidad_enemigos=25
  
  servidor.init(self,ip,puerto,cantidad,nombre,map_name)
end

function entidades_servidor:enter()
  
end

function entidades_servidor:draw()
  local cx,cy,cw,ch=self.cam:getVisible()
  
  
  
  self.map:draw(-cx,-cy,1,1)
  
  self.cam:draw(function(l,t,w,h)
      
    --[[for _, body in pairs(self.world:getBodies()) do
      for _, fixture in pairs(body:getFixtures()) do
          local shape = fixture:getShape()
   
          if shape:typeOf("CircleShape") then
              local cx, cy = body:getWorldPoints(shape:getPoint())
              love.graphics.circle("line", cx, cy, shape:getRadius())
          elseif shape:typeOf("PolygonShape") then
              love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
          else
              love.graphics.line(body:getWorldPoints(shape:getPoints()))
          end
      end
    end]]
    
  end)

  lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  self:servidor_draw()
end

function entidades_servidor:update(dt)
  self:update_server(dt)
end

function entidades_servidor:keypressed(key)
	if self.gameobject.players[1] then
		self.gameobject.players[1]:keypressed(key)
	end
end

function entidades_servidor:keyreleased(key)
	if self.gameobject.players[1] then
		self.gameobject.players[1]:keyreleased(key)
	end
  
  
end

function entidades_servidor:mousepressed(x,y,button)
	if self.gameobject.players[1] then

		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[1]:mousepressed(cx,cy,button)
	end
end

function entidades_servidor:mousereleased(x,y,button)
	if self.gameobject.players[1] then
		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[1]:mousereleased(cx,cy,button)
	end
  
end

return entidades_servidor