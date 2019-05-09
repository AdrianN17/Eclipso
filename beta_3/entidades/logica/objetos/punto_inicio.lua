local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local punto_inicio = Class{
  __includes = molde_objetos
}

function punto_inicio:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)
  table.insert(self.entidades.respawn_points,{x=x,y=y})
  
  self.ox,self.oy=x,y
  
  molde_objetos.init(self,img.objetos,5)
end

function punto_inicio:update(dt)
  
end

return punto_inicio