local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"
local socket = require "socket"

local extra = require "entidades.funciones.extra"

local entidad_servidor = require "entidades.entidad_servidor"

local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"

local servidor_alterno = require "entidades.servidor_alterno"
local timer = require "libs.hump.timer"


local servidor = Class{
	__includes={entidad_servidor,servidor_alterno}
}

function servidor:init()
	
end

function servidor:enter(gamestate,nickname,max_jugadores,max_enemigos,personaje,mapas,ip_direccion)
  self.timer_udp_lista=timer.new()
  self.usar_puerto_udp=true

  self.iniciar_partida=false
  
	self.mapa_files=require ("entidades.mapas." .. mapas)
	self.map=sti(self.mapa_files.mapa)

  self.max_enemigos=max_enemigos
  self.cantidad_actual_enemigos=0

	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam = gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setWindow(0,0,x,y)

	--creacion de servidor

	entidad_servidor.init(self)

	personajes[personaje](self,self.id_creador,nickname)
  self:aumentar_id_creador()

	--informacion de servidor
	self.tickRate = 1/60
  self.tick = 0
  
  self.server = Sock.newServer(ip_direccion,22122,max_jugadores)
  self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()

  self.server:setSchema("informacion_primaria",{
    "personaje",
    "nickname"
  })

  



	self.server:on("connect", function(data, client)
		  local index=client:getIndex()

      local objetos_data,arboles_data,inicios_data = extra:extra_data_fija(self)
      local destruible_data = extra:extra_destruibles(self)

      client:send("player_init_data", {index,mapas,objetos_data,arboles_data,inicios_data,destruible_data}) 

  	end)
  
  	self.server:on("informacion_primaria", function(data, client)
    	local index=client:getIndex()

    	self.gameobject.players[index] = personajes[data.personaje](self,self.id_creador,data.nickname)
      self:aumentar_id_creador()

      local pj=self.gameobject.players[index]

      
      self.server:sendToAll("creacion_jugador_cliente",{index,pj.ox,pj.oy,pj.tipo,pj.tipo_escudo,pj.nombre})

      local pj_0=self.gameobject.players[0]

      client:send("creacion_jugador_cliente",{0,pj_0.ox,pj_0.oy,pj_0.tipo,pj_0.tipo_escudo,pj_0.nombre})
  	end)


    self.server:on("disconnect", function(data, client)

    	local index =client:getIndex()

    	self:remove_personaje(index)

    	self.server:sendToAll("desconexion_player", index)
    end)


    self.server:on("datos", function(datos, client)
      	local index = client:getIndex()

      	local pl=self.gameobject.players[index]

      	if pl then
        	extra:recibir_data_jugador(datos,pl)
      	end
    end)

    self.server:on("chat", function(chat,client)

      table.insert(self.chat,chat)

      self:control_chat()

      self.server:sendToAllBut(client,"chat_total",chat)

    end)

    --callbacks

    self.server:on("mouse_pressed" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl and self.iniciar_partida then
        	pl:mousepressed(datos.x,datos.y,datos.button)
      	end
    end)

    self.server:on("mouse_released" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl and self.iniciar_partida then
        	pl:mousereleased(datos.x,datos.y,datos.button)
      	end
    end)

    self.server:on("key_pressed" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

      	if pl and self.iniciar_partida then
        	pl:keypressed(datos.key)
      	end
    end)

    self.server:on("key_released" , function(datos, client)
    	local index = client:getIndex()
      	local pl=self.gameobject.players[index]

       	if pl and self.iniciar_partida then
        	pl:keyreleased(datos.key)
      	end
    end)

    self.datos_servidor={
      mapa = mapas,
      max_jugadores = max_jugadores
    }

    servidor_alterno.init(self,ip_direccion)

end

function servidor:draw()
	local cx,cy,cw,ch=self.cam:getVisible()

  	self.map:draw(-cx,-cy,1,1)

    self:draw_entidad()

  	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    lg.print("Clientes: "..tostring(self.server:getClientCount()), 10, 30)
end

function servidor:update(dt)

  self.timer_udp_lista:update(dt)

  if self.usar_puerto_udp then
    self:update_alterno(dt)
  end

	self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0
        
	    self.server:update(dt)
      self:update_entidad(dt)

      if self.iniciar_partida then

  	    self.world:update(dt) 
  	    self.map:update(dt) 

      end

      if #self.chat>0 then

        self.tiempo_chat=self.tiempo_chat+dt   

        if self.tiempo_chat>self.max_tiempo_chat then
          table.remove(self.chat,1)
          self.tiempo_chat=0
        end

      end


	    local player_data={}
    
		    for i=0,#self.gameobject.players,1 do 
		      if self.gameobject.players[i] == nil then
		        player_data[i]=nil
		      else
            local t = self.gameobject.players[i]:pack()
		        player_data[i]= {index = i , paquete = t}
		      end
		    end

		    local balas_data,enemigo_data = extra:extra_data(self)

        if self.envio_destruible then
          local destruible_data = extra:extra_destruibles(self)
          self.server:sendToAll("nuevos_destruibles",destruible_data)

          self.envio_destruible=false
        end

		    self.server:sendToAll("data_movil", {player_data,balas_data,enemigo_data})

        self.tiempo_envio_data=0
  end

end

function servidor:quit()
  self.timer_udp_lista:clear()
	self.server:destroy()
  self.udp_server:close()
  
end




return servidor