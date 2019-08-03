local Class= require "libs.hump.class"
local delete = require "entidades.funciones.delete"
local funciones =  require "entidades.balas.funciones_balas"

local bala_fuego=Class{
	__includes = {delete}
}

function bala_fuego:init(entidades,x,y,radio,creador,ix,iy)
	self.tipo="bala_fuego"
	
	self.entidades=entidades
	self.creador=creador

	local dano = 35
	local velocidad=3200--1800
	local area=5
	local mass=5

	self.dano=dano
	self.velocidad=velocidad
	self.radio=radio

	self.efecto= "quemadura"

	funciones:crear_cuerpo(self,x,y,area,ix,iy)
	funciones:masa_bala(self,mass)

	self.entidades:add_obj("balas",self)

	delete.init(self,"balas")
end

function bala_fuego:update(dt)
	funciones:movimiento(self,dt)
	funciones:centro_bala(self)
end

return bala_fuego