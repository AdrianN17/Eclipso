local Class = require "libs.hump.class"

local bullet_control = Class{}

function bullet_control:init(stock,max_stock,municion,max_municion,timer,intervalo,tiempo_recarga)
	self.stock=stock 
	self.max_stock=max_stock
	self.municion=municion
	self.max_municion=max_municion

	if municion=="infinito" and self.max_municion=="infinito" then
		self.infinito=true
	end

	self.timer=timer

	self.intervalo=intervalo
end

function bullet_control:check_bullet()
	return self.stock > 0
end

function bullet_control:check_bullet_cantidad()
	return self.stock
end

function bullet_control:newbullet(cantidad)
	if not cantidad then
		cantidad=1
	end

	self.stock=self.stock-cantidad
end

function bullet_control:reload(obj)
	self.timer:after(self.intervalo , function ()
		if self.infinito then
			self.stock=self.max_stock
			obj.recargando_1=false
			obj.recargando_2=false
		end
	end)
end

return bullet_control