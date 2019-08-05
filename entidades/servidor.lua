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
	self.cam = gamera.new(0,0,self.mapa_files.x,self.mapa_files.y)
  
	self.cam:setWindow(0,0,x,y)

	--creacion de servidor

	entidad_servidor.init(self)

	

	--informacion de servidor
	self.tickRate = 1/60
	self.tick = 0

	self.server = Sock.newServer(ip_direccion,22122,max_jugadores)
	self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()

  self:crear_personaje_principal(0,personaje,nickname)

	self.server:setSchema("informacion_primaria",{
		"personaje",
		"nickname"
	})


  self.server:setSchema("recibir_cliente_servidor_1_1",
    {"tipo","data"})

  self.server:setSchema("recibir_mira_cliente_servidor_1_1",{"rx","ry","cx","cy","cw","ch"})


  self.server:on("recibir_mira_cliente_servidor_1_1",function(data,client)
      local index =client:getIndex()
      local obj = self:verificar_existencia(index)

      if obj then
        obj.obj.rx,obj.obj.ry=data.rx,data.ry

        obj.cx,obj.cy,obj.cw,obj.ch=data.cx,data.cy,data.cw,data.ch

        self.server:sendToAllBut(client,"recibir_mira_servidor_cliente_1_muchos",{index,data.rx,data.ry})
      end

    end)


  self.server:on("recibir_cliente_servidor_1_1" ,function(data,client)
    local index=client:getIndex()

    local obj = self:verificar_existencia(index)

    --print("recibir_cliente_servidor_1_1",data.tipo,obj,index)


    if obj then

      if data.tipo=="keypressed" then
        obj.obj:keypressed(data.data[1])
      elseif data.tipo=="keyreleased" then
        obj.obj:keyreleased(data.data[1])
      elseif data.tipo=="mousepressed" then
        obj.obj:mousepressed(data.data[1],data.data[2],data.data[3])
      elseif data.tipo=="mousereleased" then
        obj.obj:mousereleased(data.data[1],data.data[2],data.data[3])
      end

      self.server:sendToAllBut(client,"recibir_servidor_cliente_1_muchos",{index,data.tipo,data.data})
    end

  end)




	self.server:on("informacion_primaria", function(data, client)
    	local index=client:getIndex()

      self:crear_personaje_principal(index,data.personaje,data.nickname)

      local index=client:getIndex()

      local actual_players={}

      for i,player in ipairs(self.gameobject.players) do
        local t = {}
        t.index = player.index 
        t.x=player.obj.x
        t.y=player.obj.y
        t.nickname=player.obj.nickname
        t.personaje=player.obj.tipo

        table.insert(actual_players,t)
      end

      _G.lm.setRandomSeed(1)
      _G.seed = lm.getRandomSeed()


      client:send("player_init_data", {index,mapas,seed,actual_players,self.max_enemigos}) 


      local obj = self:verificar_existencia(index)

      if obj then
      
        self.server:sendToAllBut(client,"nuevo_player", {index,obj.obj.tipo,obj.obj.nickname,obj.obj.x,obj.obj.y})

      end

  	end)

  	self.server:on("disconnect", function(data, client)

    	local index =client:getIndex()

    	local obj = self:verificar_existencia(index)
    	if obj then
    		obj.obj:remove_final()
    		self.server:sendToAll("desconexion_player", index)
    	end
    end)

    self.server:on("chat", function(chat,client)

      table.insert(self.chat,chat)

      self:control_chat()

      self.server:sendToAllBut(client,"chat_total",chat)

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

  dt = math.min (dt, 1/30)

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


    self:envio_masivo_validaciones()


		if #self.chat>0 then

      self.tiempo_chat=self.tiempo_chat+dt   

        if self.tiempo_chat>self.max_tiempo_chat then
          table.remove(self.chat,1)
          self.tiempo_chat=0
        end
      end
	end
end


function servidor:crear_personaje_principal(id,personaje,nickname)
	t={index=id, obj = personajes[personaje](self,self.id_creador,nickname)}
    self:add_obj("players",t)
    self:aumentar_id_creador()
end

function servidor:verificar_existencia(index)
	local obj = nil

	for i,data in ipairs(self.gameobject.players) do
		if data.index==index then
			obj=data
			break
		end
	end

	return obj
end

function servidor:envio_masivo_validaciones()
    local clientes = self.server:getClients()

    for _, cliente in ipairs(clientes) do
      local index = cliente:getIndex()
      local peer = self.server:getPeerByIndex(index)
      local obj = self:verificar_existencia(index)

      if obj and obj.cx and obj.cy and obj.cw and obj.ch then
        self.server:sendToPeer( peer,"enviar_data_principal", {extra:enviar_data_primordiar_jugador(self,obj)})
      end
    end
end

function servidor:quit()
  self.timer_udp_lista:clear()
  self.server:destroy()
  self.udp_server:close()
end

return servidor

