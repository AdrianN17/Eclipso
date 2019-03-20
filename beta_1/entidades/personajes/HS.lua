local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local ectoplasma =  require "entidades.objetos.balas.ectoplasma"
local bullet_control = require "libs.Bullets.bullet_control"

local HS = Class{
	__includes = Modelo
}

function HS:init(entidades,x,y,creador)
	self.personaje="HS"
	--inicializar

	self.entidades=entidades

	self.creador=creador


	self.velocidad=650

	self.friccion=30

	self.hp=200

	self.max_ira=170


	self.escudo_tiempo=1

	Modelo.init(self,x,y,20)

	self.points={
		{x=self.ox-30, y=self.oy,d=-30}
	}

	self.recargando_1=false


	self.ectoplasma_control=bullet_control(12,12,"infinito","infinito",self.timer,0.7)
end

function HS:draw()
	--if not self.estados.protegido then
		self:drawing()
	--end
end

function HS:update(dt)
	self:updating(dt)
end

function HS:keypressed(key)
	self:key_pressed(key)

	self:recarga(key,"ectoplasma_control")
end

function HS:keyreleased(key)
	self:key_released(key)
end


function HS:mousepressed(x,y,button)
	local px,py=self.points[button].x,self.points[button].y
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.ectoplasma_control:check_bullet() and not self.recargando_1  then
		self:shoot_down(px,py,ectoplasma,rad,self.creador)
		self.ectoplasma_control:newbullet()
	end
end

function HS:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function HS:wheelmoved(x,y)
	self:wheel(x,y)
end

return HS