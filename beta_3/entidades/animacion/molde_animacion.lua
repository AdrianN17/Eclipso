local Class = require "libs.hump.class"

local molde_animacion = Class{}

function molde_animacion:init()
  
end

function molde_animacion:draw()
  local x,y,w,h = self.spritesheet[self.iterator]:getViewport( )
  
  lg.draw(self.spritesheet["image"],self.spritesheet[self.iterator],self.ox,self.oy,self.radio + math.pi/2,self.spritesheet.scale,self.spritesheet.scale,w/2,h/2)
end



return molde_animacion