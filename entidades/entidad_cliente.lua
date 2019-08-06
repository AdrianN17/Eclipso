local Class= require "libs.hump.class"
local sti = require "libs.sti"
local teclas = require "entidades.funciones.teclas"
local extra = require "entidades.funciones.extra"

local utf8 = require("utf8")

local entidad_cliente = Class{}

function entidad_cliente:init()
	self.id_creador=1
	self.enemigos_id_creador=100

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

	self.tiempo_chat=0
	self.max_tiempo_chat=3

	self.world = love.physics.newWorld(0, 0, false)
	self.world:setCallbacks(self:callbacks())

	self.chat={}
	self.texto_escrito=""
	self.escribiendo=false

	self.tiempo_chat=0
	self.max_tiempo_chat=3

  self.index_enemigos=1

end

function entidad_cliente:callbacks()
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
      --extra:dano(obj1.obj,obj2.obj.dano)
      extra:efecto(obj1.obj,obj2.obj)
      obj2.obj:remove()
    elseif obj1.data=="escudo" and obj2.data=="bala" and obj1.obj.estados.protegido then
      obj2.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      --extra:dano(obj1.obj,obj2.obj.dano_melee)
      
      extra:empujon(obj2.obj,obj1.obj,-1)

      obj2.obj.estados.atacando_melee=false
    elseif obj1.data=="bala" and obj2.data=="bala" then
      obj1.obj:remove()
      obj2.obj:remove()
    --callback de enemigos
    elseif obj1.data == "bala" and obj2.data == "enemigos" then
      obj2.obj:validar_estado_bala(obj1.obj)
      --extra:dano(obj2.obj,obj1.obj.dano)
      extra:efecto(obj2.obj,obj1.obj)
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:nueva_presas(obj1.obj)
    elseif obj1.data=="personaje" and obj2.data=="melee_enemigo" then
      --extra:dano(obj1.obj,obj2.obj.dano_melee)
      
      extra:empujon(obj2.obj,obj1.obj,1)
    elseif obj1.data=="enemigos" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      --extra:dano(obj1.obj,obj2.obj.dano_melee)

      extra:empujon(obj2.obj,obj1.obj,1)

      obj1.obj.radio=-obj2.obj.radio

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

    if obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:eliminar_presas(obj1.obj)
    end
    
  end
  
  local preSolve =  function(a, b, coll)
	    
  end
  
  local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)

	end

	return beginContact,endContact,preSolve,postSolve
end

function entidad_cliente:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
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
      --lg.print(obj_data.hp,obj_data.ox,obj_data.oy-50)
      --lg.print(obj_data.fsm.current,obj_data.ox,obj_data.oy-100)
      --lg.print(obj_data.efecto_tenidos.current,obj_data.ox,obj_data.oy-150)
    end
  end
  
  Enemigos_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:update(dt)
    end
  end
  
  Personajes_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.players) do
      if obj_data.obj then
        obj_data.obj:draw()
        --lg.print(obj_data.obj.efecto_tenidos.current,obj_data.obj.ox,obj_data.obj.oy-150)
      end
    end
  end
  
  Personajes_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.players) do
      if obj_data.obj then
        obj_data.obj:update(dt)
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

function entidad_cliente:add_obj(name,obj)
	table.insert(self.gameobject[name],obj)
end

function entidad_cliente:remove_obj(name,obj)
	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidad_cliente:map_read(objects_map)

  for _, layer in ipairs(self.map.layers) do
    if layer.type=="tilelayer" then
      --self:get_tile(layer)
    elseif layer.type=="objectgroup" then
      self:get_objects(layer,self.mapa_files.objetos_data)
    end
  end
  
  self.map:removeLayer("Borrador")
  
end

function entidad_cliente:get_objects(objectlayer,objects_map)
  
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

function entidad_cliente:aumentar_id_creador()
  self.id_creador=self.id_creador+1
end

function entidad_cliente:close_map()
  local w,h=self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight
  local fin_mapa={}
  fin_mapa.collider=py.newBody(self.world,0,0,"static")
  fin_mapa.shape=py.newChainShape(true,0,0,w,0,h,w,0,h)
  fin_mapa.fixture=py.newFixture(fin_mapa.collider,fin_mapa.shape)
  
  fin_mapa.fixture:setUserData( {data="objeto",obj=self, pos=5} )
  
  return fin_mapa
end

function entidad_cliente:draw_entidad()

  
  
	if self.map and self.cam then
		local cx,cy,cw,ch=self.cam:getVisible()

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
	if self.map and self.iniciar_partida then
		  self.world:update(dt)
    	self.map:update(dt)

      if self.id_player then
        local pl = self:verificar_existencia(self.id_player)

        if pl and pl.obj then
          self.cam:setPosition(pl.obj.ox,pl.obj.oy)
          pl.obj.rx,pl.obj.ry=self:getXY()
        end
      end

	end
end

function entidad_cliente:keypressed(key)
	if self.client:getState() == "connected" and self.id_player  then
    if key=="return" then
      self.escribiendo=not self.escribiendo

      if not self.escribiendo and #self.texto_escrito>0 then
          if self.texto_escrito == "EXIT_GAME" then
            
            self.client:disconnectNow()

            Gamestate.switch(Menu)
          else
            table.insert(self.chat,self.texto_escrito)
            self.client:send("chat", self.texto_escrito )
            self.texto_escrito=""
            self:control_chat()
          end
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
        local pl = self:verificar_existencia(self.id_player)

        if pl and self.iniciar_partida and pl.obj then
          self.client:send("recibir_cliente_servidor_1_1",{"keypressed",{key}})
          pl.obj:keypressed(key)
        end
      end
    end              
  end
end

function entidad_cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
      if teclas:validar(key) and not self.escribiendo then
        local pl = self:verificar_existencia(self.id_player)

        if pl and self.iniciar_partida and pl.obj then
          self.client:send("recibir_cliente_servidor_1_1",{"keyreleased",{key}})
          pl.obj:keyreleased(key)
        end
      end
  end
end

function entidad_cliente:mousepressed(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
      if not self.escribiendo then
       	local pl = self:verificar_existencia(self.id_player)

          if pl and self.iniciar_partida and pl.obj then
  	        local cx,cy=self.cam:toWorld(x,y)
            self.client:send("recibir_cliente_servidor_1_1",{"mousepressed",{x,y,button}})
            pl.obj:mousepressed(x,y,button)
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
      	local pl = self:verificar_existencia(self.id_player)

          if pl and self.iniciar_partida and pl.obj then
          	local cx,cy=self.cam:toWorld(x,y)
            self.client:send("recibir_cliente_servidor_1_1",{"mousereleased",{x,y,button}})
            pl.obj:mousereleased(x,y,button)
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

function entidad_cliente:control_chat()
  if #self.chat> 11 then
      table.remove(self.chat,1)
  end
end

function entidad_cliente:remove_player(obj)
  for i,data in ipairs(self.gameobject.players) do
    if data.obj==obj then
      local id = data.index
      table.remove(self.gameobject.players,i)
      return id
    end
  end
end

function entidad_cliente:get_enemigo_id()
    return self.index_enemigos
end

function entidad_cliente:incrementar_enemigo_id()
  self.index_enemigos=self.index_enemigos+1
end

return entidad_cliente
