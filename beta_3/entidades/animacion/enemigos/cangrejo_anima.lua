local Class = require "libs.hump.class"

local cangrejo_anima = Class{}


function cangrejo_anima:init(spritesheet,tipo)
  self.spritesheet=spritesheet
  
  self.tipo=tipo
  
  self.iterator=1
  
  self.contador_anima=0
  
  self.cambio_anima=0.5
  
  self.max_anima=2
end

function cangrejo_anima:draw()
  local x,y,w,h = self.spritesheet[self.tipo][self.iterator]:getViewport( )
    
    lg.draw(self.spritesheet["image"],self.spritesheet[self.tipo][self.iterator],self.ox,self.oy,self.radio,self.spritesheet[self.tipo].scale,self.spritesheet[self.tipo].scale,w/2,h/2)
    
    lg.print(self.hp,self.ox,self.oy-100)
    
    --lg.line(self.raycast.x,self.raycast.y,self.raycast.w,self.raycast.h)
end

function cangrejo_anima:update_animation(dt)
  self.contador_anima=self.contador_anima+dt
  
  if self.contador_anima>self.cambio_anima then
    self.iterator=self.iterator+1
    
    if self.iterator>self.max_anima then
      self.iterator=1
    end
    
    self.contador_anima=0
  end
end

return cangrejo_anima