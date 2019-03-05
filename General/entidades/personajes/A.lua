local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"

local A = Class{
	__includes = estandar
}

function A:init(entidad,x,y,r)
	--inicializar
	self.entidad=entidad
	self.x,self.y,self.r=x,y,r

	self.max_velocidad=500
	self.acc=100

	self.collider=entidad.collider:circle(x,y,r)

	self.ox,self.oy=self.collider:center()

	--herencia
	estandar.init(self)
end

function A:draw()
	self:drawing()
end

function A:update(dt)
	self:updating(dt)
end

function A:keypressed(key)
	self:keys_down(key)
end

function A:keyreleased(key)
	self:keys_up(key)
end

return A