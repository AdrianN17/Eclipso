local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local ectoplasma = Class{
	__includes=bala
}

function ectoplasma:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	self.creador=creador

	self.z=z

	self.velocidad=900

	self.name="bala-ectoplasma"
	--self.efecto="ectoplasma"

	self.daño=15
	self.hp=40

	bala.init(self,x,y,angle,5)
end

function ectoplasma:draw()
	self:drawing()
end

function ectoplasma:update(dt)
	self:updating(dt)
end

return ectoplasma