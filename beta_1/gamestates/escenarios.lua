local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Personajes = require "gamestates.personajes"

local socket = require("socket")

local escenarios= Class{}




function escenarios:init()

	--get my ip
	_G.detalles.type="Servidor"


	local s = socket.udp()
	s:setpeername("74.125.115.104",80)
	local ip_main, _ = s:getsockname()

	_G.detalles.ip=ip_main

	
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