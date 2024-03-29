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
	self.img_enemigos=self.mapa_files.enemigos

  self.tipo_suelo = self.mapa_files.tipo_suelo

	self.objetos_enemigos=self.mapa_files.objetos_enemigos

	self.world = love.physics.newWorld(0, 0, false)
	self.world:setCallbacks(self:callbacks())

	self:close_map()

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
	self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
	self.gameobject.arboles={}
	self.gameobject.inicios={}
  self.gameobject.otros={}
  self.gameobject.suelos={}

	self:map_read(self.map)
	self:inicios_random()
	self:custom_layers()

	self.chat={}
	self.texto_escrito=""
	self.escribiendo=false

	self.tiempo_chat=0
	self.max_tiempo_chat=3

  self.index_enemigos=1

end


function entidad_servidor:draw_entidad()
  if self.escribiendo then
    local lg_heigh = (lg.getHeight()*3/4)
    lg.setColor( 46/255, 49/255, 49/255, 0.5 )
    lg.rectangle("fill", 0, lg_heigh-50, 280, 20 )
    lg.setColor( 1, 1, 1, 1 )

    lg.printf(self.texto_escrito, 0, lg_heigh-50, lg.getWidth())
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
  local player = self.gameobject.players[1]

  if  player and player.obj then
    self.cam:setPosition(player.obj.ox,player.obj.oy)
    player.obj.rx,player.obj.ry=self:getXY()
    self.server:sendToAll("recibir_mira_servidor_cliente_1_1_muchos",{player.obj.rx,player.obj.ry})
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
      local esta_muerto = extra:dano(obj1.obj,obj2.obj.dano)

      if esta_muerto then
        local creador = obj2.obj.creador
        if creador == self.enemigos_id_creador then

        else
          self:aumentar_kill_personaje(creador)
        end
      end


      extra:efecto(obj1.obj,obj2.obj)
      obj2.obj:remove()
    elseif obj1.data=="escudo" and obj2.data=="bala" and obj1.obj.estados.protegido then
      obj2.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      local esta_muerto = extra:dano(obj1.obj,obj2.obj.dano_melee)
      if esta_muerto then
        local creador = obj2.obj.creador
        self:aumentar_kill_personaje(creador)
      end

      extra:empujon(obj2.obj,obj1.obj,-1)

      obj2.obj.estados.atacando_melee=false
    elseif obj1.data=="bala" and obj2.data=="bala" then
      obj1.obj:remove()
      obj2.obj:remove()
    --callback de enemigos
    elseif obj1.data == "bala" and obj2.data == "enemigos" then
      obj2.obj:validar_estado_bala(obj1.obj)
      local esta_muerto = extra:dano(obj2.obj,obj1.obj.dano)

      if esta_muerto then
        local creador = obj1.obj.creador
        self:aumentar_kill_enemigo(creador)
      end

      extra:efecto(obj2.obj,obj1.obj)
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:nueva_presas(obj1.obj)
    elseif obj1.data=="personaje" and obj2.data=="melee_enemigo" then
      local esta_muerto = extra:dano(obj1.obj,obj2.obj.dano_melee)

      if esta_muerto then

      end
      
      extra:empujon(obj2.obj,obj1.obj,1)
    elseif obj1.data=="enemigos" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      local esta_muerto = extra:dano(obj1.obj,obj2.obj.dano_melee)

      if esta_muerto then
        local creador = obj2.obj.creador
        self:aumentar_kill_enemigo(creador)
      end

      extra:empujon(obj2.obj,obj1.obj,1)

      obj1.obj.radio=-obj2.obj.radio

      obj2.obj.estados.atacando_melee=false

    elseif obj1.data=="personaje" and obj2.data=="destruible" then
      if obj2.obj.efecto then
        obj2.obj:efecto(obj1.obj)
      end

    elseif obj1.data=="enemigos" and obj2.data=="destruible" then
      if obj2.obj.efecto then
        obj2.obj:efecto(obj1.obj)
      end
    elseif obj1.data=="personaje" and obj2.data=="efecto_suelo" then
      obj1.obj.friccion = obj2.friccion
      obj1.obj.tocando = obj2.tocando
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
    elseif obj1.data=="personaje" and obj2.data=="efecto_suelo" then
      --obj1.obj.friccion = obj1.obj.friccion_original
    end
    
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
      --lg.print(obj_data.fsm.current,obj_data.ox,obj_data.oy-100)
      --lg.print(obj_data.efecto_tenidos.current,obj_data.ox,obj_data.oy-150)

      --[[for i,presa in ipairs(obj_data.presas) do
        lg.circle("fill",presa.ox,presa.oy,20)
      end]]
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
        lg.print(obj_data.nickname,obj_data.obj.ox,obj_data.obj.oy-75)
        --lg.print(obj_data.obj.friccion,obj_data.obj.ox,obj_data.obj.oy-100)
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

