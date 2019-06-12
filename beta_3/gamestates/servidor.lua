local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

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
        self.gameobject.players[index+1] = personajes[data](self,100,100,index+1)
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

function servidor:quit()
    self.server:destroy()
end


return servidor