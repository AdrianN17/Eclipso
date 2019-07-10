local Class= require "libs.hump.class"
local suit=require "libs.suit"

local seleccion= Class{}

function seleccion:init(  )
	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2
	
end

function seleccion:draw(  )
	
end

function seleccion:update(dt)
	
end

function seleccion:textinput(t)
    suit.core.textinput(t)
end

return seleccion