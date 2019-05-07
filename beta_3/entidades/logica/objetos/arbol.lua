local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local arbol = Class{
  __includes = molde_objetos
}

function arbol:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)

	self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
	self.shape=py.newCircleShape(35)
	self.fixture=py.newFixture(self.collider,self.shape)

	--self.fixture:setUserData( {data="arbol",obj=self, pos=14} )

	self.ox,self.oy=self.collider:getX()-3,self.collider:getY()-2
  
  molde_objetos.init(self,img.objetos,2)
end

function arbol:update(dt)
  
end

return arbol