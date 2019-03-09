local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local cubo_de_hielo = require "entidades.objetos.efectos.cubo_de_hielo"

local hielo = Class {
	__includes=bala
}

function hielo:init(entidad,x,y,z,angle,creador)
	self.entidad=entidad

	self.creador=creador

	self.x,self.y,self.z,self.angle=x,y,z,angle
	self.collider=entidad.collider:circle(x,y,5)

	self.velocidad=400

	self.ox,self.oy=self.collider:center()

	self.name="bala-hielo"
	self.efecto="congelado"

	self.daño=30
	self.hp=50

	bala.init(self)
end

function hielo:draw()
	self:drawing()
end

function hielo:update(dt)
	self:updating(dt)
end

function hielo:destroy()
	local efecto= cubo_de_hielo(self.entidad,self.ox,self.oy)
	self.collision:add_collision_object("barrera_hielo",efecto)
end

return hielo