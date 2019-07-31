local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"


local clientPort = 69999
local max_clients = 16


local cliente_alterno = Class{}

function cliente_alterno:init()
	self.udp_cliente = socket.udp()

	self.udp_cliente:setsockname("0.0.0.0", clientPort + lm.random(1,max_clients))
	self.udp_cliente:setoption('broadcast',true)
	self.udp_cliente:settimeout(0)

	self.registro_server={}

	self.updateRate = 1
	self.updateTick = 0

end

function cliente_alterno:update_alterno(dt)
	self.updateTick = self.updateTick + dt

	if self.updateTick > self.updateRate then

		local datagram, err_msg, ip_or_nil, port_or_nil

		
			datagram, msg_or_nil, port_or_nil = self.udp_cliente:receivefrom()
			if datagram then

				self:dar_forma_data(datagram)

			end

		self.updateTick = 0
	end
end

function cliente_alterno:dar_forma_data(data)
	local data_normal = mime.unb64(data)

	local t = {}
	local t_final = {}
	local regxEverythingExceptComma = '([^,]+)'

	for str in string.gmatch(data_normal, regxEverythingExceptComma) do
		 table.insert(t,str)
	end

	
	t_final.mapa = t[1]
	t_final.max_jugadores = t[2]
	t_final.can_jugadores = t[3]
	t_final.ip = t[4]

	self:validar_data(t_final)
end

function cliente_alterno:validar_data(data)

	if #self.registro_server>0 then

		for i,datos in ipairs(self.registro_server) do
			if datos.ip ~= data.ip then
				table.insert(self.registro_server,data)
			else
				self.registro_server[i].max_jugadores, self.registro_server[i].can_jugadores = data.max_jugadores , data.can_jugadores
			end
		end
	else
		table.insert(self.registro_server,data)
	end
end


return cliente_alterno