local Class = require "libs.hump.class"

local explosion_plasma = Class {}

function explosion_plasma:init(entidad,x,y)
	self.entidad=entidad
	self.collider=self.entidad.collider:circle(x,y,45)

	self.time=0
end

function explosion_plasma:draw()
	self.collider:draw("line")
end

function explosion_plasma:update(dt)
	self.time=self.time+dt
	if self.time>1 then
		self:remove()
	end
end

function explosion_plasma:remove()
	self.entidad.collider:remove(self.collider)
	self.entidad.collisions:remove_collision_object("explosion_plasma",self)
end

return explosion_plasma