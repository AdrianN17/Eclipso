local Class = require "libs.hump.class"

local campo_electrico = Class {}

function campo_electrico:init(entidad,x,y)
	self.entidad=entidad
	self.collider=self.entidad.collider:circle(x,y,40)

	self.time=0
end

function campo_electrico:draw()
	self.collider:draw("line")
end

function campo_electrico:update(dt)
	self.time=self.time+dt
	if self.time>2 then
		self:remove()
	end
end

function campo_electrico:remove()
	self.entidad.collider:remove(self.collider)
	self.entidad.collisions:remove_collision_object("campo_electrico",self)
end

return campo_electrico