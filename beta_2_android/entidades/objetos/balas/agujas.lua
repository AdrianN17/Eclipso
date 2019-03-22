local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local aguja=Class{
	__includes=bala
}

function aguja:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	self.creador=creador

	self.z=z

	self.velocidad=900

	self.name="bala-aguja"

	self.daño=25
	self.hp=25

	bala.init(self,x,y,angle,2.5)
end

function aguja:draw()
	self:drawing()
end

function aguja:update(dt)
	self:updating(dt)
end

return aguja