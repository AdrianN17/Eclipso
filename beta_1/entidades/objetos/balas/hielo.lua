local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local cubo_de_hielo = require "entidades.objetos.efectos.cubo_de_hielo"

local hielo = Class {
	__includes=bala
}

function hielo:init(entidades,x,y,z,angle,creador)
	self.entidades=entidades

	self.creador=creador

	self.z=z

	self.velocidad=400


	self.name="bala-hielo"
	self.efecto="congelado"

	self.daño=30
	self.hp=50

	bala.init(self,x,y,angle,5)
end

function hielo:draw()
	self:drawing()
end

function hielo:update(dt)
	self:updating(dt)
end

function hielo:destroy()
	local efecto= cubo_de_hielo(self.entidades,self.ox,self.oy)

end

return hielo