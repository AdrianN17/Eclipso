local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local electricidad= require "entidades.objetos.balas.electricidad"

local S = Class{
	__includes = estandar
}

function S:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=400

	self.friccion=30

	self.hp=600

	self.max_ira=100

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,30)

	self.points={
		entidad.collider:point(self.ox-30,self.oy)
	}

	--herencia
	estandar.init(self)

	--enviado a la clase HC_collisions
	self.entidad.collisions:add_collision_object("player",self)
end

function S:draw()
	self:drawing()
end

function S:update(dt)
	self:updating(dt)
end

function S:keypressed(key)
	self:keys_down(key)
end

function S:keyreleased(key)
	self:keys_up(key)
end

function S:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido then
		self:shoot_down(px,py,electricidad,rad)
	end
end

function S:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function S:wheelmoved(x,y)
	self:wheel(x,y)
end


return S