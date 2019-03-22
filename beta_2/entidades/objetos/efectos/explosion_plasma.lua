local Class = require "libs.hump.class"

local explosion_plasma = Class {}

function explosion_plasma:init(entidades,x,y)
	self.entidades=entidades

	self.entidades:add_obj("efectos",self)

	self.collider=py.newBody(self.entidades.world,x,y,"static")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(45)
	self.fixture=py.newFixture(self.collider,self.shape)
	
	self.fixture:setUserData( {data="explosion_plasma",obj=self} )
	self.fixture:setSensor(true)


	self.time=0

	self.tipo="explosion_plasma"
	self.efecto="plasma"

	self.ox,self.oy=self.collider:getWorldCenter()
end

function explosion_plasma:draw()
	
end

function explosion_plasma:update(dt)
	self.time=self.time+dt
	if self.time>1 then
		self:remove()
	end
end

function explosion_plasma:remove()
	self.collider:destroy()
	self.entidades:remove_obj("efectos",self)
end

function explosion_plasma:send_data()
	local data={}
	data.tipo=self.tipo
	data.ox,data.oy=self.ox,self.oy
	data.hp=self.hp 

	local f=self.fixture:getShape()
	data.r=f:getRadius()

	return data
end

return explosion_plasma