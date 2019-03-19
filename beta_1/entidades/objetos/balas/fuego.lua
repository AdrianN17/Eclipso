local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local barrera_de_fuego = require "entidades.objetos.efectos.barrera_de_fuego"

local fuego = Class {
	__includes=bala
}

function fuego:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	table.insert(self.entidades.entidad["balas"],self)

	--self.entidades:add("",)

	self.creador=creador

	self.z=z




	self.velocidad=500

	self.name="bala-fuego"
	self.efecto="quemadura"

	self.daño=50
	self.hp=65

	bala.init(self,x,y,angle,5)

end

function fuego:draw()
	--self:drawing()

end

function fuego:update(dt)
	self:updating(dt)
end

function fuego:destroy()
	--local efecto= barrera_de_fuego(self.entidades,self.ox,self.oy)
	--self.collision:add_collision_object("suelo_llamas",efecto)
end

return fuego