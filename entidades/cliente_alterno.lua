local Class= require "libs.hump.class"
local socket = require "socket"
local mime = require "mime"

local cliente_alterno = Class{}

function cliente_alterno:init()
	self.udp_cliente = socket.udp()
	self.udp_cliente:setpeername("localhost", "22121")
	self.udp_cliente:settimeout(0)

	self.registro_server={}


end

function cliente_alterno:update_alterno(dt)
	self.udp_cliente:send("Unirse")
	data = self.udp_cliente:receive()
	if data then
	    local data_normal = mime.unb64(data)

	    local t = {}
	    local regxEverythingExceptComma = '([^,]+)'
		for str in string.gmatch(data_normal, regxEverythingExceptComma) do
   		 	table.insert(t,str)
		end

		self:validar_data(t)
	end
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