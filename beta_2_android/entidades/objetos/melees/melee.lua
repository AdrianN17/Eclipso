local Class = require "libs.hump.class"

local melee=Class{}

function melee:init(daño,shape,player,creador)

	self.damage=daño

	self.melee_shape=shape

	self.player=player
	self.creador=creador

	self.player.entidad.collisions:add_collision_object("melee",self)
end

function melee:draw()
	if self.player.estados.atacando then
		self.melee_shape:draw("fill")
	end
end

function melee:update(dt)
	if not self.player.estados.no_moverse_atacando then
		self:moves()
		self:rotate()
	end
end

function melee:moves(dx,dy)
	if not dx and not dy then
		self.melee_shape:move(self.player.delta_velocidad:unpack())
	else
		self.melee_shape:move(dx,dy)
	end
end

function melee:rotate()
	self.melee_shape:setRotation(self.player.radio-math.pi/2,self.player.ox,self.player.oy)
end

return melee