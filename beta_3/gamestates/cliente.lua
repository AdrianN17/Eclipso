local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

local cliente = Class{}

function cliente:init()
  
  self.tickRate = 1/60
  self.tick = 0

	self.client = sock.newClient(self.ip, self.port)
	self.client:setSerialization(bitser.dumps, bitser.loads)

	
  self.client:enableCompression()
  
  
  
end


return cliente