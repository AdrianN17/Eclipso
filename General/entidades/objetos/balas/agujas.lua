local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"

local aguja=Class{
	__includes=bala
}

function aguja:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,2.5)

	self.velocidad=900

	self.ox,self.oy=self.collider:center()

	self.name="bala-aguja"

	self.daño=25
	self.hp=25

	bala.init(self)
end

function aguja:draw()
	self:drawing()
end

function aguja:update(dt)
	self:updating(dt)
end

return aguja