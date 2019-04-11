local Class = require "libs.hump.class"
local Molde = require "entidades.enemigos.molde"

local langostas = Class{
	__includes=Molde
}

function langostas:init(entidades,x,y)
	self.entidades=entidades

	Molde.init(self,x,y,)
end

function langostas:draw()

end

function langostas:update(dt)

end

return langostas