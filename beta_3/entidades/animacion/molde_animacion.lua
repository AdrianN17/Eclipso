local Class = require "libs.hump.class"

local molde_animacion = Class{}

function molde_animacion:init(spritesheet)
  self.spritesheet=spritesheet
  
  self.iterator=1
  
  self.timer_1=0
end

function molde_animacion:draw()
  local x,y,w,h = self.spritesheet[1]:getViewport( )
  
  lg.draw(self.spritesheet["image"],self.spritesheet[self.iterator],self.ox,self.oy,self.radio + math.pi/2,1,1,w/2,h/2)
end

function molde_animacion:update_animation(dt)
  if self.estados.moviendo then
    self.timer_1=self.timer_1+dt
    
    if self.timer_1>0.3 then
      if self.iterator<3 then
        self.iterator=self.iterator+1
      else
        self.iterator=2 
      end
      self.timer_1=0
    end
  else
    self.iterator=1
    self.timer_1=0
  end
end

return molde_animacion