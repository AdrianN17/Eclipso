local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local extras = require "self_libs.extras"

local servidor = Class{}

function servidor:init(ip,puerto,nombre)
  self.tickRate = 1/60
  self.tick = 0
  
  self.server = Sock.newServer(ip,puerto,4)
  self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()
  
  self.server:on("connect", function(data, client)
		local index=client:getIndex()
        client:send("player_id", index+1)
        --table.insert(self.gameobject.players, personajes[data](self,100,100,index+1))
        self.gameobject.players[index+1] = self.personajes[data](self,100,100,index+1)
        
    end)


    self.server:on("disconnect", function(data, client)
    	local index =client:getIndex()

    	if self.gameobject.players[index+1] then

	    	self.gameobject.players[index+1]:remove()
	    	--table.remove(self.gameobject.players,index+1)
	    	self.gameobject.players[index+1]=nil

	    end

    	self.server:sendToAll("desconexion_player", (index+1))
    end)


    self.server:on("datos", function(datos, client)
        local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	recibir_data_jugador(datos,pl)
        end
    end)

    --callbacks

    self.server:on("mouse_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:mousepressed(datos.x,datos.y,datos.button)
        end
    end)

    self.server:on("mouse_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:mousereleased(datos.x,datos.y,datos.button)
        end
    end)

    self.server:on("key_pressed" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

        if pl then
        	pl:keypressed(datos.key)
        end
    end)

    self.server:on("key_released" , function(datos, client)
    	local index = client:getIndex()
        local pl=self.gameobject.players[index+1]

         if pl then
        	pl:keyreleased(datos.key)
        end
    end)
end

function servidor:update_server(dt)
  self.server:update(dt)
	self.map:update(dt)
	self.world:update(dt)
  
  self.tick = self.tick + dt

	if self.tick >= self.tickRate then
        self.tick = 0
        
    for i, obj in pairs(self.gameobject) do
      for _, obj2 in pairs(obj) do
        if obj2 then
          obj2:update(dt)
        end
      end
    end
    
    --camara-muerte del usuario
    if self.gameobject.players[1] then
			self.cam:setPosition(self.gameobject.players[1].ox,self.gameobject.players[1].oy)
    
      self.gameobject.players[1].rx,self.gameobject.players[1].ry=self:getXY()
		else

		end


    for i, player in pairs(self.gameobject.players) do
      if player then
        --enviar
        
        local player_data=enviar_data_jugador(player,"ox","oy","radio","hp","ira","tipo_indice","iterator","iterator_2")
        
        local balas_data,enemigos_data,objetos_data,arboles_data=extra_data(self,player.cam_x,player.cam_y,player.cam_w,player.cam_h)

          self.server:sendToAll("jugadores", {i,player_data,balas_data,enemigos_data,objetos_data,arboles_data})
          --las balas deben ir aca para limitarla segun su camara
      end
    end
    
    
  end
end

function servidor:servidor_draw()
  lg.print("Jugadores : " .. (self.server:getClientCount()+1) ,10,30)
  
  
end

function servidor:quit()
    self.server:destroy()
end


return servidor