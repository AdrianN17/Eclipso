local Class = require "libs.hump.class"

local muymuy_anima = Class{}


function muymuy_anima:init(spritesheet,tipo)
  self.spritesheet=spritesheet
  
  self.tipo=tipo
  
  self.iterator=1
end

function muymuy_anima:draw()
  local x,y,w,h = self.spritesheet[self.tipo][self.iterator]:getViewport( )
    
    lg.draw(self.spritesheet["image"],self.spritesheet[self.tipo][self.iterator],self.ox,self.oy,self.radio,self.spritesheet[self.tipo].scale,self.spritesheet[self.tipo].scale,w/2,h/2)
    
    lg.print(self.hp,self.ox,self.oy-100)
    
    lg.line(self.raycast.x,self.raycast.y,self.raycast.w,self.raycast.h)
end

function muymuy_anima:update_animation(dt)
  
end

return muymuy_anima