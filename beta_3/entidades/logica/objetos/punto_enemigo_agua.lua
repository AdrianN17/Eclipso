local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"

local enemigos = {  require "entidades.logica.enemigos.Muymuy",
                         require "entidades.logica.enemigos.Cangrejo"
                      }

local punto_enemigo_agua = Class{
  __includes = molde_objetos
}

function punto_enemigo_agua:init(x,y,entidades)
  self.entidades=entidades

	self.entidades:add_obj("objetos",self)
  table.insert(self.entidades.respawn_points_enemigos,{x=x,y=y})
  
  self.ox,self.oy=x,y
  
  self.timer=100
  
  self.min_random=1
  
  self.max_random=2
  
  molde_objetos.init(self,img.objetos,4)
  
end

function punto_enemigo_agua:update(dt)
  self.timer=self.timer+dt
  
  if self.timer>5 and self.entidades.cantidad_enemigos<self.entidades.max_cantidad_enemigos then
    enemigos[lm.random(self.min_random,self.max_random)](self.entidades,self.ox,self.oy)
    
    self.entidades.cantidad_enemigos=self.entidades.cantidad_enemigos+1
    
    self.timer=0
  end
end

return punto_enemigo_agua