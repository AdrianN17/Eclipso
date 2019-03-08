local Class = require "libs.hump.class"
local estandar = require "entidades.personajes.estandar"
local ectoplasma =  require "entidades.objetos.balas.ectoplasma"
local bullet_control = require "libs.Bullets.bullet_control"

local MrH_S = Class{
	__includes = estandar
}

function MrH_S:init(entidad,x,y,creador)
	--inicializar
	self.entidad=entidad
	self.x,self.y=x,y
	self.creador=creador


	self.velocidad=650

	self.friccion=30

	self.hp=200

	self.max_ira=170

	self.collider=entidad.collider:circle(x,y,20)

	self.ox,self.oy=self.collider:center()

	self.escudo=entidad.collider:circle(x,y,25)

	self.escudo_tiempo=1

	self.points={
		entidad.collider:point(self.ox-30,self.oy)
	}

	self.recargando_1=false

	--herencia
	estandar.init(self)

	self.entidad.collisions:add_collision_object("player",self)

	self.ectoplasma_control=bullet_control(12,12,"infinito","infinito",self.timer,0.7)
end

function MrH_S:draw()
	if not self.estados.protegido then
		self:drawing()
	end
end

function MrH_S:update(dt)
	self:updating(dt)
end

function MrH_S:keypressed(key)
	self:keys_down(key)

	self:recarga(key,"ectoplasma_control")
end

function MrH_S:keyreleased(key)
	self:keys_up(key)
end


function MrH_S:mousepressed(x,y,button)
	local px,py=self.points[1]:center()
	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.ectoplasma_control:check_bullet() and not self.recargando_1  then
		self:shoot_down(px,py,ectoplasma,rad,self.creador)
		self.ectoplasma_control:newbullet()
	end
end

function MrH_S:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function MrH_S:wheelmoved(x,y)
	self:wheel(x,y)
end

return MrH_S