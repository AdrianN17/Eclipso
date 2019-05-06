local Class = require "libs.hump.class"
local molde_anima = require "entidades.animacion.molde_animacion"

local Solange_anima = Class{
  __includes=molde_anima
}

function Solange_anima:init(spritesheet)
  self.spritesheet=spritesheet
  
  self.iterator=1
  self.iterator_2=1
  
  self.timer_1=0
  
  self.moviendo_array={{3,4},{5,6}}
  
  molde_anima.init(self)
end

function Solange_anima:update_animation(dt)
  if self.estados.moviendo then
    self.timer_1=self.timer_1+dt
    
    local it=1
    
    if self.estados.atacando then
      it=2
    end
    
    if self.timer_1>0.3 then
      if self.iterator_2<2 then
        self.iterator_2=self.iterator_2+1
      else
        self.iterator_2=1 
      end
      
      self.iterator=self.moviendo_array[it][self.iterator_2]
      
      self.timer_1=0
    end
  
  else
    if self.estados.atacando then
      self.iterator=2
    else
      self.iterator=1
    end
    
    self.timer_1=0
  end
end

return Solange_anima