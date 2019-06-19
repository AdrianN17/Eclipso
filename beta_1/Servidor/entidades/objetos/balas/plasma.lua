local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local explosion_plasma = require "entidades.objetos.efectos.explosion_plasma"

local plasma= Class{
	__includes=bala
}

function plasma:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,5)

	self.velocidad=600

	self.ox,self.oy=self.collider:center()

	self.name="bala-plasma"

	self.daño=70
	self.hp=75

	bala.init(self)
end

function plasma:draw()
	self:drawing()
end

function plasma:update(dt)
	self:updating(dt)
end

function plasma:destroy()
	local efecto= explosion_plasma(self.entidad,self.ox,self.oy)
	self.collision:add_collision_object("explosion_plasma",efecto)
end


return plasma