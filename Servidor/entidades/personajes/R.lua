local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local plasma = require "entidades.objetos.balas.plasma"
local bullet_control = require "libs.Bullets.bullet_control"
local melee = require "entidades.objetos.melees.melee"

local R = Class{
	__includes = estandar
}


function R:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y

	self.creador=creador

	self.velocidad=400

	self.friccion=30

	self.hp=1000

	self.max_ira=250

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo_tiempo=0.6

	self.escudo=entidad.collider:circle(x,y,35)

	self.points={
		entidad.collider:point(self.ox+30,self.oy)
	}

	self.recargando_1=false

	self.time_melee=0.5

	estandar.init(self)
	
	self.melee=melee(75,entidad.collider:rectangle(self.ox-25,self.oy+15,10,50),self,self.creador)

	self.estados.atacando=false

	self.entidad.collisions:add_collision_object("player",self)
	self.plasma_control=bullet_control(2,2,"infinito","infinito",self.timer,0.6)
end

function R:draw()
	self:drawing()
end

function R:update(dt)
	self:updating(dt)
end

function R:keypressed(key)
	self:keys_down(key)
	self:recarga(key,"plasma_control")

	if key=="q" and not self.estados.protegido then
		self.estados.atacando=true
		self.timer:after(self.time_melee,function() self.estados.atacando=false end)
	end
end

function R:keyreleased(key)
	self:keys_up(key)

	if key=="q" then
		self.estados.atacando=false
	end
end

function R:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.plasma_control:check_bullet() and not self.recargando_1 then
		self:shoot_down(px,py,plasma,rad,self.creador)
		self.plasma_control:newbullet()
	end
end

function R:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function R:wheelmoved(x,y)
	self:wheel(x,y)
end

return R
