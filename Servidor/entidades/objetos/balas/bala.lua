local Class = require "libs.hump.class"

local bala = Class{}

function bala:init()
	self.delta_velocidad=self.entidad.vector(math.cos(self.angle),math.sin(self.angle))
	self.radio=0

	self.collision= self.entidad.collisions

	self.z=self.z+20
end

function bala:drawing()
	self.collider:draw("fill")

	lg.print(self.z,self.ox,self.oy-100)
end

function bala:updating(dt)
	self.z=self.z-dt*25
	local delta=self.delta_velocidad*self.velocidad*dt

	self.collider:move(delta:unpack())

	self.ox,self.oy=self.collider:center()

	if self.z<0 then
		if self.destroy then
			self:destroy()
		end
		self:remove()
	end
end

function bala:remove()
	self.entidad.collider:remove(self.collider)
	self.collision:remove_collision_object("balas",self)
end

function bala:collides_bala(obj)
	self.hp=self.hp-obj.daño
	if self.hp<1 then
		self:remove()
	end
end

return bala