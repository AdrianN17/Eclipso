local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"

local muymuy = Class{
	__includes=Molde
}

function muymuy:init(entidades,x,y)
	self.entidades=entidades

	Molde.init(self,x,y,30,60)

	self:reset_mass(20)
end

function muymuy:draw()
	self:drawing()
end

function muymuy:update(dt)
	self:updating(dt)
end

return muymuy