function entidad_servidor:keypressed(key)
  if key=="return" then
    self.escribiendo=not self.escribiendo

    if not self.escribiendo and #self.texto_escrito>0 then

        if self.texto_escrito=="INIT_GAME" and #self.gameobject.players>1 then
          self.texto_escrito="Iniciando partida"

          self.timer_udp_lista:after(1,function() 
            self.udp_server:close()
            self.usar_puerto_udp=false

          end)

          self.server:sendToAll("iniciar_juego",true)

          self:finalizar_busqueda()

          table.insert(self.chat,self.texto_escrito)
          self.server:sendToAll("chat_total",self.texto_escrito)
          self.texto_escrito=""
          self:control_chat()

        elseif self.texto_escrito=="END_GAME" then
          self:volver_menu()

        else
           table.insert(self.chat,self.texto_escrito)
          self.server:sendToAll("chat_total",self.texto_escrito)
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

    local p1 = self.gameobject.players[1]
    if p1 and p1.obj and teclas:validar(key) and self.estado_partida.current == "inicio" then

      self.server:sendToAll("recibir_servidor_cliente_1_1_muchos",{"keypressed",{key}})
  		p1.obj:keypressed(key)
  	end
  end
end

function entidad_servidor:keyreleased(key)
  if not self.escribiendo then
    local p1 = self.gameobject.players[1]
  	if p1 and p1.obj and teclas:validar(key) and self.estado_partida.current == "inicio" then

      self.server:sendToAll("recibir_servidor_cliente_1_1_muchos",{"keyreleased",{key}})
  		p1.obj:keyreleased(key)
  	end
  end
end

function entidad_servidor:mousepressed(x,y,button)
  if not self.escribiendo then
    local p1 = self.gameobject.players[1]
  	if p1 and p1.obj and self.estado_partida.current == "inicio" then
  		local cx,cy=self.cam:toWorld(x,y)

      self.server:sendToAll("recibir_servidor_cliente_1_1_muchos",{"mousepressed",{x,y,button}})
  		p1.obj:mousepressed(cx,cy,button)
  	end
  else
    if button==1 then
      self.escribiendo=false
    end
  end
end

function entidad_servidor:mousereleased(x,y,button)
  if not self.escribiendo then
    local p1 = self.gameobject.players[1]
  	if p1 and p1.obj and self.estado_partida.current == "inicio" then
  		local cx,cy=self.cam:toWorld(x,y)
      self.server:sendToAll("recibir_servidor_cliente_1_1_muchos",{"mousereleased",{x,y,button}})
  		p1.obj:mousereleased(cx,cy,button)
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

