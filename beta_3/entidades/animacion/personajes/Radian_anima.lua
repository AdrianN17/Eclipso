local Class = require "libs.hump.class"

local Radian_anima=Class{}

function Radian_anima:init(spritesheet,escudos)
  self.spritesheet=spritesheet
  self.spritesheet_escudos=escudos
  
  self.iterator=1
  self.iterator_2=1
  
  self.timer_1=0
  
end

function Radian_anima:update_animation(dt)
  if self.estados.moviendo then
    
    if self.estados.atacando then
      self.iterator=2
    elseif self.estados.atacando_melee then
      self.iterator=3
    else
      self.iterator=1
    end
    
    self.timer_1=self.timer_1+dt
    
    if self.timer_1>0.3 then
      
      if self.iterator_2<3 then
        self.iterator_2=self.iterator_2+1
      else
        self.iterator_2=2 
      end
      
      self.timer_1=0
    end
    
  else
    if self.estados.atacando then
      self.iterator=2
    elseif self.estados.atacando_melee then
      self.iterator=3
    else
      self.iterator=1
    end
    
    self.iterator_2=1
    self.timer_1=0
  end
  
end

function Radian_anima:draw()
  
  if self.estados.vivo then
    local x,y,w,h = self.spritesheet[self.iterator][self.iterator_2]:getViewport( )
  
  lg.draw(self.spritesheet["image"],self.spritesheet[self.iterator][self.iterator_2],self.ox,self.oy,self.radio + math.pi/2,self.spritesheet.scale,self.spritesheet.scale,w/2,h/2)
  end
  
  
  if self.estados.protegido then
    local x_s,y_s,w_s,h_s = self.spritesheet_escudos[self.tipo_escudo]:getViewport( )
    lg.draw(self.spritesheet_escudos["image"],self.spritesheet_escudos[self.tipo_escudo],self.ox,self.oy,0,self.spritesheet_escudos.scale,self.spritesheet_escudos.scale,w_s/2,h_s/2)
  end
  
  lg.print(self.hp,self.ox,self.oy-100)
  
  
end

return Radian_anima