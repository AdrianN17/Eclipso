local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local semillas = require "entidades.objetos.balas.semillas"

local C = Class{
	__includes = estandar
}


function C:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=250

	self.friccion=30

	self.hp=800

	self.max_ira=100

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,30)

	self.points={
		entidad.collider:point(self.ox+30,self.oy)
	}

	estandar.init(self)

	self.entidad.collisions:add_collision_object("player",self)
end

function C:draw()
	self:drawing()
end

function C:update(dt)
	self:updating(dt)
end

function C:keypressed(key)
	self:keys_down(key)
end

function C:keyreleased(key)
	self:keys_up(key)
end

function C:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido then
		--self:shoot_down(px,py,electricidad,rad)
	end
end

function C:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function C:wheelmoved(x,y)
	self:wheel(x,y)
end

return C