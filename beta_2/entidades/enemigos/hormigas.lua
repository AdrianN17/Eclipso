local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"

local hormigas = Class{
	__includes=Molde
}

function hormigas:init(x,y)

	self.enemigo="hormigas"

	Molde.init(self,x,y,20)

end

function hormigas:draw()
	self:drawing()
end

function hormigas:update(dt)
	self:updating(dt)
end


return hormigas