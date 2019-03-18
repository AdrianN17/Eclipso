local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local semilla=Class{
	__includes=bala
}

function semilla:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,2.5)

	self.velocidad=750

	self.ox,self.oy=self.collider:center()

	self.name="bala-semilla"

	self.daño=10
	self.hp=15

	bala.init(self)
end

function semilla:draw()
	self:drawing()
end

function semilla:update(dt)
	self:updating(dt)
end

return semilla