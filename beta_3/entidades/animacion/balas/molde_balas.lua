local Class = require "libs.hump.class"

local molde_balas = Class{}

function molde_balas:init(spritesheet,id)
  self.spritesheet=spritesheet
  self.id=id
end

function molde_balas:draw()
  
  local x,y,w,h = self.spritesheet[self.id]:getViewport( )
  
  lg.draw(self.spritesheet.image,self.spritesheet[self.id],self.ox,self.oy,0,self.spritesheet.scale,self.spritesheet.scale,w/2,h/2)
end

return molde_balas