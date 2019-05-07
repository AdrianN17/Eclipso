local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local estrella = Class{
  __includes = molde_objetos
}

function estrella:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)
  
  self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
	self.shape=py.newPolygonShape(-71 , -21,
1 , -68,
70 , -14,
41 , 66,
-6 , 48,
-47 , 61)
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