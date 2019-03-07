local Class = require "libs.hump.class"

local bullet_control = Class{}

function bullet_control:init(stock,max_stock,municion,max_municion,timer,intervalo,tiempo_recarga)
	self.stock=stock 
	self.max_stock=max_stock
	self.municion=municion
	self.max_municion=max_municion

	if max_municion=="infinito" then
		self.infinito=true
	end

	self.timer=timer
end

function bullet_control:check_bullet()
	return self.stock > 0
end

function bullet_control:newbullet(cantidad)
	if not cantidad then
		local cantidad=1
	end

	self.stock=self.stock-cantidad
end

function bullet_control:reload()
	if self.infinito then
		
	else

	end
end

return bullet_control