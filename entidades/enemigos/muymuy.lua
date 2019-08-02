local Class= require "libs.hump.class"
local delete = require "entidades.funciones.delete"
local bala_pulso = require "entidades.balas.bala_pulso"
local funcion = require "entidades.enemigos.funciones_enemigos"

local machine = require "libs.statemachine.statemachine"

local muymuy = Class{
	__includes = {delete}
}

function muymuy:init(entidades,x,y)

	self.tipo="muymuy"
  self.clase="enemigos_marinos"

	self.entidades=entidades
	self.creador=entidades.enemigos_id_creador

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,
	dash=false,vivo=true,recargando=false,atacando_melee=false}

	local poligono={-1 , -68,
31 , -32,
26 , 20,
-1 , 50,
-28 , 20,
-32 , -32}

  local hp=200
  local velocidad=380
  local ira=100
  local mass=50
  local puntos_arma={{x=0,y=-75}}
  local puntos_melee=nil
  local puntos_rango={x=0,y=-100,r=100}
  local max_acercamiento=60
  local max_acercamiento_real = max_acercamiento*3
  local objeto_balas={{bala=bala_pulso,tiempo=0.5,max_stock=7,stock=7,tiempo_recarga=1}}
  local tiempo_max_recarga=1.5
  local dano_melee=0

  funcion:crear_cuerpo(self,x,y,poligono)
  funcion:crear_brazos(self,puntos_arma)
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

  self.brazo_actual=1
  self.tiempo_balas=0
  self.tiempo_recarga=0

  self.tiempo_rastreo=0
  self.max_tiempo_rastreo=1
  self.estas_rastreando=true

  self.max_acercamiento_real=max_acercamiento_real

  self.presas={}
  self.semi_presa={x=nil,y=nil}

  self.entidades:add_obj("enemigos",self)

  delete.init(self,"enemigos")

  self.fsm=machine.create({
  	initial="rastreo",
  	events = {
  		{ name = "atacando" , from = {"rastreo","alerta"} , to = "ataca" },
  		{ name = "alertado" , from = "rastreo" , to = "alerta" },
  		{ name = "rastreando" , from = {"ataca","alerta"} , to = "rastreo" }
	}
  })

end

function muymuy:draw()
	funcion:dibujar_enemigo(self)
end

function muymuy:update(dt)

	funcion:actualizar_raycast(self,dt)



	if self.fsm.current == "rastreo" then
		funcion:realizar_rastreo(self,dt)
	elseif self.fsm.current == "alerta" then
		funcion:funcion_realizar_busqueda(self,dt,self.fsm.current)
		funcion:modulo_disparo(self,dt)
	elseif self.fsm.current == "ataca" then
		funcion:funcion_realizar_busqueda(self,dt,self.fsm.current)
		funcion:modulo_disparo(self,dt)
	end
	
	funcion:coger_centro(self)

	funcion:muerte(self)
end

function muymuy:validar_estado_bala(bala_obj)
	funcion:validacion_de_accion_bala(self,bala_obj)
end

function muymuy:nueva_presas(personaje_obj)
  funcion:nueva_presa(self,personaje_obj)
end

function muymuy:eliminar_presas(personaje_obj)
  funcion:eliminar_presa(self,personaje_obj)
end

function muymuy:pack()
    return funciones:empaquetado_1(self)
end


return muymuy