local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local extras = require "self_libs.extras"

local cliente = Class{}

function cliente:init(ip,puerto,nombre,eleccion)

  self.tickRate = 1/60
  self.tick = 0

	self.client = Sock.newClient(ip, port)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
  self.client:enableCompression()
  
  
  self.client:setSchema("jugadores", {
        "player_data",
        "balas_data",
        "enemigos_data",
        "objetos_data",
        "arboles_data"
    })

    self.client:on("player_init_data", function(data)
        self.id_player=data.id  
      
        
        
        self:create_map(data.mapa)
        
        self.client:send("informacion_primaria", {eleccion=eleccion,nombre=nombre})
        
    end)

    self.client:on("desconexion_player",function(data)
        if self.players[data] then
             self.players[data]=nil
        end
    end)

    self.client:on("remover",function(data)
        if self.players[data] then
          self.players[data]=nil
        end
    end)

    self.client:on("jugadores", function(data)
        local players = data.player_data
        local balas = data.balas_data
        local enemigos = data.enemigos_data
        local objetos = data.objetos_data
        local arboles = data.arboles_data

        if self.id_player then

            self.players=players
            self.enemigos=enemigos
            self.balas=balas
            self.objetos=objetos
            self.arboles=arboles
            
        end
    end)
  
  self.client:connect()
  
  self.spritesheet=img
end

function cliente:client_update(dt)
  self.client:update()
  
  if self.map then
    self.map:update(dt)
  end
  
  if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0

        if self.id_player and self.players[self.id_player] then
            local pl=self.players[self.id_player]
            
            
            self.cam:setPosition(pl.ox,pl.oy)

            pl.rx,pl.ry=self:getXY()
            
            local datos=enviar_data_jugador(pl,"rx","ry")
            
            self.client:send("datos", datos)
        end
    end
end

function cliente:client_draw()
  local cx,cy,cw,ch=self.cam:getVisible()
  
  if self.map then
    self.map:draw(-cx,-cy,1,1)
  end
  
  lg.print(self.client:getState(), 5, 70)
  lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)
  lg.print("Numero :" .. tostring(self.id_player) .. " , "  .. tostring(self.players[self.id_player]),20,30)
  lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  lg.print("Cantidad array " ..#self.players,50,50)
end

function cliente:keypressed(key)
	 if self.client:getState() == "connected" and self.id_player  then
        if key=="escape" then
             self.client:disconnect()
        else
             local pl=self.players[self.id_player]

             self.client:send("key_pressed", {key=key})
        end
    end
end

function cliente:keyreleased(key)
	if self.client:getState() == "connected" and self.id_player  then
        local pl=self.players[self.id_player]

        self.client:send("key_released", {key=key})
    end
end

function cliente:mousepressed(x,y,button)
     if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_pressed", {x=cx,y=cy,button=button})
    end
end

function cliente:mousereleased(x,y,button)
    if self.client:getState() == "connected" and self.id_player then
        local cx,cy=self.cam:toWorld(x,y)
        self.client:send("mouse_released", {x=cx,y=cy,button=button})
    end
end

function cliente:quit()
    self.client:disconnect()
end


return cliente