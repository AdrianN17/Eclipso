local Class = require "libs.hump.class"

local campo_electrico = Class {}

function campo_electrico:init(entidades,x,y)
	self.entidades=entidades

	self.entidades:add_obj("efectos",self)

	self.collider=py.newBody(self.entidades.world,x,y,"static")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(40)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="campo_electrico",obj=self} )
	self.fixture:setSensor(true)

	self.time=0
	self.tipo="campo_electrico"
	self.efecto="paralisis"

	self.ox,self.oy=self.collider:getWorldCenter()
end

function campo_electrico:draw()
	
end

function campo_electrico:update(dt)
	self.time=self.time+dt
	if self.time>2 then
		self:remove()
	end
end

function campo_electrico:remove()
	self.collider:destroy()
	self.entidades:remove_obj("efectos",self)
end

return campo_electrico