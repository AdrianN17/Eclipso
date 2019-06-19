local Class = require "libs.hump.class"

local modelo_dano = Class{}

function modelo_dano:init()
  
end

function modelo_dano:attack()
  self.hp=self.hp-(dano+dano*(self.ira/self.max_ira))

	self.ira=self.ira+dano*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end

	if self.hp<1 then
		self.estados.vivo=false
	end
  
end

function modelo_dano:efecto()
  
end

return modelo_dano