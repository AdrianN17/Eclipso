local Class = require "libs.hump.class"
local machine = require "libs.statemachine.statemachine"

local efectos = Class{}

function efectos:init()
	self.max_velocidad=self.velocidad
	self.min_velocidad=self.velocidad/3

	self.efecto_tenidos=machine.create({
		initial="ninguno",
		events = {
			{ name = "esquemado" , from = "ninguno" , to = "quemado"},
			{ name = "escongelado" , from = "ninguno" , to = "congelado"},
			{ name = "eselectrocutado" , from = "ninguno" , to = "electrocutado"},
			{ name = "normalidad" , from ={"quemado","congelado","electrocutado"}, to = "ninguno"}
		}
	})

	self.fuego_dano=5

	self.tiempo_efectos=0
	self.max_tiempo_efectos={
		quemado = 3, congelado = 3, electrocutado = 5
	}
end

function efectos:update_efecto(dt)

	local current = self.efecto_tenidos.current
	

	if current =="ninguno" then
		

		
	else
		self.tiempo_efectos=self.tiempo_efectos+dt


		if current =="electrocutado" then
			self.velocidad=self.min_velocidad
		elseif current =="quemado" then
			self.hp=self.hp-self.fuego_dano*dt
		end

		if self.tiempo_efectos>self.max_tiempo_efectos[current] then
			self.velocidad=self.max_velocidad
			self.efecto_tenidos:normalidad()
			self.tiempo_efectos=0
		end
	end
end

return efectos