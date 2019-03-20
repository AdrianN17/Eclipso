local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Personajes = require "gamestates.personajes"

local escenarios= Class{}


function escenarios:init()
	_G.detalles.type="Servidor"
	_G.detalles.ip="*"
	self.x,self.y=lg.getDimensions( )
end

function escenarios:draw()
	lg.print("Escenarios" , 10,10 )
end

function escenarios:update(dt)

end

function escenarios:mousepressed(x,y,button)
	Gamestate.switch(Personajes)
end

function escenarios:touchpressed(id, x, y, dx, dy, pressure)
	Gamestate.switch(Personajes)
end


return escenarios