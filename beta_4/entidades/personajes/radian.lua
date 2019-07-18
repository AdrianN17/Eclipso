local Class= require "libs.hump.class"
require "entidades.personajes.funciones_jugadores"

local radian = Class{}

function radian:init(x,y,entidades)

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

	local area=35
    local hp=1100
    local velocidad=500
    local ira=250
    local tiempo_escudo=0.45
    local puntos_brazos={{x=40, y=40},{x=40, y=-40}}
    local puntos_melee={x=50,y=40,w=100,h=25,dano=85,tiempo=1}
    local mass=30
    local disparo_max_timer=0.5
    local recarga_timer= 2.5
    local balas_data_1={bala=bala_plasma,balas_max=3}
    local balas_data_2=nil

    

  	crear_cuerpo(self,x,y,area)
	crear_brazos(self,puntos_brazos)
end

function radian:draw()

end

function radian:update(dt)

end

function radian:keypressed(key)

end

function radian:keyreleased(key)

end

function radian:mousepressed(x,y,button)

end

function radian:mousereleased(x,y,button)

end

return radian