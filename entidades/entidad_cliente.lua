local Class= require "libs.hump.class"
local sti = require "libs.sti"
local img_personajes_cliente = require "entidades.solo_cliente.img_personajes_cliente"
local img_balas_cliente = require "entidades.solo_cliente.img_balas_cliente"
local img_objetos_cliente = require "entidades.solo_cliente.img_objetos_cliente"
local img_enemigos_cliente = require "entidades.solo_cliente.img_enemigos_cliente"
local teclas = require "entidades.funciones.teclas"


local utf8 = require("utf8")

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

  self.chat={}
  self.texto_escrito=""
  self.escribiendo=false

  self.img_personajes= require "assets.img.personajes.img_personajes"
	self.img_balas= require "assets.img.balas.img_balas"
	self.img_escudos= require "assets.img.escudos.img_escudos"

  self.tiempo_chat=0
  self.max_tiempo_chat=3
end

function entidad_cliente:draw_entidad()

  local cx,cy,cw,ch=self.cam:getVisible()
  
	if self.map then
    self.map:draw(-cx,-cy,1,1)

    if self.escribiendo then
      lg.setColor( 46/255, 49/255, 49/255, 0.5 )
      lg.rectangle("fill", 0, lg.getHeight()-50, 280, 20 )
      lg.setColor( 1, 1, 1, 1 )

      lg.printf(self.texto_escrito, 0, lg.getHeight()-50, lg.getWidth())
    end

    if #self.chat>0 then

      local w = lg.getWidth()-(40*7)

      lg.setColor( 46/255, 49/255, 49/255, 0.5 )
      lg.rectangle("fill", w, 0, 280, 20*#self.chat )
      lg.setColor( 1, 1, 1, 1 )

      local h=0
      for i,texto in ipairs(self.chat) do
        lg.print(texto, w, h)
        h=i*20
      end
    end
  end
end

function entidad_cliente:update_entidad(dt)
 

	if self.map then
    self.map:update(dt)
  end
end

function entidad_cliente:keypressed(key)
	if self.client:getState() == "connected" and self.id_player  then
    if key=="return" then
      self.escribiendo=not self.escribiendo

      if not self.escribiendo and #self.texto_escrito>0 then
          table.insert(self.chat,self.texto_escrito)
          self.client:send("chat", self.texto_escrito )
          self.texto_escrito=""
          self:control_chat()
      end
    end


    if self.escribiendo then
      if key == "backspace" then
          local byteoffset = utf8.offset(self.texto_escrito, -1)
   
          if byteoffset then
              self.texto_escrito = string.sub(self.texto_escrito, 1, byteoffset - 1)
          end
      end
    else

      if teclas:validar(key) then
        local pl=self.gameobject.players[self.id_player]

        if pl then
          self.client:send("key_pressed", {key=key})
        end
      end
    end              
  end
end

function entidad_cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
      if teclas:validar(key) and not self.escribiendo then
        local pl=self.gameobject.players[self.id_player]

        if pl then
        	self.client:send("key_released", {key=key})
        end
      end
  end
end

function entidad_cliente:mousepressed(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
      if not self.escribiendo then
       	local pl=self.gameobject.players[self.id_player]

          if pl then
  	        local cx,cy=self.cam:toWorld(x,y)
  	        self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
  	      end
      else
        if button==1 then
          self.escribiendo=false
        end
      end
    end
end

function entidad_cliente:mousereleased(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
      if not self.escribiendo then
      	local pl=self.gameobject.players[self.id_player]

          if pl then
          	local cx,cy=self.cam:toWorld(x,y)
          	self.client:send("mouse_released", {x=cx,y=cy,button=button})
      	  end
      end
    end
end

function entidad_cliente:textinput(t)
    if self.escribiendo then
      if #self.texto_escrito<40 then
        self.texto_escrito = self.texto_escrito .. t
      end
    end
end

function entidad_cliente:quit()
    self.client:disconnectNow()
    
end

function entidad_cliente:crear_mapa(mapas)
	self.mapa_files=require ("entidades.mapas." .. mapas)

  self.img_texturas = self.mapa_files.texturas
	self.map=sti(self.mapa_files.mapa)

	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam:setWorld(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setWindow(0,0,x,y)

  self.map:removeLayer("Borrador")

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
      img_enemigos_cliente:dibujar_enemigo(obj_data,self.mapa_files.enemigos)
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
      if obj_data and obj_data.mesh then
        lg.draw(obj_data.mesh)
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

function entidad_cliente:control_chat()
  if #self.chat> 11 then
      table.remove(self.chat,1)
  end
end

return entidad_cliente