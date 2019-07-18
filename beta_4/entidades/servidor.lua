local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

local entidad_servidor = require "entidades.entidad_servidor"

local servidor = Class{
	__includes={entidad_servidor}
}

function servidor:init()
	
end

function servidor:enter(gamestate,nickname,max_jugadores,max_enemigos,personaje,mapas)


	self.mapa_files=require ("entidades.mapas." .. mapas)

	--informacion de servidor
	self.tickRate = 1/60
  	self.tick = 0
  
  	self.server = Sock.newServer("192.168.0.3","22122",max_jugadores)
  	self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()

	--creacion de servidor

	entidad_servidor.init(self)


end

function servidor:draw()

end

function servidor:update(dt)

end

function servidor:keypressed(key)
	
end

function servidor:keyreleased(key)
	
end

function servidor:mousepressed(x,y,button)
	
end

function servidor:mousereleased(x,y,button)
	
end

function servidor:quit()
	self.server:destroy()
end

return servidor