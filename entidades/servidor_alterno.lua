local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local servidor_alterno = Class{}

function servidor_alterno:init(ip)
	self.udp_server = socket.udp()
	self.udp_server:setsockname("*", "22121")
	self.udp_server:settimeout(0)

	self.ip_value = ip

end

function servidor_alterno:update_alterno(dt)
	data, ip, port = self.udp_server:receivefrom()
    if data == "Unirse" then


	   local datos = self.datos_servidor.mapa .. "," .. self.datos_servidor.max_jugadores .. "," .. self.server:getClientCount() .. "," .. self.ip_value

	   local data_encode = mime.b64(datos)



        self.udp_server:sendto(data_encode, ip, port)
    end
end

return servidor_alterno