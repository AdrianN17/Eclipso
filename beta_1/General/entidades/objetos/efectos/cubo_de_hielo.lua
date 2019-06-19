local Class = require "libs.hump.class"

local cubo_de_hielo = Class {}

function cubo_de_hielo:init(entidad,x,y)
	self.entidad=entidad
	self.collider=self.entidad.collider:polygon(x-20,y-20,x-30,y,x-20,y+20,x+20,y+20,x+30,y,x+20,y-20)
	self.radio=love.math.random(0,360)
	self.collider:rotate(math.rad(self.radio))
	self.hp=100

	self.ox,self.oy=self.collider:center()
	self.scale=1

	self.time=0
end

function cubo_de_hielo:draw()
	self.collider:draw("line")
end

function cubo_de_hielo:update(dt)
	self.time=self.time+dt
	if self.time>15 then
		self:remove()
	end
end

function cubo_de_hielo:resize(type)
	self.scale=self.scale*1.25
	self.collider:scale(self.scale)
	--se puede hacer con uno que sea 1.25 y otro 0.75, con un counter de -3 a 3 siendo 0 el punto estandar
end

function cubo_de_hielo:remove()
	self.entidad.collider:remove(self.collider)
	self.entidad.collisions:remove_collision_object("barrera_hielo",self)
end

function cubo_de_hielo:attack(daño)
	self.hp=self.hp-daño
	if self.hp<1 then
		self:remove()
	end
end

return cubo_de_hielo
