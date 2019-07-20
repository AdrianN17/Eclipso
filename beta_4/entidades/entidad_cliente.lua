local Class= require "libs.hump.class"
local sti = require "libs.sti"
local img_personajes_cliente = require "entidades.solo_cliente.img_personajes_cliente"
local img_balas_cliente = require "entidades.solo_cliente.img_balas_cliente"
local img_objetos_cliente = require "entidades.solo_cliente.img_objetos_cliente"

local entidad_cliente = Class{}

function entidad_cliente:init()
	self.gameobject={}
	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
  self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  self.gameobject.arboles={}
  self.gameobject.inicios={}

  self.img_personajes=require "assets.img.personajes.img_personajes"
	self.img_balas=require "assets.img.balas.img_balas"
	self.img_escudos=require "assets.img.escudos.img_escudos"
end

function entidad_cliente:draw_entidad()

  local cx,cy,cw,ch=self.cam:getVisible()
  
	if self.map then
    self.map:draw(-cx,-cy,1,1)
  end
end

function entidad_cliente:update_entidad(dt)
	if self.map then
    	self.map:update(dt)
  	end
end

function entidad_cliente:keypressed(key)
	 if self.client:getState() == "connected" and self.id_player  then
        if key=="escape" then
             self.client:disconnect()
        else
             local pl=self.gameobject.players[self.id_player]

            if pl then
             	self.client:send("key_pressed", {key=key})
            end
        end
    end
end

function entidad_cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
        local pl=self.gameobject.players[self.id_player]

        if pl then
        	self.client:send("key_released", {key=key})
        end
    end
end

function entidad_cliente:mousepressed(x,y,button)
     if self.client:getState() == "connected" and self.id_player then
     	local pl=self.gameobject.players[self.id_player]

        if pl then
	        local cx,cy=self.cam:toWorld(x,y)
	        self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
	      end
    end
end

function entidad_cliente:mousereleased(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
    	local pl=self.gameobject.players[self.id_player]

        if pl then
        	local cx,cy=self.cam:toWorld(x,y)
        	self.client:send("mouse_released", {x=cx,y=cy,button=button})
    	  end
    end
end

function entidad_cliente:quit()
    self.client:disconnect()
end

function entidad_cliente:crear_mapa(mapas)
	self.mapa_files=require ("entidades.mapas." .. mapas)
	self.map=sti(self.mapa_files.mapa)

	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam:setWorld(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setWindow(0,0,x,y)

  self:custom_layers()

end

function entidad_cliente:getXY()
    local cx,cy=self.cam:toWorld(love.mouse.getPosition())
    return cx,cy 
end

function entidad_cliente:custom_layers()
  
  local Balas_layers = self.map.layers["Balas"]
  
  local Enemigos_layers = self.map.layers["Enemigos"] 
  
  local Personajes_layers = self.map.layers["Personajes"]
  
  local Destruible_layers = self.map.layers["Destruible"]
  
  local Objetos_layers = self.map.layers["Objetos"]
  
  local Arboles_layers = self.map.layers["Arboles"]

  local Inicios_layers = self.map.layers["Inicios"]

  Balas_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.balas) do
      img_balas_cliente:dibujar_bala(obj_data,self.img_balas)
    end
  end
  
  Enemigos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      --obj_data:draw()
    end
  end
  
  Personajes_layers.draw = function(obj)
    for i=0,#self.gameobject.players,1 do
      local obj_data = self.gameobject.players[i]

      if obj_data then
        local tipo=obj_data.tipo
        local tipo_escudo=obj_data.tipo_escudo
        local spritesheet=self.img_personajes[tipo]
        local spritesheet_escudo=self.img_escudos


        img_personajes_cliente:tipos(tipo,obj_data,spritesheet,spritesheet_escudo)
      end

    end
  end
  
  Destruible_layers.draw = function(obj)
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        --obj_data:draw()
      end
    end
  end
  
  Objetos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.objetos) do
      img_objetos_cliente:dibujar_objetos(obj_data,self.mapa_files.objetos)
    end
  end
  
  Arboles_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.arboles) do
      img_objetos_cliente:dibujar_objetos(obj_data,self.mapa_files.objetos)
    end
  end
  
  Inicios_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.inicios) do
      img_objetos_cliente:dibujar_objetos(obj_data,self.mapa_files.objetos)
    end
  end



  
end

return entidad_cliente