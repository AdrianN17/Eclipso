local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"
local socket = require "socket"
local machine = require "libs.statemachine.statemachine"
local extra = require "entidades.funciones.extra"
local entidad_servidor = require "entidades.entidad_servidor"

local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"

local servidor_alterno = require "entidades.servidor_alterno"
local timer = require "libs.hump.timer"

local slab = require "libs.slab"

local servidor = Class{
	__includes={entidad_servidor,servidor_alterno}
}

function servidor:init()
	
end

function servidor:enter(gamestate,nickname,max_jugadores,max_enemigos,personaje,mapas,ip_direccion,tiempo,revivir)

  self.center={}
  self.center.x=lg.getWidth()/2
  self.center.y=lg.getHeight()/2


  self.tiempo_partida=tiempo*60
  self.tiempo_partida_inicial=0
  self.max_revivir=revivir

	self.timer_udp_lista=timer.new()
  self.timer_juego=timer.new()

	self.usar_puerto_udp=true

  self.estado_partida=machine.create({
    initial="espera",
    events = {
      {name = "empezando", from = "espera" , to = "inicio"},
      {name = "finalizando" , from = "inicio", to = "fin"}
  }
  })

	self.mapa_files=require ("entidades.mapas." .. mapas)
	self.map=sti(self.mapa_files.mapa)

	self.max_enemigos=max_enemigos
	self.cantidad_actual_enemigos=0

	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam = gamera.new(0,0,self.mapa_files.x,self.mapa_files.y)
  
	self.cam:setWindow(0,0,x,y)

  self.respawn_enemigos_lista={}
  self.enemigos_eliminados={}

  --creacion servidor udp 
  servidor_alterno.init(self,ip_direccion)

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

  self.server:setSchema("recibir_mira_cliente_servidor_1_1",{"rx","ry"})

  self.server:setSchema("enviar_vista",{"cx","cy","cw","ch"})


  self.server:on("recibir_mira_cliente_servidor_1_1",function(data,client)
      local index =client:getIndex()
      local obj = self:verificar_existencia(index)

      if obj and obj.obj then
        obj.obj.rx,obj.obj.ry=data.rx,data.ry

        self.server:sendToAllBut(client,"recibir_mira_servidor_cliente_1_muchos",{index,data.rx,data.ry})
      end

    end)

  self.server:on("enviar_vista", function(data,client)
      local index =client:getIndex()
      local obj = self:verificar_existencia(index)

      if obj then
        obj.cx,obj.cy,obj.cw,obj.ch=data.cx,data.cy,data.cw,data.ch
      end
  end)


  self.server:on("recibir_cliente_servidor_1_1" ,function(data,client)
    local index=client:getIndex()

    local obj = self:verificar_existencia(index)

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
    if self.estado_partida.current=="espera" then
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

        local radios_objetos = self:enviar_radios_objetos()
        local radios_arboles = self:enviar_radios_arboles()


        client:send("player_init_data", {index,mapas,actual_players,self.max_enemigos,radios_objetos,radios_arboles}) 


        local obj = self:verificar_existencia(index)

        if obj then
        
          self.server:sendToAllBut(client,"nuevo_player", {index,obj.obj.tipo,obj.obj.nickname,obj.obj.x,obj.obj.y})

        end
      else
        client:disconnectNow()
      end

  	end)

  	self.server:on("disconnect", function(data, client)

    	local index =client:getIndex()

    	local obj = self:verificar_existencia(index)
    	if obj then
        if obj.obj then
    		  obj.obj:remove_final()
        else
          self:remove_desde_raiz(obj)
        end
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

    self.jugadores_ganadores={}
    
end

function servidor:draw()
    local cx,cy,cw,ch=self.cam:getVisible()

  	self.map:draw(-cx,-cy,1,1)

    self:draw_entidad()

    --[[self.cam:draw(function(l,t,w,h)
      for _, body in pairs(self.world:getBodies()) do
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
      end
    end)]]

  	lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    lg.print("Clientes: "..tostring(self.server:getClientCount()), 10, 30)

    slab.Draw()
end

function servidor:update(dt)

  dt = math.min (dt, 1/30)

  slab.Update(dt)

	self.timer_udp_lista:update(dt)

	if self.usar_puerto_udp then
		self:update_alterno(dt)
	end

	self.tick = self.tick + dt

	if self.tick >= self.tickRate then
		self.tick = 0

    self.timer_juego:update(dt)
		self.server:update(dt)
		self:update_entidad(dt)

		if self.estado_partida.current == "inicio" then
        self.tiempo_partida_inicial=self.tiempo_partida_inicial+dt

        if self.tiempo_partida_inicial>self.tiempo_partida or self:contabilizar_jugadores() <= 1 then
            self:ver_jugadores_ultimos_vivos()
            self.server:sendToAll("partida_finalizada",self.jugadores_ganadores)
            self.estado_partida:finalizando()

          self.tiempo_partida_inicial=0
        end

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

    if self.estado_partida.current == "fin" then
      self:pantalla_score()
    end
end


function servidor:crear_personaje_principal(id,personaje,nickname)
  local obj = personajes[personaje](self,self.id_creador,nickname)

	t={index=id, obj =obj ,personaje=personaje,nickname=nickname,vidas=self.max_revivir,creador = self.id_creador,kills_enemigos=0,kills_personajes=0}
    self:add_obj("players",t)
    self:aumentar_id_creador()
end

function servidor:crear_personaje_principal_otravez(player,personaje,nickname,creador)
  player.obj = personajes[personaje](self,creador,nickname)
  player.vidas=player.vidas-1

  local ox,oy = player.obj.ox,player.obj.oy
  local index = player.index

  self.server:sendToAll("revivir_usuarios",{index,personaje,nickname,creador,ox,oy})

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
        local aliados,enemigos = extra:enviar_data_primordiar_jugador(self,obj)
        self.server:sendToPeer( peer,"enviar_data_principal", {aliados,enemigos,self.respawn_enemigos_lista,self.enemigos_eliminados})
      end
    end

    self.respawn_enemigos_lista={}
    self.enemigos_eliminados={}
end

function servidor:enviar_radios_objetos()
    local obj_lista={}
    for _,obj in ipairs(self.gameobject.objetos) do
      local t={ox=obj.ox,oy=obj.oy,radio=obj.radio}
      table.insert(obj_lista,t)
    end

    return obj_lista
end

function servidor:enviar_radios_arboles()
    local obj_lista={}
    for _,obj in ipairs(self.gameobject.arboles) do
      local t={ox=obj.ox,oy=obj.oy,radio=obj.radio}
      table.insert(obj_lista,t)
    end

    return obj_lista
end

function servidor:quit()
  self.timer_juego:clear()
  self.timer_udp_lista:clear()
  self:clear()
  self.server:destroy()
  self.udp_server:close()
end

function servidor:clear()
  self.map=nil
  self.cam=nil
  self.world:destroy( )
  self.gameobject.players={}
  self.gameobject.balas={}
  self.gameobject.efectos={}
  self.gameobject.destruible={}
  self.gameobject.enemigos={}
  self.gameobject.objetos={}
  self.gameobject.arboles={}
  self.gameobject.inicios={}
end

function servidor:contabilizar_jugadores()
  local i = 0
  for _,player in ipairs(self.gameobject.players) do
    if player.obj  or player.vidas>0 then
      i=i+1
    end
  end
  return i
end

function servidor:pantalla_score()
  slab.BeginWindow('Fin_juego', {Title = "Juego finalizado",X=self.center.x -250,Y=self.center.y-200 ,W = 500,H = 400, AutoSizeWindow = false, AllowMove=false,Columns = 4,AllowResize = false})

    slab.BeginColumn(1)
    slab.Text("Lista", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(i, {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(2)
    slab.Text("Nickname", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.nickname , {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(3)
    slab.Text("Kills personaje", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.kills_personajes , {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(4)
    slab.Text("Kills enemigos", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.kills_enemigos , {CenterX = true})
    end
    slab.EndColumn()



  if slab.Button("Volver al menu",{ExpandW = true}) then
    self:volver_menu() 
  end 
  slab.EndWindow()
end

function servidor:ver_jugadores_ultimos_vivos()
    for i,player in ipairs(self.gameobject.players) do
      if player and player.obj then
        t={nickname = player.nickname, kills_personajes = player.kills_personajes, kills_enemigos = player.kills_enemigos}
        table.insert(self.jugadores_ganadores,t)
      end
    end
end

function servidor:buscar_personaje_creador(creador)
  local obj=nil
  for i,player in ipairs(self.gameobject.players) do
    if player and player.obj and player.obj.creador == creador then
      obj=player
    end
  end

  return obj
end

function servidor:aumentar_kill_personaje(creador)
  local obj = self:buscar_personaje_creador(creador)
  if obj then
    obj.kills_personajes=obj.kills_personajes+1
  end
end

function servidor:aumentar_kill_enemigo(creador)
  local obj = self:buscar_personaje_creador(creador)
  if obj then
    obj.kills_enemigos=obj.kills_enemigos+1
  end
end

function servidor:remove_desde_raiz(obj)
  for i,player in ipairs(self.gameobject.players) do
    if player == obj then
      table.remove(self.gameobject.players,i)
    end
  end
end

return servidor

