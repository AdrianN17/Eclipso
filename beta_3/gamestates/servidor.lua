local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

local servidor = Class{}

function servidor:init()
  self.tickRate = 1/60
  self.tick = 0
  
  self.server = Sock.newServer("*","22122",4)
  self.server:setSerialization(bitser.dumps, bitser.loads)

	self.server:enableCompression()
  
  
  
end


return servidor