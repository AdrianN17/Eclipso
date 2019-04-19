local Class = require "libs.hump.class"

local roca = Class{}

function roca:init(x,y,w,h,hp,tipo,entidades)
	self.entidades=entidades

	self.entidades:add_obj("objetos",self)

	self.hp=hp
	self.radio=math.sqrt( w*h)/2

	self.collider=py.newBody(self.entidades.world,x,y,"kinematic")

	if tipo=="ellipse" then
		self.shape=py.newCircleShape(self.radio)
	elseif tipo=="rectangle" then
		self.shape=py.newRectangleShape(w,h)
	end

	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="roca",obj=self, pos=1} )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
end


function roca:draw()

end

function roca:update()

end

return roca