local Class = require "libs.hump.class"
local molde_anima = require "entidades.animacion.molde_animacion"

local Solange_anima = Class{

}

function Solange_anima:init(spritesheet,escudos)
  self.spritesheet=spritesheet
  self.spritesheet_escudos=escudos
  
  self.iterator=1
  self.iterator_2=1
  
  self.timer_1=0
  
  self.moviendo_array={{3,4},{5,6}}
  
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

function Solange_anima:draw()
  
  if self.estados.vivo then
    local x,y,w,h = self.spritesheet[self.iterator]:getViewport( )
  
  lg.draw(self.spritesheet["image"],self.spritesheet[self.iterator],self.ox,self.oy,self.radio + math.pi/2,self.spritesheet.scale,self.spritesheet.scale,w/2,h/2)
  end
  
  
  if self.estados.protegido then
    local x_s,y_s,w_s,h_s = self.spritesheet_escudos[2]:getViewport( )
    lg.draw(self.spritesheet_escudos["image"],self.spritesheet_escudos[2],self.ox,self.oy,0,self.spritesheet_escudos.scale,self.spritesheet_escudos.scale,w_s/2,h_s/2)
  end
  
  
  
  
end

return Solange_anima