local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local ectoplasma = Class{
	__includes=bala
}

function ectoplasma:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,5)

	self.velocidad=900

	self.ox,self.oy=self.collider:center()

	self.name="bala-ectoplasma"
	--self.efecto="ectoplasma"

	self.daño=15

	bala.init(self)
end

function ectoplasma:draw()
	self:drawing()
end

function ectoplasma:update(dt)
	self:updating(dt)
end

return ectoplasma