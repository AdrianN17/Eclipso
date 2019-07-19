local Class= require "libs.hump.class"
local bala_espinas = require "entidades.balas.bala_espinas"

local funciones = require "entidades.personajes.funciones_jugadores"

local xeon = Class{}

function xeon:init(entidades,x,y,creador)
    self.tipo="xeon"
    self.tipo_escudo="espinas"

    self.entidades=entidades
    self.creador=creador

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

  	local area=35
    local hp=1000
    local velocidad=600
    local ira=300
    local tiempo_escudo=0.4
    local puntos_brazos={{x=30, y=40},{x=30, y=-40}}
    local puntos_melee={x=30,y=-50,w=125,h=25,dano=85}--,tiempo=1.5}
    local mass=30
    local disparo_max_timer=0.2
    local recarga_timer= 1.5
    local balas={{bala=bala_espinas,balas_max=4,stock=4,brazo=1}}

    funciones:crear_cuerpo(self,x,y,area)
    funciones:crear_brazos(self,puntos_brazos)
    funciones:crear_armas_melee(self,puntos_melee)
    funciones:masa_personaje(self,mass)

    --asignar variables
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

    self.spritesheet=self.entidades.img_personajes.xeon
    self.spritesheet_escudos=self.entidades.img_escudos
  
    self.iterator=1
    self.iterator_2=1
  
    self.timer_1=0
end

function xeon:draw()
    funciones:dibujar_personaje(self)
    funciones:dibujar_melee(self)
    funciones:dibujar_escudo(self)
end

function xeon:update(dt)
	funciones:angulo(self)
    funciones:movimiento(self,dt)
    funciones:limite_escudo(self,dt)
    funciones:iterador_dibujo_ver2(self,dt)
    funciones:recargando(self,dt)
    funciones:coger_centro(self)
end

function xeon:keypressed(key)
    funciones:presionar_botones_movimiento(self,key)
    funciones:cambio_armas(self,key)
    funciones:presionar_botones_escudo(self,key)
    funciones:recargar_balas(self,key)
end

function xeon:keyreleased(key)
    funciones:soltar_botones_movimiento(self,key)
    funciones:soltar_botones_escudo(self,key)
end

function xeon:mousepressed(x,y,button)
     if button==1 then
        if self.balas[self.arma].stock > 0 then
            
            funciones:desactivar_melee(self)

            local bala=self.balas[self.arma].bala
            local id_brazo=self.balas[self.arma].brazo

            funciones:nuevas_balas(self,bala,id_brazo)

            --disminuir municion
            self.balas[self.arma].stock=self.balas[self.arma].stock-1
        end
    elseif button==2 then
        funciones:activar_melee(self)
    end
end

function xeon:mousereleased(x,y,button)
    if button==1 then
        funciones:soltar_arma_de_fuego(self)
    elseif button==2 then
        funciones:desactivar_melee(self)
    end
end

return xeon