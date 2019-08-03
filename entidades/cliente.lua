local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local extra = require "entidades.funciones.extra"
local slab = require "libs.slab"
local molde_personaje = require "entidades.solo_cliente.molde_personaje"

local entidad_cliente = require "entidades.entidad_cliente"

local mesh_destruible = require "entidades.solo_cliente.mesh_destruible"

local cliente = Class{
    __includes={entidad_cliente}
}

function cliente:init()
	
end

function cliente:enter(gamestate,nickname,personaje,ip)
    self.center={}
    self.center.x=lg.getWidth()/2
    self.center.y=lg.getHeight()/2

    self.contador_no_game=0
    self.id_player=nil

    local x,y=lg.getDimensions( )

    self.cam = gamera.new(0,0,1000,1000)
    self.cam:setWindow(0,0,x,y)

    self.map=nil

	self.tickRate = 1/60
  	self.tick = 0



	self.client = Sock.newClient(ip, 22122)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
  	self.client:enableCompression()

    self.world = love.physics.newWorld(0, 0, false)

    entidad_cliente.init(self)


  
  
  	self.client:setSchema("data_movil", {
        "player_data",
        "balas_data",
        "enemigo_data"
    })

    self.client:setSchema("player_init_data",
    {
        "id",
        "mapa",
        "objetos",
        "arboles",
        "inicios",
        "destruible"
    })

    self.client:setSchema("creacion_jugador_cliente",{
    "index",
    "x",
    "y",
    "personaje",
    "escudo",
    "nombre"
  })

    self.client:on("player_init_data", function(data)

        self.contador_no_game=0

        self.id_player=data.id  
      
        self:crear_mapa(data.mapa)

        self.gameobject.objetos=data.objetos
        self.gameobject.arboles=data.arboles
        self.gameobject.inicios=data.inicios



        self.gameobject.destruible = mesh_destruible:generar_mesh(data.destruible,self.img_texturas)

        
        self.client:send("informacion_primaria", {personaje,nickname})
        
    end)

    self.client:on("creacion_jugador_cliente", function(data)
        self.gameobject.players[data.index]=molde_personaje(self,data.x,data.y,data.personaje,data.escudo,data.nombre)
    end)

    self.client:on("nuevos_destruibles", function(data)
        self.gameobject.destruible = mesh_destruible:generar_mesh(data,self.img_texturas)
    end)

    self.client:on("desconexion_player",function(data)
        if self.gameobject.players[data] then
            self.gameobject.players[data]=nil
        end
    end)

    self.client:on("remover",function(data)
        if self.gameobject.players[data] then
          self.gameobject.players[data]=nil
        end
    end)

    self.client:on("data_movil", function(data)
        local players = data.player_data
        local balas = data.balas_data
        local enemigos = data.enemigo_data

        if self.id_player then

            --print(self.gameobject.players[0],self.gameobject.players[1])

            self:recepcionar_paquete(players)
            
            --self.gameobject.players=players
            self.gameobject.balas=balas
            self.gameobject.enemigos=enemigos
        end
    end)

    self.client:on("chat_total", function(chat)
        table.insert(self.chat,chat)
        self:control_chat()
    end)
   

  	self.client:connect()

    
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
    self.client:update()
    self.world:update(dt) 
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

        local pl = self.gameobject.players[self.id_player] 

        if self.id_player and pl  then
            
            self.cam:setPosition(pl.ox,pl.oy)

            pl.rx,pl.ry=self:getXY()

            
            local datos=extra:enviar_data_jugador(pl,"rx","ry")
            
            self.client:send("datos", datos)
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

return cliente