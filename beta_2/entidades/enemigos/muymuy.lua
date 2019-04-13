local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"

local muymuy = Class{
	__includes=Molde
}

function muymuy:init(entidades,x,y)
	self.entidades=entidades

	self.creador=100

	self.hp=200

	self.velocidad=100

	self.max_ira=100

	self.tiempo_seguir=2

	Molde.init(self,x,y,30,60)

	self:reset_mass(20)

end

function muymuy:draw()
	self:drawing()
end

function muymuy:update(dt)
	self:updating(dt)
end

return muymuy