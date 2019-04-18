local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"
local bala_enemigo= require "entidades.objetos.balas.plasma"
local bullet_control = require "libs.Bullets.bullet_control"


local cangrejos = Class{
	__includes=Molde
}

function cangrejos:init(entidades,x,y)
	self.entidades=entidades

	self.creador=10

	self.hp=500

	self.velocidad=350

	self.max_ira=200

	self.tiempo_seguir=1.5

	self.tiempo_disparo=0.75

	self.recargando=false

	self.stock=3
	self.municion=3
	self.tiempo_recarga=1

	self.points_data={
		{x=0, y=0}
	}

	self.melee_points={
		{x=-25,y=30,r=20},
		{x=25,y=30,r=20}
	}

	self.max_distancia=10

	self.melee_attack=85

	Molde.init(self,x,y,60,40,bala_enemigo,bullet_control,200)

	

	self:reset_mass(30)
end

function cangrejos:draw()
	self:drawing()
end

function cangrejos:update(dt)
	self:updating(dt)
end

return cangrejos