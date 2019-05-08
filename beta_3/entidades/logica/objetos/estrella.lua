local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local estrella = Class{
  __includes = molde_objetos
}

function estrella:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)
  
  self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
	self.shape=py.newChainShape(true,-72 , -21,
-40 , -28,
-25 , -36,
-5 , -65,
6 , -67,
23 , -35,
38 , -26,
70 , -19,
71 , -8,
46 , 18,
42 , 34,
45 , 59,
35 , 68,
3 , 54,
-10 , 51,
-43 , 65,
-53 , 58,
-47 , 26,
-50 , 12,
-73 , -14)
	self.fixture=py.newFixture(self.collider,self.shape)

	--self.fixture:setUserData( {data="arbol",obj=self, pos=14} )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  molde_objetos.init(self,img.objetos,1)
  
end

function estrella:update(dt)
  
end

--[[
-73 , -21
-26 , -32
3 , -66
30 , -28
71 , -14
43 , 30
-47 , 24

-47 , 25  43 , 30
-47 , 62  -47 , 24
-5 , 54
40 , 66
42 , 26

]]

return estrella