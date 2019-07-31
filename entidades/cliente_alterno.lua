local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local serverPort = 16161
local clientPort = 61616

local cliente_alterno = Class{}

function cliente_alterno:init()
	self.udp_cliente = socket.udp()

	self.udp_cliente:setsockname("0.0.0.0", clientPort)
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
				--print("client received: " .. datagram)

				self:dar_forma_data(datagram)

			end

		self.updateTick = 0
	end
end

function cliente_alterno:dar_forma_data(data)
	local data_normal = mime.unb64(data)

	local t = {}
	local regxEverythingExceptComma = '([^,]+)'

	for str in string.gmatch(data_normal, regxEverythingExceptComma) do
		 table.insert(t,str)
	end

	self:validar_data(t)
end

function cliente_alterno:validar_data(data)

	if #self.registro_server>0 then

		for _,datos in ipairs(self.registro_server) do
			if datos.ip ~= data.ip then
				table.insert(self.registro_server,data)
			end
		end
	else
		table.insert(self.registro_server,data)
	end
end


return cliente_alterno