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
  local puntos_rango={x=0,y=-175,r=150,max_acercamiento=60}
  local objeto_balas={{bala=bala_pulso,tiempo=0.5,max_stock=7,stock=7,tiempo_recarga=1}}
  local tiempo_max_recarga=1.5
  local rastreo_paredes=130
  local dano_melee=0

  funcion:crear_cuerpo(self,x,y,poligono)
  funcion:crear_brazos(self,puntos_arma)
  funcion:crear_vision(self,puntos_rango)

  funcion:masa_personaje(self,mass)

  self.balas=objeto_balas

  self.hp=hp 
  self.ira=0
  self.max_ira=ira

  self.velocidad=velocidad
  self.radio=0

  self.spritesheet=self.entidades.img_enemigos.enemigos_marinos

  self.iterator=1
  self.timer_1=0
  self.max_iterator=1

  self.brazo_actual=1
  self.tiempo_balas=0
  self.tiempo_recarga=0

  self.presas={}
  self.semi_presa={}

  self.entidades:add_obj("enemigos",self)

  delete.init(self,"balas")

  self.fsm=machine.create({
  	initial="rastreo",
  	events = {
  		{ name = "atacando" , from = "rastreo" , to = "ataca" },
  		{ name = "rastreando" , from = "ataca" , to = "rastreo" }
	}
  })

end

function muymuy:draw()
	funcion:dibujar_enemigo(self)
end

function muymuy:update(dt)

	if self.fsm.current == "rastreo" then

		

	elseif self.fsm.current == "ataca" then

		--busqueda_cercano
		if not self.estados.recargando then
			funcion:realizar_disparo(self,dt)
		else
			funcion:recargar(self,dt)
		end
	end
	
	funcion:coger_centro(self)

	funcion:muerte(self)
end

return muymuy