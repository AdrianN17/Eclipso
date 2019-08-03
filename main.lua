Gamestate = require "libs.hump.gamestate"
Servidor = require "entidades.servidor"
local socket = require "socket"

function love.load()
	
	
	_G.lg=love.graphics
	_G.lm=love.math
	--_G.font = font
	_G.py=love.physics

  	Gamestate.registerEvents()
  	Gamestate.switch(Servidor,8,25,"acuaris","localhost")

end

function getIP()
  local s = socket.udp()
  s:setpeername("74.125.115.104",80)
  local ip, _ = s:getsockname()
  s:close()

  return ip
end

--enviar imagenes de personajes del servidor al cliente

--colocar contraseña