local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local semilla=Class{
	__includes=bala
}

function semilla:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	self.creador=creador

	self.z=z

	self.velocidad=750


	self.name="bala-semilla"

	self.daño=10
	self.hp=15

	bala.init(self,x,y,angle,2.5)
end

function semilla:draw()
	self:drawing()
end

function semilla:update(dt)
	self:updating(dt)
end

return semilla