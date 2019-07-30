local Class= require "libs.hump.class"
local teclas = require "entidades.funciones.teclas"
local utf8 = require "utf8"
local extra = require "entidades.funciones.extra"

local entidad_servidor = Class{}

function entidad_servidor:init()

  self.id_player=0

  self.id_creador=1
  self.enemigos_id_creador=100

	self.img_personajes=require "assets.img.personajes.img_personajes"
	self.img_balas=require "assets.img.balas.img_balas"
	self.img_escudos=require "assets.img.escudos.img_escudos"
  self.img_objetos=self.mapa_files.objetos
  self.img_texturas=self.mapa_files.texturas

	self.world = love.physics.newWorld(0, 0, false)
  self.world:setCallbacks(self:callbacks())

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
  self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  self.gameobject.arboles={}
  self.gameobject.inicios={}

  self:map_read(self.map)
  self:custom_layers()

  self.chat={}
  self.texto_escrito=""
  self.escribiendo=false

  self.tiempo_chat=0
  self.max_tiempo_chat=3

  self.envio_destruible=false

end

function entidad_servidor:draw_entidad()
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

function entidad_servidor:update_entidad(dt)
	local player = self.gameobject.players[0]
    
    --camara-muerte del usuario
    if  player then
		  self.cam:setPosition(player.ox,player.oy)
      player.rx,player.ry=self:getXY()
	 end
end

function entidad_servidor:callbacks()
	local beginContact =  function(a, b, coll)

		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()

		if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end

 		local x,y=coll:getNormal()


    if obj1.data=="bala" and obj2.data=="objeto" then
      obj1.obj:remove()
    elseif obj1.data=="bala" and obj2.data=="destruible" then

      local x1, y1, x2, y2 = coll:getPositions( )
      if x1 and y1 then
        local poly = obj2.obj:poligono_recorte(x1,y1)
      end
      
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="bala" then
      extra:dano(obj1.obj,obj2.obj.dano)
      obj2.obj:remove()
    elseif obj1.data=="escudo" and obj2.data=="bala" and obj1.obj.estados.protegido then
      obj2.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      extra:dano(obj1.obj,obj2.obj.dano_melee)
      
      local r = obj2.obj.radio-math.pi/2
      local ix,iy=math.cos(r),math.sin(r)
      obj1.obj.collider:applyLinearImpulse( -10000*ix,-10000*iy )

      obj2.obj.estados.atacando_melee=false
    end
    	
  end
  
  local endContact =  function(a, b, coll)
   	local obj1=nil
   	local obj2=nil

  	local o1,o2=a:getUserData(),b:getUserData()
      
    if o1.pos<o2.pos then
  		obj1=o1
  		obj2=o2
  	else
  		obj1=o2
  		obj2=o1
  	end
    
    local x,y=coll:getNormal()
    
  end
  
  local preSolve =  function(a, b, coll)
	    
  end
  
  local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)

	end

	return beginContact,endContact,preSolve,postSolve
end

function entidad_servidor:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

function entidad_servidor:custom_layers()
  
  local Balas_layers = self.map.layers["Balas"]
  
  local Enemigos_layers = self.map.layers["Enemigos"] 
  
  local Personajes_layers = self.map.layers["Personajes"]
  
  local Destruible_layers = self.map.layers["Destruible"]
  
  local Objetos_layers = self.map.layers["Objetos"]
  
  local Arboles_layers = self.map.layers["Arboles"]

  local Inicios_layers = self.map.layers["Inicios"]

  Balas_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.balas) do
      obj_data:draw()
    end
  end
  
  Balas_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.balas) do
      obj_data:update(dt)
    end
  end
  
  
  
  Enemigos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:draw()
    end
  end
  
  Enemigos_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:update(dt)
    end
  end
  
  Personajes_layers.draw = function(obj)
    for i=0,#self.gameobject.players,1 do
      local obj_data = self.gameobject.players[i]

      if obj_data then
        obj_data:draw()

        lg.print(tostring(obj_data.hp) .. " , "  .. tostring(obj_data.ira) , obj_data.ox,obj_data.oy-100) 
      end

    end
  end
  
  Personajes_layers.update = function(obj,dt)
    for i=0,#self.gameobject.players,1 do
      local obj_data = self.gameobject.players[i]

      if obj_data then
        obj_data:update(dt)
      end
    end
  end
  
  Destruible_layers.draw = function(obj)
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        obj_data:draw()
      end
    end
  end
  
  Destruible_layers.update = function(obj,dt)
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        obj_data:update(dt)
      end
    end
  end
  
  Objetos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.objetos) do
      obj_data:draw()
    end
  end
  
  Objetos_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.objetos) do
      obj_data:update(dt)
    end
  end
  
  Arboles_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.arboles) do
      obj_data:draw()
    end
  end
  
  Arboles_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.arboles) do
      obj_data:update(dt)
    end
  end

  Inicios_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.inicios) do
      obj_data:draw()
    end
  end

  Inicios_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.inicios) do
      obj_data:update(dt)
    end
  end
