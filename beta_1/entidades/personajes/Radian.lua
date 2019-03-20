local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local plasma = require "entidades.objetos.balas.plasma"
local bullet_control = require "libs.Bullets.bullet_control"
local melee = require "entidades.objetos.melees.melee"

local Radian = Class{
	__includes = Modelo
}


function Radian:init(entidades,x,y,creador)
	self.personaje="Radian"
	--inicializar
	self.entidades=entidades

	self.creador=creador

	self.velocidad=400

	self.friccion=30

	self.hp=1000

	self.max_ira=250

	self.escudo_tiempo=0.6

	Modelo.init(self,x,y,20)

	self.points={
		{x=self.ox+30, y=self.oy,d=30}
	}

	self.recargando_1=false

	self.time_melee=0.5
	
	--self.melee=melee(75,entidad.collider:rectangle(self.ox-25,self.oy+15,10,50),self,self.creador)

	self.plasma_control=bullet_control(2,2,"infinito","infinito",self.timer,0.6)
end

function Radian:draw()
	self:drawing()
end

function Radian:update(dt)
	self:updating(dt)
end

function Radian:keypressed(key)
	self:key_pressed(key)
	self:recarga(key,"plasma_control")

	if key=="q" and not self.estados.protegido then
		self.estados.atacando=true
		self.timer:after(self.time_melee,function() self.estados.atacando=false end)
	end
end

function Radian:keyreleased(key)
	self:key_released(key)

	if key=="q" then
		self.estados.atacando=false
	end
end

function Radian:mousepressed(x,y,button)
	local px,py=self.points[1].x,self.points[1].y
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.plasma_control:check_bullet() and not self.recargando_1 then
		self:shoot_down(px,py,plasma,rad,self.creador)
		self.plasma_control:newbullet()
	end
end

function Radian:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function Radian:wheelmoved(x,y)
	self:wheel(x,y)
end

return Radian
