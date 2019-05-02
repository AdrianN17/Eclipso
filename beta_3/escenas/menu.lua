local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Slab = require 'libs.Slab'


local Menu= Class{}
local x,y=0,0
function Menu:init()
  x,y=lg.getDimensions( )
  Slab.Initialize()
end

function Menu:draw()
  Slab.Draw()
end

function Menu:update(dt)
  Slab.Update(dt)
  
	Slab.BeginWindow('MyFirstWindow', {Title = "My First Window"})
	Slab.Text("Hello World")
	Slab.EndWindow()
  
end

function Menu:mousepressed()
  
end

return Menu