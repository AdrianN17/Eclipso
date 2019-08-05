local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"
local extra = require "entidades.funciones.extra"
local slab = require "libs.slab"

local entidad_cliente = require "entidades.entidad_cliente"

local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"

local cliente = Class{
    __includes={entidad_cliente}
}

function cliente:init()
	
end

function cliente:enter(gamestate,nickname,personaje,ip)
     print(nickname)
	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.contador_no_game=0
	self.id_player=nil

	local x,y=lg.getDimensions( )

	self.tickRate = 1/60
	self.tick = 0

	self.max_enemigos=0
	self.cantidad_actual_enemigos=0


	self.client = Sock.newClient(ip, 22122)

	self.client:setSerialization(bitser.dumps, bitser.loads)


	self.client:enableCompression()

	entidad_cliente.init(self)

	slab.Initialize()

	self.client:setSchema("player_init_data",
    {
        "id",
        "mapa",
        "seed",
        "actual_players",
        "max_enemigos"
    })

    self.client:setSchema("nuevo_player",
    {
        "index",
        "personaje",
        "nickname",
        "x",
        "y"
    })

   

    self.client:on("connect" , function(data)
    	self.client:send("informacion_primaria", {personaje,nickname})
   	end)


   self.client:on("player_init_data", function(data)
   		self.contador_no_game=0

        self.id_player=data.id

        lm.setRandomSeed(data.seed)

        self.max_enemigos=data.max_enemigos
      
        self:nuevo_mapa(data.mapa)


        for i, player in ipairs(data.actual_players) do
        	self:crear_personaje_principal(player.index,player.personaje,player.nickname,player.x,player.y)
        end

        local pl = self:verificar_existencia(self.id_player)
        self.cam:setPosition(pl.obj.ox,pl.obj.oy)

    end)

    self.client:on("nuevo_player", function(data)
        self:crear_personaje_principal(data.index,data.personaje,data.nickname,data.x,data.y)
    end)

    self.client:on("desconexion_player",function(index)

        local obj = self:verificar_existencia(index)
        if obj then
            obj.obj:remove()
        end
    end)

    self.client:on("remover_player",function(index)
        local obj = self:verificar_existencia(index)
        if obj then
            obj.obj:remove()
        end
    end)

    self.client:on("iniciar_juego",function(data)
        self.iniciar_partida=true
    end)


    self.client:on("chat_total", function(chat)
        table.insert(self.chat,chat)
        self:control_chat()
    end)
   

  	self.client:connect()

  	self.iniciar_partida=false


end

function cliente:draw()

    self:draw_entidad()

    lg.print(self.client:getState(), 5, 70)
    lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)
    lg.print("Numero :" .. tostring(self.id_player) ,20,30)
    
    lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    slab.Draw()
end

function cliente:update(dt)

    dt = math.min (dt, 1/30)

    self.client:update()
    slab.Update(dt)

    if not self.id_player then
  
        self.contador_no_game=self.contador_no_game+dt


        if self.contador_no_game > 3 and self.client:getRoundTripTime()> 400 then

          self:conexion_perdida()

        end
    elseif self.id_player and not self.client:isConnected() and self.client:getRoundTripTime()> 400 then
        self:conexion_perdida()
    end

  
    if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0


        self:update_entidad(dt)

        if #self.chat>0 then

            self.tiempo_chat=self.tiempo_chat+dt   

            if self.tiempo_chat>self.max_tiempo_chat then
              table.remove(self.chat,1)
              self.tiempo_chat=0
            end

        end

        local pl = self:verificar_existencia(self.id_player)

        if self.id_player and pl  and self.iniciar_partida then
            
            self.cam:setPosition(pl.obj.ox,pl.obj.oy)

            pl.obj.rx,pl.obj.ry=self:getXY()

            
        end
    end
end



function cliente:conexion_perdida()
    slab.BeginWindow('Excepcion', {Title = "Conexion fallida",X=self.center.x-25,Y=self.center.y-25})
        if slab.Button("Ok") then
            self.client:disconnectNow()

            Gamestate.switch(Menu)
        end 
    slab.EndWindow()
end

function cliente:nuevo_mapa(mapa)
	self.mapa_files=require ("entidades.mapas." .. mapa)
	self.map=sti(self.mapa_files.mapa)



	local x,y=lg.getDimensions( )
	self.map:resize(x,y)
	self.cam = gamera.new(0,0,self.mapa_files.x,self.mapa_files.y)
	self.cam:setWindow(0,0,x,y)

	self.img_personajes=require "assets.img.personajes.img_personajes"
	self.img_balas=require "assets.img.balas.img_balas"
	self.img_escudos=require "assets.img.escudos.img_escudos"
	self.img_objetos=self.mapa_files.objetos
	self.img_texturas=self.mapa_files.texturas
	self.img_enemigos=self.mapa_files.enemigos

	self.objetos_enemigos=self.mapa_files.objetos_enemigos

	self:close_map()

	self:map_read(self.map)
	self:custom_layers()
end

function cliente:verificar_existencia(index)
	local obj = nil

	for i,data in ipairs(self.gameobject.players) do
		if data.index==index then
			obj=data
			break
		end
	end

	return obj
end

function cliente:crear_personaje_principal(id,personaje,nickname,x,y)
	t={index=id, obj = personajes[personaje](self,self.id_creador,nickname,x,y)}
    self:add_obj("players",t)
    self:aumentar_id_creador()
end

function cliente:verificar_existencia(index)
	local obj = nil

	for i,data in ipairs(self.gameobject.players) do
		if data.index==index then
			obj=data
			break
		end
	end

	return obj
end

function cliente:quit()
    self.client:disconnectNow()
end

return cliente