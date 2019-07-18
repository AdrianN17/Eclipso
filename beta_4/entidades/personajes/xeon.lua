local Class= require "libs.hump.class"
require "entidades.personajes.funciones_jugadores"

local xeon = Class{}

function xeon:init(x,y,entidades)

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

  	local area=35
    local hp=1000
    local velocidad=600
    local ira=300
    local tiempo_escudo=0.4
    local puntos_brazos={{x=30, y=40},{x=30, y=-40}}
    local puntos_melee={x=10,y=-50,w=85,h=25,dano=85,tiempo=1.5}
    local mass=30
    local disparo_max_timer=0.2
    local recarga_timer= 1.5
    local balas_data_1={bala=bala_espina,balas_max=15}
    local balas_data_2=nil

    crear_cuerpo(self,x,y,area)
	crear_brazos(self,puntos_brazos)
end

function xeon:draw()

end

function xeon:update(dt)

end

function xeon:keypressed(key)

end

function xeon:keyreleased(key)

end

function xeon:mousepressed(x,y,button)

end

function xeon:mousereleased(x,y,button)

end

return xeon