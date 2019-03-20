local Class = require "libs.hump.class"

local barrera_de_fuego = Class {}

function barrera_de_fuego:init(entidades,x,y)
	self.entidades=entidades

	self.entidades:add_obj("efectos",self)

	self.collider=py.newBody(self.entidades.world,x,y,"static")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(25)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="barrera_de_fuego",obj=self} )
	self.fixture:setSensor(true)

	self.time=0

	self.tipo="barrera_de_fuego"
	self.efecto="quemadura"

	self.ox,self.oy=self.collider:getWorldCenter()
end

function barrera_de_fuego:draw()
	--self.collider:draw("line")
end

function barrera_de_fuego:update(dt)
	self.time=self.time+dt
	if self.time>5 then
		self:remove()
	end
end

function barrera_de_fuego:remove()
	self.collider:destroy()
	self.entidades:remove_obj("efectos",self)
end

return barrera_de_fuego