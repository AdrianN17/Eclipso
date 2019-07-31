local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local serverPort = 16161
local clientPort = 61616

local servidor_alterno = Class{}

function servidor_alterno:init(ip)
	self.broadcast_ip= self:get_broadcast(ip)

	self.udp_server = socket.udp()
	self.udp_server:setpeername("0.0.0.0", serverPort)
	
	self.udp_server:setoption('broadcast',true)

	self.udp_server:settimeout(0)

	self.ip_value = ip

	self.updateRate = 1
	self.updateTick = 0
end

function servidor_alterno:update_alterno(dt)

	self.updateTick = self.updateTick + dt

	if self.updateTick > self.updateRate then

		local datos = self.datos_servidor.mapa .. "," .. self.datos_servidor.max_jugadores .. "," .. self.server:getClientCount() .. "," .. self.ip_value
	   	local data_encode = mime.b64(datos)

		self.udp_server:sendto(data_encode, self.broadcast_ip, clientPort)

		self.updateTick = 0
	end
end

function servidor_alterno:get_broadcast(ip_text)
	local t = {}

	local regxEverythingExceptComma = '([^.]+)'

	for str in string.gmatch(ip_text, regxEverythingExceptComma) do
		 table.insert(t,str)
	end

	t[4] = 255

	local ip = t[1] .. "." .. t[2] .. "." .. t[3] .. "." .. t[4]

	return ip
end

return servidor_alterno