end

function entidad_servidor:keypressed(key)
  if key=="return" then
    self.escribiendo=not self.escribiendo

    if not self.escribiendo and #self.texto_escrito>0 then
        table.insert(self.chat,self.texto_escrito)
        self.server:sendToAll("chat_total",self.texto_escrito)
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

    local p1 = self.gameobject.players[0]
    if  p1 and teclas:validar(key) then
  		p1:keypressed(key)
  	end
  end
end

function entidad_servidor:keyreleased(key)
  if not self.escribiendo then
    local p1 = self.gameobject.players[0]
  	if p1 and teclas:validar(key) then
  		p1:keyreleased(key)
  	end
  end
end

function entidad_servidor:mousepressed(x,y,button)
  if not self.escribiendo then
    local p1 = self.gameobject.players[0]
  	if p1 then
  		local cx,cy=self.cam:toWorld(x,y)
  		p1:mousepressed(cx,cy,button)
  	end
  else
    if button==1 then
      self.escribiendo=false
    end
  end
end

function entidad_servidor:mousereleased(x,y,button)
  if not self.escribiendo then
    local p1 = self.gameobject.players[0]
  	if p1 then
  		local cx,cy=self.cam:toWorld(x,y)
  		p1:mousereleased(cx,cy,button)
  	end
  end
end

function entidad_servidor:textinput(t)
    if self.escribiendo then
      if #self.texto_escrito<40 then
        self.texto_escrito = self.texto_escrito .. t
      end
    end
end

function entidad_servidor:add_obj(name,obj)
	table.insert(self.gameobject[name],obj)
end

function entidad_servidor:add_players(obj)
    if #self.gameobject.players==0 and  self.gameobject.players[0] == nil then

      self.gameobject.players[0]=obj
    else
      self.gameobject.players[#self.gameobject.players+1]=obj
    end
end

function entidad_servidor:remove_obj(name,obj)
	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidad_servidor:identificador(obj)
  for i=0,#self.gameobject.players,1 do
    local obj_data = self.gameobject.players[i]

    if obj_data and obj == obj_data then
      return i
    end
  end
end

function entidad_servidor:remove_to_nill(obj)
  for i=0,#self.gameobject.players,1 do
    local obj_data = self.gameobject.players[i]

    if obj_data and obj == obj_data then
      self.gameobject.players[i]=nil

      return i
    end
  end
end

function entidad_servidor:remove_personaje(i)
  if self.gameobject.players[i] then
    self.gameobject.players[i]:remove()   
    self.gameobject.players[i]=nil
  end
end

function entidad_servidor:map_read(objects_map)

  for _, layer in ipairs(self.map.layers) do
    if layer.type=="tilelayer" then
      --self:get_tile(layer)
    elseif layer.type=="objectgroup" then
      self:get_objects(layer,self.mapa_files.objetos_data)
    end
  end
  
  self.map:removeLayer("Borrador")
  
end

function entidad_servidor:get_objects(objectlayer,objects_map)
  
    for _, obj in pairs(objectlayer.objects) do
      if obj.name then
        if obj.properties.destruible then

          local polygon = {}

          for _,data in ipairs(obj.polygon) do
     
            table.insert(polygon,data.x)
            table.insert(polygon,data.y)
          end

          objects_map[obj.name](self,polygon)
        else
          objects_map[obj.name](self,obj.x,obj.y)
        end
      end
    end
end

function entidad_servidor:control_chat()
  if #self.chat> 11 then
      table.remove(self.chat,1)
  end
end

function entidad_servidor:aumentar_id_creador()
  self.id_creador=self.id_creador+1
end

return entidad_servidor