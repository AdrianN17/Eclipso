local Class = require "libs.hump.class"

local barrera_de_fuego = Class {}

function barrera_de_fuego:init(entidad,x,y)
	self.entidad=entidad
	self.collider=self.entidad.collider:circle(x,y,25)
	self.time=0
end

function barrera_de_fuego:draw()
	self.collider:draw("line")
end

function barrera_de_fuego:update(dt)
	self.time=self.time+dt
	if self.time>5 then
		self:remove()
	end
end

function barrera_de_fuego:remove()
	self.entidad.collider:remove(self.collider)
	self.entidad.collisions:remove_collision_object("suelo_llamas",self)
end

return barrera_de_fuego