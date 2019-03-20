local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local agujas = require "entidades.objetos.balas.agujas"
local bullet_control = require "libs.Bullets.bullet_control"
--local melee = require "entidadeses.objetos.melees.melee"

local Xeon = Class{
	__includes = Modelo
}

function Xeon:init(entidades,x,y,creador)
	self.personaje="X"
	--inicializar
	self.entidades=entidades

	self.creador=creador

	self.velocidad=300

	self.friccion=30

	self.hp=1000

	self.max_ira=300

	self.escudo_tiempo=0.6

	Modelo.init(self,x,y,20)

	self.points={
		{x=self.ox+35, y=self.oy,d=35}
	}

	self.recargando_1=false


	self.agujas_control=bullet_control(10,10,"infinito","infinito",self.timer,0.5)

	self.disparo_continuo=false

	self.time_melee=1

	self.melee_attack=75

	self.timer:every(0.2,function() 
		if self.disparo_continuo and not self.estados.protegido and self.agujas_control:check_bullet() and not self.recargando_1 then
			local px,py=self.points[1].x,self.points[1].y

			local rad=math.atan2( self.ry-py, self.rx -px)

			self:shoot_down(px,py,agujas,rad)
			self.agujas_control:newbullet()
		end
	end)


	self.shape_melee=py.newRectangleShape(45,20,100,35)
	self.fixture_melee=py.newFixture(self.collider,self.shape_melee)
	self.fixture_melee:setSensor( true )
	self.fixture_melee:setGroupIndex( -self.creador )
	self.fixture_melee:setUserData( {data="melee",obj=self}  )
	self.fixture_melee:setDensity( 0 )

	self:reset_mass(25)
end


function Xeon:draw()
	self:drawing()
end

function Xeon:update(dt)
	self:updating(dt)
end

function Xeon:keypressed(key)
	self:key_pressed(key)
	self:recarga(key,"agujas_control")

	if key=="q" and not self.estados.protegido then
		self.estados.atacando=true
		self.timer:after(self.time_melee,function() self.estados.atacando=false end)
	end
end

function Xeon:keyreleased(key)
	self:key_released(key)
	if key=="q" then
		self.estados.atacando=false
	end
end

function Xeon:mousepressed(x,y,button)

	local px,py=self.points[1].x,self.points[1].y

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

function Xeon:mousereleased(x,y,button)
	self:shoot_up(x,y,button)

	if button==1 then
		self.disparo_continuo=false
	end
end

function Xeon:wheelmoved(x,y)
	self:wheel(x,y)
end

return Xeon