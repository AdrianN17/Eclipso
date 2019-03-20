local Class = require "libs.hump.class"

local bala = Class{}

function bala:init(x,y,angle,r)

	self.entidades:add_obj("balas",self)

	self.delta_velocidad=self.entidades.vector(math.cos(angle),math.sin(angle))
	self.radio=0


	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(r)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setUserData( {data="bala",obj=self} )

	--categoria 2
	
	self.fixture:setGroupIndex( -self.creador )

	self.ox,self.oy=self.collider:getWorldCenter()




	self.z=self.z+20
end

function bala:drawing()
	lg.print(self.delta_velocidad.x .. " , " .. self.delta_velocidad.y,self.ox,self.oy-100)
end

function bala:updating(dt)
	self.z=self.z-dt*25

	local delta=self.delta_velocidad*self.velocidad

	self.collider:setLinearVelocity(delta:unpack())

	self.ox,self.oy=self.collider:getWorldCenter()

	if self.z<0 then
		if self.destroy then
			self:destroy()
		end
		self:remove()
	end
end

function bala:remove()

	self.collider:destroy( )
	self.entidades:remove_obj("balas",self)
end

function bala:collides_bala(obj)
	self.hp=self.hp-obj.daño
	if self.hp<1 then
		self:remove()
	end
end

return bala