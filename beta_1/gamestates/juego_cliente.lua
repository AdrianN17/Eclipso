local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"

local juego_cliente=Class{}

function juego_cliente:init()
	self.eleccion_personaje=_G.detalles.personaje
	self.ip=_G.detalles.ip
	self.port=_G.detalles.port

end

function juego_cliente:draw()

end

function juego_cliente:update()

end

function juego_cliente:keypressed(key)
	
end

function juego_cliente:keyreleased(key)
	
end

function juego_cliente:mousepressed(x,y,button)

end

function juego_cliente:mousereleased(x,y,button)

end

function juego_cliente:touchpressed(id,x,y,dx,dy,pressure)

end

function juego_cliente:touchreleased(id,x,y,dx,dy,pressure)

end

function juego_cliente:wheelmoved(x,y)

end

return juego_cliente