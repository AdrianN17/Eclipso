local Class= require "libs.hump.class"
local bala_hielo = require "entidades.balas.bala_hielo"
local bala_fuego = require "entidades.balas.bala_fuego"

local funciones = require "entidades.personajes.funciones_jugadores"
local delete = require "entidades.funciones.delete_nil"
local efectos = require "entidades.funciones.efectos"


local aegis = Class{
    __includes={delete,efectos}
}


function aegis:init(entidades,creador,nickname,cx,cy)
	local x,y = nil,nil

    if entidades.server then
        local nx,ny,identificador_nacimiento = entidades:dar_xy_personaje()
        self.x,self.y=nx,ny
        x,y=nx,ny
        self.identificador_nacimiento_player=identificador_nacimiento
    else
        x,y=cx,cy
    end


	self.tipo="aegis"
	self.tipo_escudo="magnetico"

	self.nickname=nickname

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
	local balas={{bala=bala_hielo , balas_max=5 ,stock=5,brazo=1},{bala=bala_fuego , balas_max=8 ,stock=8,brazo=2}}

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

	self.spritesheet=self.entidades.img_personajes.aegis
  	self.spritesheet_escudos=self.entidades.img_escudos
  
  	self.iterator=1
  	self.iterator_2=1
  
  	self.timer_1=0
  	
  	self.tiempo_dash=0
  	self.max_tiempo_dash=1.5

  	efectos.init(self)
  	delete.init(self)
end

function aegis:draw()
	funciones:dibujar_personaje(self)
	funciones:dibujar_escudo(self)
end

function aegis:update(dt)
	self:update_efecto(dt)

	if self.efecto_tenidos.current ~= "congelado" then
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

function aegis:keypressed(key)
	funciones:presionar_botones_movimiento(self,key)
	funciones:cambio_armas(self,key)
	funciones:presionar_botones_escudo(self,key)
	funciones:recargar_balas(self,key)
	funciones:dash(self,key)
end

function aegis:keyreleased(key)
	funciones:soltar_botones_movimiento(self,key)
	funciones:soltar_botones_escudo(self,key)

end

function aegis:mousepressed(x,y,button)
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

function aegis:mousereleased(x,y,button)
	funciones:soltar_arma_de_fuego(self)
end

function aegis:pack()
    return funciones:empaquetado_1(self)
end

return aegis