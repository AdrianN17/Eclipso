local Class = require "libs.hump.class"

local modelo_daño = Class{}

function modelo_daño:init()
  
end

function modelo_daño:attack()
  self.hp=self.hp-(daño+daño*(self.ira/self.max_ira))

	self.ira=self.ira+daño*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end

	if self.hp<1 then
		self.estados.vivo=false
	end
  
end

function modelo_daño:efecto()
  
end

return modelo_daño