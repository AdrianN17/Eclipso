local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local barrera_de_fuego = require "entidades.objetos.efectos.barrera_de_fuego"

local fuego = Class {
	__includes=bala
}

function fuego:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,5)

	self.velocidad=500

	self.ox,self.oy=self.collider:center()

	self.name="bala-fuego"
	self.efecto="quemadura"

	self.daño=50

	bala.init(self)
end

function fuego:draw()
	self:drawing()
end

function fuego:update(dt)
	self:updating(dt)
end

function fuego:destroy()
	local efecto= barrera_de_fuego(self.entidad,self.ox,self.oy)
	self.collision:add_collision_object("suelo_llamas",efecto)
end

return fuego