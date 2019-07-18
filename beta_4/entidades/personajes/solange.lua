local Class= require "libs.hump.class"
require "entidades.personajes.funciones_jugadores"

local solange = Class{}

function solange:init(x,y,entidades)

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
	local balas_data_1={bala=bala_electrica,balas_max=10}
	local balas_data_2=nil

	crear_cuerpo(self,x,y,area)
	crear_brazos(self,puntos_brazos)
end

function solange:draw()

end

function solange:update(dt)

end

function solange:keypressed(key)

end

function solange:keyreleased(key)

end

function solange:mousepressed(x,y,button)

end

function solange:mousereleased(x,y,button)

end

return solange