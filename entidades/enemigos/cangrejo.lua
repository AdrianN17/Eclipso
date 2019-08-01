local Class= require "libs.hump.class"

local funciones = require "entidades.enemigos.funciones_enemigos"

local cangrejo = Class{}

function cangrejo:init(entidades,x,y)
	self.tipo="cangrejo"
end

function cangrejo:draw()
	
end

function cangrejo:update(dt)
	
end

return cangrejo