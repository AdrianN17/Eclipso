local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local explosion_plasma = require "entidades.objetos.efectos.explosion_plasma"

local plasma= Class{
	__includes=bala
}

function plasma:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	self.creador=creador

	self.z=z
	

	self.velocidad=600

	self.name="bala-plasma"

	self.daño=70
	self.hp=75

	bala.init(self,x,y,angle,5)
end

function plasma:draw()
	self:drawing()
end

function plasma:update(dt)
	self:updating(dt)
end

function plasma:destroy()
	local efecto= explosion_plasma(self.entidades,self.ox,self.oy)
end


return plasma