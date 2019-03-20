local Class = require "libs.hump.class"
local bala = require "entidades.objetos.balas.bala"
local campo_electrico = require "entidades.objetos.efectos.campo_electrico"


local electricidad = Class {
	__includes=bala
}

function electricidad:init(entidades,x,y,z,angle,creador)

	self.entidades=entidades

	self.creador=creador


	self.z=z

	self.velocidad=700


	self.name="bala-electricidad"
	self.efecto="paralisis"

	self.daño=25
	self.hp=55

	bala.init(self,x,y,angle,5)

end

function electricidad:draw()
	self:drawing()
end

function electricidad:update(dt)
	self:updating(dt)
end

function electricidad:destroy()
	local efecto= campo_electrico(self.entidades,self.ox,self.oy)

end

return electricidad