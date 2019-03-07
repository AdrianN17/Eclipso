local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local plasma = require "entidades.objetos.balas.plasma"

local R = Class{
	__includes = estandar
}


function R:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=400

	self.friccion=30

	self.hp=1000

	self.max_ira=250

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

function R:draw()
	self:drawing()
end

function R:update(dt)
	self:updating(dt)
end

function R:keypressed(key)
	self:keys_down(key)
end

function R:keyreleased(key)
	self:keys_up(key)
end

function R:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido then
		--self:shoot_down(px,py,electricidad,rad)
	end
end

function R:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function R:wheelmoved(x,y)
	self:wheel(x,y)
end

return R
