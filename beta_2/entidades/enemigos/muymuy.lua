local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"
local bala_enemigo= require "entidades.objetos.balas.electricidad"
local bullet_control = require "libs.Bullets.bullet_control"

local muymuy = Class{
	__includes=Molde
}

function muymuy:init(entidades,x,y)
	self.entidades=entidades

	self.creador=10

	self.hp=200

	self.velocidad=100

	self.max_ira=100

	self.tiempo_seguir=2

	self.tiempo_disparo=0.5

	self.recargando=false

	self.stock=10
	self.municion=10
	self.tiempo_recarga=0.5

	Molde.init(self,x,y,30,60,bala_enemigo,bullet_control)

	

	self:reset_mass(20)



end

function muymuy:draw()
	self:drawing()
end

function muymuy:update(dt)
	self:updating(dt)
end

return muymuy