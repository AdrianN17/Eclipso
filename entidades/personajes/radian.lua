local Class= require "libs.hump.class"
local bala_plasma = require "entidades.balas.bala_plasma"

local funciones = require "entidades.personajes.funciones_jugadores"
local delete = require "entidades.funciones.delete_nil"
local efectos = require "entidades.funciones.efectos"

local radian = Class{
    __includes={delete,efectos}
}

function radian:init(entidades,creador,nickname,cx,cy)
    local x,y = nil,nil

    if entidades.server then
        local nx,ny,identificador_nacimiento = entidades:dar_xy_personaje()
        self.x,self.y=nx,ny
        x,y=nx,ny
        self.identificador_nacimiento_player=identificador_nacimiento
    else
        x,y=cx,cy
    end

    self.tipo="radian"
    self.tipo_escudo="solar"

    self.nickname=nickname


    self.entidades=entidades
    self.creador=creador

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,atacando_melee=false}
  	self.direccion={a=false,d=false,w=false,s=false}

	local area=35
    local hp=1100
    local velocidad=500
    local ira=250
    local tiempo_escudo=0.45
    local puntos_brazos={{x=40, y=40},{x=40, y=-40}}
    local puntos_melee={x=70,y=40,w=100,h=25,dano=85}--,tiempo=1}
    local mass=30
    local disparo_max_timer=0.5
    local recarga_timer= 2.5
    local balas={{bala=bala_plasma,balas_max=3,stock=3,brazo=2}}


    
	funciones:crear_cuerpo(self,x,y,area)
    funciones:crear_brazos(self,puntos_brazos)
    funciones:crear_armas_melee(self,puntos_melee)
    funciones:masa_personaje(self,mass)

    --asignar variables
    self.hp=hp 
    self.max_hp=self.hp
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

    self.melee_x,self.melee_y=0,0


    --dibujo

    self.spritesheet=self.entidades.img_personajes.radian
    self.spritesheet_escudos=self.entidades.img_escudos
  
    self.iterator=1
    self.iterator_2=1
  
    self.timer_1=0

    self.tiempo_dash=0
    self.max_tiempo_dash=1

    efectos.init(self)
    delete.init(self)
end

function radian:draw()
    funciones:dibujar_melee(self)
    funciones:dibujar_personaje(self)
    funciones:dibujar_escudo(self)
end

function radian:update(dt)
    self:update_efecto(dt)

    if self.efecto_tenidos.current ~="congelado" then

    	funciones:angulo(self)
        funciones:movimiento(self,dt)
        funciones:coger_centro_melee(self)
        funciones:limite_escudo(self,dt)
        funciones:iterador_dibujo_ver2(self,dt)
        funciones:recargando(self,dt)
        funciones:contador_dash(self,dt)
    end
    
    funciones:coger_centro(self)
    funciones:devolver_friccion(self)
    funciones:muerte(self)
    funciones:regular_ira(self,dt)
end

function radian:keypressed(key)
    funciones:presionar_botones_movimiento(self,key)
    funciones:cambio_armas(self,key)
    funciones:presionar_botones_escudo(self,key)
    funciones:recargar_balas(self,key)
    funciones:dash(self,key)
end

function radian:keyreleased(key)
    funciones:soltar_botones_movimiento(self,key)
    funciones:soltar_botones_escudo(self,key)
end

function radian:mousepressed(x,y,button)
    if button==1 then
        if self.balas[self.arma].stock > 0 then
            
            funciones:desactivar_melee(self)

            local bala=self.balas[self.arma].bala
            local id_brazo=self.balas[self.arma].brazo

            funciones:nueva_bala(self,bala,id_brazo)

            --disminuir municion
            self.balas[self.arma].stock=self.balas[self.arma].stock-1
        end
    elseif button==2 then
        funciones:activar_melee(self)
    end
end

function radian:mousereleased(x,y,button)
    if button==1 then
        funciones:soltar_arma_de_fuego(self)
    elseif button==2 then
        funciones:desactivar_melee(self)
    end
end

function radian:pack()
    return funciones:empaquetado_2(self)
end

return radian