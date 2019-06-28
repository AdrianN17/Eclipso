local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"
local polybool = require "libs.polygon.polybool"

local arrecife = Class{}

function arrecife:init(x,y,polygon,entidades)
  self.tipo_indice=6
  
  self.entidades=entidades
  
  local pol ={}
  
  for _,data in ipairs(polygon) do
    table.insert(pol,data.x-x)
    table.insert(pol,data.y-y)
  end
  
  
  
	self.entidades:add_obj("destruible",self)
  
  self.collider=py.newBody(self.entidades.world,x,y,"kinematic")
  self.shape=py.newChainShape( true,pol  )
	self.fixture=py.newFixture(self.collider,self.shape)
  
  self.fixture:setUserData( {data="destruible",obj=self, pos=10} )
  
  --self.mesh= 
end

function arrecife:update(dt)
  
end

function arrecife:draw()
  
end

return arrecife