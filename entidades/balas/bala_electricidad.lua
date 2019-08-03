local Class= require "libs.hump.class"
local delete = require "entidades.funciones.delete"
local funciones =  require "entidades.balas.funciones_balas"

local bala_electricidad=Class{
	__includes = {delete}
}

function bala_electricidad:init(entidades,x,y,radio,creador,ix,iy)
	self.tipo="bala_electricidad"
	
	self.entidades=entidades
	self.creador=creador

	local dano = 25
	local velocidad=3500--2000
	local area=5
	local mass=5

	self.dano=dano
	self.velocidad=velocidad
	self.radio=radio

	self.efecto= "paralisis"

	funciones:crear_cuerpo(self,x,y,area,ix,iy)
	funciones:masa_bala(self,mass)

	self.entidades:add_obj("balas",self)

	delete.init(self,"balas")
end

function bala_electricidad:update(dt)
	funciones:movimiento(self,dt)
	funciones:centro_bala(self)
end

return bala_electricidad