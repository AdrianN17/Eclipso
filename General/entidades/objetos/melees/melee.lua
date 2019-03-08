local Class = require "libs.hump.class"

local melee=Class{}

function melee:init(daño,shape)
	self.damage=daño

	self.melee_shape=shape

	print(daño,shape)

end

function melee:drawing_melee()
	--self.melee_shape:draw("fill")
end

function melee:updating_melee(dt)

end

function melee:touch(obj)

end

return melee