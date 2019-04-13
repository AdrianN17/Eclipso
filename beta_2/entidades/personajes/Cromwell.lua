local Class = require "libs.hump.class"
local Modelo = require "entidades.personajes.modelo"
local semillas = require "entidades.objetos.balas.semillas"
local bullet_control = require "libs.Bullets.bullet_control"
--local melee = require "entidadeses.objetos.melees.melee"

local Cromwell = Class{
	__includes = Modelo
}


function Cromwell:init(entidades,x,y,creador)
	self.personaje="Cromwell"
	--inicializar
	self.entidades=entidades

	self.creador=creador

	self.velocidad=250

	self.friccion=30

	self.hp=1000

	self.max_ira=100

	self.escudo_tiempo=0.6

	

	self.points_data={
		{x=25, y=25}
	}

	Modelo.init(self,x,y,20)

	self.recargando_1=false


	self.melee_attack=95


	self.semillas_control=bullet_control(20,20,"infinito","infinito",self.timer,0.5)

	self.disparo_continuo=false

	self.time_melee=1.5


	self.timer:every(0.1, function()
		if self.disparo_continuo and not self.estados.protegido and self.semillas_control:check_bullet() and not self.recargando_1 then
			local x,y = self.rx,self.ry
			local s= self.points[1].fixture:getShape()
			local px,py=self.collider:getWorldPoints(s:getPoint())
			local rad=math.atan2( self.ry-py, self.rx -px)
			self:shoot_down(px,py,semillas,rad)
			self.semillas_control:newbullet()
		end
	end)

	self.estados.no_moverse_atacando=false


	self.shape_melee=py.newRectangleShape(100,0,50,50)
	self.fixture_melee=py.newFixture(self.collider,self.shape_melee)
	self.fixture_melee:setSensor( true )
	self.fixture_melee:setGroupIndex( -self.creador )
	self.fixture_melee:setUserData( {data="melee",obj=self, pos=3})
	self.fixture_melee:setDensity( 0 )

	self:reset_mass(60)


end

function Cromwell:draw()
	self:drawing()
end

function Cromwell:update(dt)
	self:updating(dt)
end

function Cromwell:keypressed(key)
	self:key_pressed(key)

	self:recarga(key,"semillas_control")

	if key=="q" and not self.estados.protegido then
		self.estados.atacando=true
		self.estados.no_moverse_atacando=true
		self.timer:after(self.time_melee,function() self.estados.atacando=false self.estados.no_moverse_atacando=false end)
	end
end

function Cromwell:keyreleased(key)
	self:key_released(key)

	if key=="q" then
		self.estados.atacando=false
		self.estados.no_moverse_atacando=false
	end
end

function Cromwell:mousepressed(x,y,button)

	if button==1 then
		self.disparo_continuo=true
	end
end

function Cromwell:mousereleased(x,y,button)
	self:shoot_up(x,y,button)

	if button==1 then
		self.disparo_continuo=false
	end
end

function Cromwell:wheelmoved(x,y)
	self:wheel_moved(x,y)
end

return Cromwell