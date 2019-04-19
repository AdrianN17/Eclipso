local Class = require "libs.hump.class"

local arbol = Class{}

function arbol:init(x,y,w,h,hp,tipo,entidades)
	self.entidades=entidades

	self.entidades:add_obj("objetos",self)

	self.hp=hp
	self.radio=math.sqrt( w*h)/2

	self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
	self.shape=py.newCircleShape (self.radio)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="arbol",obj=self, pos=14} )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
end


function arbol:draw()

end

function arbol:update()

end

return arbol