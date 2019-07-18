local Class= require "libs.hump.class"
require "entidades.personajes.funciones_jugadores"

local aegis = Class{}

function aegis:init(entidades,x,y,creador)

	self.entidades=entidades
	self.creador=creador

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

	local area=35
	local hp=1000
	local velocidad=750
	local ira=200
	local tiempo_escudo=0.5
	local puntos_brazos={{x=30, y=42},{x=30, y=-42}}
	local puntos_melee=nil
	local mass=30
	local disparo_max_timer=0.35
	local recarga_timer= 1
	local balas_data_1={bala=bala_hielo , balas_max=5 }
	local balas_data_2={bala=bala_fuego , balas_max=8}

	crear_cuerpo(self,x,y,area)
	crear_brazos(self,puntos_brazos)
	
end

function aegis:draw()

end

function aegis:update(dt)

end

function aegis:keypressed(key)

end

function aegis:keyreleased(key)

end

function aegis:mousepressed(x,y,button)

end

function aegis:mousereleased(x,y,button)

end

return aegis