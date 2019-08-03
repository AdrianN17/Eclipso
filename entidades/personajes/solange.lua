local Class= require "libs.hump.class"
local bala_electricidad = require "entidades.balas.bala_electricidad"

local funciones = require "entidades.personajes.funciones_jugadores"
local delete = require "entidades.funciones.delete_nil"
local efectos = require "entidades.funciones.efectos"

local solange = Class{
    __includes={delete,efectos}
}


function solange:init(entidades,creador,nombre)
	local x,y,identificador = entidades:dar_xy_personaje()
	self.identificador_nacimiento_player=identificador

	self.tipo="solange"
	self.tipo_escudo="plasma"

	self.nombre=nombre


	self.entidades=entidades
	self.creador=creador


	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

	local area=35
	local hp=1000
	local velocidad=700
	local ira=120
	local tiempo_escudo=0.7
	local puntos_brazos={{x=30, y=-40},{x=30, y=40}}
	local puntos_melee=nil
	local mass=30
	local disparo_max_timer=0.2
	local recarga_timer= 1.5
	local balas={{bala=bala_electricidad,balas_max=10, stock=10, brazo=1}}

	funciones:crear_cuerpo(self,x,y,area)
	funciones:crear_brazos(self,puntos_brazos)
	funciones:masa_personaje(self,mass)

	--asignar variables
	self.hp=hp 
	self.ira=0
	self.max_ira=ira

	self.velocidad=velocidad
	self.radio=0
	self.rx,self.ry=0,0
	self.balas=balas

	self.armas_disponibles=#balas
	self.arma=1

	self.max_tiempo_escudo=tiempo_escudo
  	self.escudo_time=0

  	self.recarga_timer=recarga_timer
  	self.timer_recargando=0


	--dibujo
  
  	self.iterator=1
  	self.iterator_2=1
  
  	self.timer_1=0

  	self.tiempo_dash=0
  	self.max_tiempo_dash=1.5

  	self.entidades:add_players(self)

  	efectos.init(self)
  	delete.init(self)
end

function solange:update(dt)
	self:update_efecto(dt)

	if self.efecto_tenidos.current ~="congelado" then
		funciones:angulo(self)
		funciones:movimiento(self,dt)
		funciones:limite_escudo(self,dt)
		funciones:iterador_dibujo_ver1(self,dt)
		funciones:recargando(self,dt)
		funciones:contador_dash(self,dt)
	end
	
	funciones:coger_centro(self)
	funciones:muerte(self)
	funciones:regular_ira(self,dt)
end

function solange:keypressed(key)
	funciones:presionar_botones_movimiento(self,key)
	funciones:cambio_armas(self,key)
	funciones:presionar_botones_escudo(self,key)
	funciones:recargar_balas(self,key)
	funciones:dash(self,key)
end

function solange:keyreleased(key)
	funciones:soltar_botones_movimiento(self,key)
	funciones:soltar_botones_escudo(self,key)
end

function solange:mousepressed(x,y,button)
	if button==1 then
		if self.balas[self.arma].stock > 0 then
			local bala=self.balas[self.arma].bala
			local id_brazo=self.balas[self.arma].brazo

			funciones:nueva_bala(self,bala,id_brazo)

			--disminuir municion
			self.balas[self.arma].stock=self.balas[self.arma].stock-1
		end
	end
end

function solange:mousereleased(x,y,button)
	funciones:soltar_arma_de_fuego(self)
end

function solange:pack()
    return funciones:empaquetado_1(self)
end

return solange