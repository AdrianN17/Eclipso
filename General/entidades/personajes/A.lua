local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local hielo =  require "entidades.objetos.balas.hielo"
local fuego =  require "entidades.objetos.balas.fuego"
local bullet_control = require "libs.Bullets.bullet_control"

local A = Class{
	__includes = estandar
}

function A:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y
	self.creador=creador


	self.velocidad=400

	self.friccion=30

	self.hp=500

	self.max_ira=200

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo=entidad.collider:circle(x,y,40)

	self.escudo_tiempo=0.3

	self.points={
		entidad.collider:point(self.ox-30,self.oy),entidad.collider:point(self.ox+30,self.oy)
	}

	--herencia
	estandar.init(self)

	--enviado a la clase HC_collisions
	self.entidad.collisions:add_collision_object("player",self)

	self.hielo.control=bullet_control(2,2,2,"infinito",self.timer,0.5)
	self.fuego.control=bullet_control(4,4,4,"infinito",self.timer,0.2)
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

function A:mousepressed(x,y,button)
	local px,py=self.points[button]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido then
		self:shoot_down(px,py,hielo,rad,self.creador)
	elseif button==2 and not self.estados.protegido then
		self:shoot_down(px,py,fuego,rad,self.creador)
	end
end

function A:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function A:wheelmoved(x,y)
	self:wheel(x,y)
end

function A:reflejo(obj,dx,dy) 

		obj.z=obj.z+5

		obj.collider:move(dx,dy)

		obj.delta_velocidad.x,obj.delta_velocidad.y=-dx,-dy

		self.estados.protegido=false
		obj.creador=self.creador
end

return A