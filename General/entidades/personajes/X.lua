local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local agujas = require "entidades.objetos.balas.agujas"
local bullet_control = require "libs.Bullets.bullet_control"
local melee = require "entidades.objetos.melees.melee"

local X = Class{
	__includes = estandar,melee
}

function X:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=300

	self.friccion=30

	self.hp=1000

	self.max_ira=300

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,30)

	self.points={
		entidad.collider:point(self.ox+30,self.oy)
	}

	self.recargando_1=false

	estandar.init(self)

	self.entidad.collisions:add_collision_object("player",self)

	self.agujas_control=bullet_control(10,10,"infinito","infinito",self.timer,0.5)

	self.disparo_continuo=false

	self.timer:every(0.2,function() 
		if self.disparo_continuo and not self.estados.protegido and self.agujas_control:check_bullet() and not self.recargando_1 then
			local x,y = self.entidad:getXY()
			local px,py=self.points[1]:center()
			local rad=math.atan2( y-py, x -px)

			self:shoot_down(px,py,agujas,rad)
			self.agujas_control:newbullet()
		end
	end)
end

function X:draw()
	self:drawing()
end

function X:update(dt)
	self:updating(dt)

	
end

function X:keypressed(key)
	self:keys_down(key)
	self:recarga(key,"agujas_control")
end

function X:keyreleased(key)
	self:keys_up(key)
end

function X:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 then
		self.disparo_continuo=true
	end

	if button==2 and not self.estados.protegido  and self.agujas_control:check_bullet() and not self.recargando_1 and not self.disparo_continuo then
		local balas_disponibles=self.agujas_control:check_bullet_cantidad()

		for i=1,balas_disponibles,1 do
			self:shoot_down(px,py,agujas,rad+math.rad(lm.random(-5,5)))
		end
		self.agujas_control:newbullet(balas_disponibles)
	end
end

function X:mousereleased(x,y,button)
	self:shoot_up(x,y,button)

	if button==1 then
		self.disparo_continuo=false
	end
end

function X:wheelmoved(x,y)
	self:wheel(x,y)
end

return X