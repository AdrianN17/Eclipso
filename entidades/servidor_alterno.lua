local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local serverPort = 16161
local clientPort = 61616

local servidor_alterno = Class{}

function servidor_alterno:init(ip)
	self.udp_server = socket.udp()
	self.udp_server:setsockname("0.0.0.0", serverPort)
	
	self.udp_server:setoption('broadcast',true)

	self.ip_value = ip

	self.updateRate = 0.5
	self.updateTick = 0

end

function servidor_alterno:update_alterno(dt)

	self.updateTick = self.updateTick + dt

	if self.updateTick > self.updateRate then

		local datos = self.datos_servidor.mapa .. "," .. self.datos_servidor.max_jugadores .. "," .. self.server:getClientCount() .. "," .. self.ip_value
	   	local data_encode = mime.b64(datos)

		self.udp_server:sendto(data_encode, "192.168.0.255", clientPort)

		self.updateTick = 0
	end
end

return servidor_alterno