local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local hielo =  require "entidades.objetos.balas.hielo"
local fuego =  require "entidades.objetos.balas.fuego"
local bullet_control = require "libs.Bullets.bullet_control"

local Aegis = Class{
	__includes=Modelo
}

function Aegis:init(entidades,x,y,creador)
	self.personaje="Aegis"

	self.entidades=entidades
	
	self.creador=creador

	self.velocidad=400
	self.hp=500
	self.max_ira=200

	self.recargando_1=false
	self.recargando_2=false

	self.escudo_tiempo=0.3

	self.friccion=30


	self.points_data={
		{x=25, y=25},
		{x=25, y=-25}
	}

	Modelo.init(self,x,y,20)

	
	self.hielo_control=bullet_control(2,2,"infinito","infinito",self.timer,0.5)
	self.fuego_control=bullet_control(4,4,"infinito","infinito",self.timer,0.2)

	self:reset_mass(30)
end

function Aegis:draw()
	self:drawing()
end

function Aegis:update(dt)
	self:updating(dt)
end

function Aegis:keypressed(key)
	self:key_pressed(key)
	self:recarga(key,"fuego_control","hielo_control")
end

function Aegis:keyreleased(key)
	self:key_released(key)
end

function Aegis:mousepressed(x,y,button)
	local s= self.points[button].fixture:getShape()
	local px,py=self.collider:getWorldPoints(s:getPoint())


	local rad=math.atan2( y-py, x -px)

	if button==1 and not self.estados.protegido and self.fuego_control:check_bullet() and not self.recargando_1 then
		self:shoot_down(px,py,fuego,rad,self.creador)
		self.fuego_control:newbullet()
	elseif button==2 and not self.estados.protegido and self.hielo_control:check_bullet() and not self.recargando_2 then
		self:shoot_down(px,py,hielo,rad,self.creador)
		self.hielo_control:newbullet()
	end
end

function Aegis:mousereleased(x,y,button)
	self:shoot_up(x,y,button)
end

function Aegis:wheelmoved(x,y)
	self:wheel_moved(x,y)
end

function Aegis:reflejo(obj,dx,dy) 
	obj.z=obj.z+5

	obj.delta_velocidad.x,obj.delta_velocidad.y=-dx,-dy

	self.estados.protegido=false
end


function Aegis:touchpressed(id,x,y,dx,dy,pressure)
	
end

function Aegis:touchreleased(id,x,y,dx,dy,pressure)
	
end

return Aegis