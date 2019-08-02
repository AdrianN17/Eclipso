local Class= require "libs.hump.class"
local delete = require "entidades.funciones.delete"
local funcion = require "entidades.enemigos.funciones_enemigos"
local machine = require "libs.statemachine.statemachine"
local efectos = require "entidades.funciones.efectos"

local cangrejo = Class{
	__includes = {delete,efectos}
}

function cangrejo:init(entidades,x,y)
	self.tipo="cangrejo"
	self.clase="enemigos_marinos"

	self.entidades=entidades
	self.creador=entidades.enemigos_id_creador

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,
	dash=false,vivo=true,recargando=false,atacando_melee=false}

	local poligono={-65 , 12,
-25 , 56,
26 , 56,
66 , 15,
42 , -16,
-46 , -14}

	local hp=500
	local velocidad=650
	local ira=200
	local mass=85
	local puntos_arma=nil
	local puntos_rango={x=0,y=-100,r=120}
	local puntos_melee={{x=-30,y=-50,r=30},{x=30,y=-50,r=30}}
	local max_acercamiento=30
	local max_acercamiento_real = max_acercamiento*3
	local tiempo_max_recarga=0
	local dano_melee=50

	self.dano_melee=dano_melee

	funcion:crear_cuerpo(self,x,y,poligono)
	funcion:crear_melee(self,puntos_melee)
	funcion:crear_vision(self,puntos_rango)
	funcion:crear_raycast(self,max_acercamiento_real,puntos_rango.r)

	funcion:masa_personaje(self,mass)

	self.balas=objeto_balas

	self.hp=hp 
	self.ira=0
	self.max_ira=ira

	self.velocidad=velocidad

	self.spritesheet=self.entidades.img_enemigos.enemigos_marinos

	self.iterator=1
	self.timer_1=0
	self.max_iterator=1

	self.tiempo_rastreo=0
	self.max_tiempo_rastreo=1
	self.estas_rastreando=true

	self.max_acercamiento_real=max_acercamiento_real

	self.presas={}
	self.semi_presa={x=nil,y=nil}

	self.entidades:add_obj("enemigos",self)

	delete.init(self,"enemigos")
	efectos.init(self)

	self.fsm=machine.create({
		initial="rastreo",
		events = {
			{ name = "atacando" , from = {"rastreo","alerta"} , to = "ataca" },
			{ name = "alertado" , from = "rastreo" , to = "alerta" },
			{ name = "rastreando" , from = {"ataca","alerta"} , to = "rastreo" }
	}
	})
end

function cangrejo:draw()
	funcion:dibujar_enemigo(self)
end

function cangrejo:update(dt)
	self:update_efecto(dt)
	funcion:actualizar_raycast(self,dt)

	if self.efecto_tenidos.current ~="congelado" then
		if self.fsm.current == "rastreo" then
			funcion:realizar_rastreo(self,dt)
		elseif self.fsm.current == "alerta" then
			funcion:funcion_realizar_busqueda(self,dt,self.fsm.current)
			
		elseif self.fsm.current == "ataca" then
			funcion:funcion_realizar_busqueda(self,dt,self.fsm.current)

		end
	end
	
	funcion:coger_centro(self)

	funcion:muerte(self)

	
end

function cangrejo:validar_estado_bala(bala_obj)
	funcion:validacion_de_accion_bala(self,bala_obj)
end

function cangrejo:nueva_presas(personaje_obj)
  funcion:nueva_presa(self,personaje_obj)
end

function cangrejo:eliminar_presas(personaje_obj)
  funcion:eliminar_presa(self,personaje_obj)
end

function cangrejo:pack()
    return funciones:empaquetado_1(self)
end

return cangrejo