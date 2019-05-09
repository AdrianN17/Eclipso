local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local roca = Class{
  __includes = molde_objetos
}

function roca:init(x,y,entidades)
  
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)

	self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
	self.shape=py.newChainShape(true,-62 , -50, -13 , -78, 38 , -67, 73 , -31, 43 , 41, -6 , 79, -58 , 51, -75 , 19)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="objeto",obj=self, pos=5} )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  molde_objetos.init(self,img.objetos,3)

end


function roca:update(dt)
  
end

return roca