local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local serverPort = 59999
local clientPort = 69999
local max_clients = 16
local max_servers = 201


local servidor_alterno = Class{}

function servidor_alterno:init(ip)
	self.broadcast_ip= self:get_broadcast(ip)

	local ok = nil
	local contador= 5

	repeat 
		self.udp_server = socket.udp()
		self.udp_server:setsockname("0.0.0.0", serverPort + lm.random(200,max_servers) )
		ok = self.udp_server:getsockname()
		contador=contador+1
	until ok or contador > 5 
	
	self.udp_server:setoption('broadcast',true)

	self.udp_server:settimeout(0)

	self.ip_value = ip

	self.updateRate = 3
	self.updateTick = 0
end

function servidor_alterno:update_alterno(dt)

	self.updateTick = self.updateTick + dt

	if self.updateTick > self.updateRate then

		local datos = self.datos_servidor.mapa .. "," .. self.datos_servidor.max_jugadores+1 .. "," .. self.server:getClientCount()+1 .. "," .. self.ip_value .. "," .. tostring(self.estado_partida.current)

	   	local data_encode = mime.b64(datos)

	   	for i = 1, max_clients do
			self.udp_server:sendto(data_encode, self.broadcast_ip, clientPort+i)
		end

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