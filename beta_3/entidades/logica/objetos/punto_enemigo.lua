local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local punto_enemigo = Class{
  __includes = molde_objetos
}

function punto_enemigo:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)
  table.insert(self.entidades.respawn_points_enemigos,{x=x,y=y})
  
  self.ox,self.oy=x,y
  
  molde_objetos.init(self,img.objetos,4)
end

function punto_enemigo:update(dt)
  
end

return punto_enemigo