function entidad_servidor:remove_obj(name,obj)
	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidad_servidor:map_read(objects_map)

  for _, layer in ipairs(self.map.layers) do
    if layer.type=="tilelayer" then
      self:get_tile(layer)
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

           --print("{ '" .. obj.name .. "', {" )
          for _,data in ipairs(obj.polygon) do
            --print( data.x .. "," .. data.y .. "," )
            table.insert(polygon,data.x)
            table.insert(polygon,data.y)
          end
          --print( "}}," )

          objects_map[obj.name](self,polygon)
        else
          --print("{'" .. obj.name .. "'," .. obj.x .. "," .. obj.y .. "},")
          objects_map[obj.name](self,obj.x,obj.y)

        end
      end
    end
end

function entidad_servidor:get_tile(layer)
    --print("{'" .. layer.properties.efecto .. "' , {")
    local lista = {}
    for y=1, layer.height,1 do
      for x=1, layer.width,1 do
        local tile = layer.data[y][x]

        if tile then
          if tile.properties.efecto then
              local ox,oy = (x-1),(y-1)
              local t = {x=ox*self.w_tile,y=oy*self.h_tile,w=self.w_tile,h=self.h_tile}

              --print("{" .. t.x .. "," .. t.y .. "," .. t.w .. "," .. t.h .. "},")
              table.insert(lista,t)
          end
        end
      end
    end

  --print("}}")

    local objeto = self.tipo_suelo[layer.properties.efecto](self.world,lista)
    self.gameobject.suelos[layer.properties.efecto]=objeto

end

function entidad_servidor:control_chat()
  if #self.chat> 11 then
      table.remove(self.chat,1)
  end
end

function entidad_servidor:aumentar_id_creador()
  self.id_creador=self.id_creador+1
end

function entidad_servidor:close_map()
  local w,h=self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight
  local fin_mapa={}
  fin_mapa.collider=py.newBody(self.world,0,0,"static")
  fin_mapa.shape=py.newChainShape(true,0,0,w,0,h,w,0,h)
  fin_mapa.fixture=py.newFixture(fin_mapa.collider,fin_mapa.shape)
  
  fin_mapa.fixture:setUserData( {data="objeto",obj=self, pos=5} )
  
  return fin_mapa
end

function entidad_servidor:dar_xy_personaje()
  for i, ini in ipairs(self.gameobject.inicios) do
    if not ini.creacion_players and ini.tipo=="punto_inicio" then
      ini.creacion_players=true
      return ini.ox,ini.oy,i
    end
  end
end

function entidad_servidor:inicios_random()

    local tbl=self.gameobject.inicios
    local len, random = #tbl, lm.random ;
    for i = len, 2, -1 do
        local j = random( 1, i );
        tbl[i], tbl[j] = tbl[j], tbl[i];
    end
    return tbl;

end

function entidad_servidor:reiniciar_punto_resureccion(i)
    self.gameobject.inicios[i].creacion_players=false
end

function entidad_servidor:finalizar_busqueda()
  self.estado_partida:empezando()
end

function entidad_servidor:remove_player(obj)
  for i,data in ipairs(self.gameobject.players) do
    if data.obj==obj then
      local id = data.index
      self.gameobject.players[i].obj=nil
      --crear nuevo personaje
      if self.gameobject.players[i].vidas>0 then

          self.timer_juego:after(0.5, function()
            local player = self.gameobject.players[i]
            if player then
              self:crear_personaje_principal_otravez(player,player.personaje,player.nickname,player.creador)

            end
          end)
      end


      return id
    end
  end
end

function entidad_servidor:remove_player_total(obj)
  for i,data in ipairs(self.gameobject.players) do
    if data.obj==obj then
      local id = data.index
      table.remove(self.gameobject.players,i)
      return id
    end
  end
end

function entidad_servidor:get_enemigo_id()
    return self.index_enemigos
end

function entidad_servidor:incrementar_enemigo_id()
  self.index_enemigos=self.index_enemigos+1
end

function entidad_servidor:volver_menu()
  self:clear()
  self.timer_juego:clear()
  self.udp_server:close()
  self.server:destroy()
  self.timer_udp_lista:clear()
  Gamestate.switch(Menu)
end

return entidad_servidor