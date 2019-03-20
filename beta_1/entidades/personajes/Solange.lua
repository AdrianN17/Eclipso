local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local electricidad= require "entidades.objetos.balas.electricidad"
local bullet_control = require "libs.Bullets.bullet_control"

local Solange = Class{
	__includes = Modelo
}

function Solange:init(entidades,x,y,creador)
	self.personaje="Solange"
	--inicializar
	self.entidades=entidades

	self.creador=creador

	self.velocidad=400

	self.friccion=30

	self.hp=600

	self.max_ira=100


	self.escudo_tiempo=0.6

	self.recargando_1=false

	Modelo.init(self,x,y,20)

	self.points={
		{x=self.ox-30, y=self.oy,d=-30}
	}



	self.electricidad_control=bullet_control(7,7,"infinito","infinito",self.timer,0.3)
end

function Solange:draw()
	self:drawing()
end

function Solange:update(dt)
	self:updating(dt)
end

function Solange:keypressed(key)
	self:key_pressed(key)

	self:recarga(key,"electricidad_control")
end

function Solange:keyreleased(key)
	self:key_released(key)
end

function Solange:mousepressed(x,y,button)
	local px,py=self.points[button].x,self.points[button].y
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.electricidad_control:check_bullet() and not self.recargando_1 then
		self:shoot_down(px,py,electricidad,rad)
		self.electricidad_control:newbullet()
	end
end

function Solange:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function Solange:wheelmoved(x,y)
	self:wheel(x,y)
end


return Solange