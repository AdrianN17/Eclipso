local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local agujas = require "entidades.balas.agujas"

local X = Class{
	__includes = estandar
}

function X:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=300

	self.friccion=30

	self.hp=1000

	self.max_ira=300

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,25)

	self.points={
		entidad.collider:point(self.ox+30,self.oy)
	}

	estandar.init(self)

	self.entidad.collisions:add_collision_object("player",self)
end

function X:draw()
	self:drawing()
end

function X:update(dt)
	self:updating(dt)
end

function X:keypressed(key)
	self:keys_down(key)
end

function X:keyreleased(key)
	self:keys_up(key)
end

function X:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido then
		--self:shoot_down(px,py,electricidad,rad)
	end
end

function X:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function X:wheelmoved(x,y)
	self:wheel(x,y)
end

return X