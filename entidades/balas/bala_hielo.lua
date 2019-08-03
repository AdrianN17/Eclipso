local Class= require "libs.hump.class"
local delete = require "entidades.funciones.delete"
local funciones = require "entidades.balas.funciones_balas"

local bala_hielo=Class{
	__includes = {delete}
}

function bala_hielo:init(entidades,x,y,radio,creador,ix,iy)
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

	self.efecto= "congelamiento"

	funciones:crear_cuerpo(self,x,y,area,ix,iy)
	funciones:masa_bala(self,mass)

	self.entidades:add_obj("balas",self)

	delete.init(self,"balas")
end

function bala_hielo:update(dt)
	funciones:movimiento(self,dt)
	funciones:centro_bala(self)
end

return bala_hielo