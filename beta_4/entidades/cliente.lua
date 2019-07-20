local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local extra = require "entidades.funciones.extra"

local entidad_cliente = require "entidades.entidad_cliente"

local cliente = Class{
    __includes={entidad_cliente}
}

function cliente:init()
	
end

function cliente:enter(gamestate,nickname,personaje,ip)

    self.id_player=nil

    local x,y=lg.getDimensions( )

    self.cam = gamera.new(0,0,1000,1000)
    self.cam:setWindow(0,0,x,y)

    self.map=nil

	self.tickRate = 1/60
  	self.tick = 0



	self.client = Sock.newClient("192.168.0.3", 22122)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
  	self.client:enableCompression()

    entidad_cliente.init(self)


  
  
  	self.client:setSchema("jugadores", {
        "player_data"
        --"balas_data",
        --"enemigos_data",
       -- "objetos_data",
       -- "arboles_data"
    })

    self.client:on("player_init_data", function(data)
        self.id_player=data.id  
      
        
        
        self:crear_mapa(data.mapa)
        
        self.client:send("informacion_primaria", {personaje=personaje,nickname=nickname})
        
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

    self.client:on("jugadores", function(data)
        local players = data.player_data
        --local balas = data.balas_data
        --local enemigos = data.enemigos_data
        --local objetos = data.objetos_data
        --local arboles = data.arboles_data

        if self.id_player then

            self.gameobject.players=players
            --self.enemigos=enemigos
            --self.balas=balas
            --self.objetos=objetos
            --self.arboles=arboles
            
        end
    end)
   

  	self.client:connect()

    
end

function cliente:draw()
    self:draw_entidad()

    lg.print(self.client:getState(), 5, 70)
    lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)
    lg.print("Numero :" .. tostring(self.id_player) ,20,30)
    
    lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function cliente:update(dt)
    self.client:update()
  
    self:update_entidad(dt)
  
    if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0

        local pl = self.gameobject.players[self.id_player] 

        if self.id_player and pl  then
            
            self.cam:setPosition(pl.ox,pl.oy)

            pl.rx,pl.ry=self:getXY()

            
            local datos=extra:enviar_data_jugador(pl,"rx","ry")
            
            self.client:send("datos", datos)
        end
    end
end


return cliente