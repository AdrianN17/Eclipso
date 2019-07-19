local Class= require "libs.hump.class"

local funciones = require "entidades.balas.funciones_balas"

local bala_hielo=Class{}

function bala_hielo:init(entidades,x,y,radio,creador)
	self.tipo="bala_hielo"

	self.entidades=entidades
	self.creador=creador

	local dano = 45
	local velocidad=3000--1500
	local area=5
	local mass=5

	self.dano=dano
	self.velocidad=velocidad
	self.radio=radio

	self.spritesheet=self.entidades.img_balas

	funciones:crear_cuerpo(self,x,y,area)
	funciones:masa_bala(self,mass)

	self.entidades:add_obj("balas",self)
end

function bala_hielo:draw()
	funciones:dibujar_bala(self)
end

function bala_hielo:update(dt)
	funciones:movimiento(self,dt)
	funciones:centro_bala(self)
end

return bala_hielo