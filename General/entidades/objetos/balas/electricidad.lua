local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local campo_electrico = require "entidades.objetos.efectos.campo_electrico"


local electricidad = Class {
	__includes=bala
}

function electricidad:init(entidad,x,y,z,angle,creador)

	self.entidad=entidad

	self.creador=creador


	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,5)

	self.velocidad=700

	self.ox,self.oy=self.collider:center()

	self.name="bala-electricidad"
	self.efecto="paralisis"

	self.daño=25

	bala.init(self)

end

function electricidad:draw()
	self:drawing()
end

function electricidad:update(dt)
	self:updating(dt)
end

function electricidad:destroy()
	local efecto= campo_electrico(self.entidad,self.ox,self.oy)
	self.collision:add_collision_object("campo_electrico",efecto)
end

return electricidad