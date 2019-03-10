local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local semillas = require "entidades.objetos.balas.semillas"
local bullet_control = require "libs.Bullets.bullet_control"
local melee = require "entidades.objetos.melees.melee"

local C = Class{
	__includes = estandar
}


function C:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=250

	self.friccion=30

	self.hp=800

	self.max_ira=100

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,30)

	self.points={
		entidad.collider:point(self.ox+30,self.oy)
	}

	self.recargando_1=false

	estandar.init(self)

	self.melee=melee(60,entidad.collider:rectangle(self.ox-12.5,self.oy+45,30,30),self,self.creador)

	self.entidad.collisions:add_collision_object("player",self)

	self.semillas_control=bullet_control(20,20,"infinito","infinito",self.timer,0.5)

	self.disparo_continuo=false

	self.time_melee=0.8


	self.timer:every(0.1, function()
		if self.disparo_continuo and not self.estados.protegido and self.semillas_control:check_bullet() and not self.recargando_1 then
			local x,y = self.rx,self.ry
			local px,py=self.points[1]:center()
			local rad=math.atan2( self.ry-py, self.rx -px)
			self:shoot_down(px,py,semillas,rad)
			self.semillas_control:newbullet()
		end
	end)

	self.no_moverse_atacando=false

	self.tx,self.ty=self.melee.melee_shape:center()
end

function C:draw()
	self:drawing()
end

function C:update(dt)
	self:updating(dt)
	self.tx,self.ty=self.melee.melee_shape:center()
end

function C:keypressed(key)
	self:keys_down(key)

	self:recarga(key,"semillas_control")

	if key=="q" and not self.estados.protegido then
		self.estados.atacando=true
		self.no_moverse_atacando=true
		self.timer:after(self.time_melee,function() self.estados.atacando=false self.no_moverse_atacando=false end)
	end
end

function C:keyreleased(key)
	self:keys_up(key)

	if key=="q" then
		self.estados.atacando=false
		self.no_moverse_atacando=false
	end
end

function C:mousepressed(x,y,button)

	if button==1 then
		self.disparo_continuo=true
	end
end

function C:mousereleased(x,y,button)
	self:shoot_up(x,y,button)

	if button==1 then
		self.disparo_continuo=false
	end
end

function C:wheelmoved(x,y)
	self:wheel(x,y)
end

return C