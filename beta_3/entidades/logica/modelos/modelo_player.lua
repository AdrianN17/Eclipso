local Class = require "libs.hump.class"

local modelo_player = Class{}

function modelo_player:init(entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass)
  --estados
  self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true}
  self.direccion={a=false,d=false,w=false,s=false}
  
  --ejes
  
  self.radio=0
  self.z=0
  self.rx,self.ry=0,0
  
  --atributos
  
  self.hp=hp
  self.velocidad=velocidad
  self.ira=ira
  
  --timers
  self.tiempo_escudo=self.tiempo_escudo
  
  --objetos maestros
  self.entidades=entidades
  self.creador=creador
  
  --cuerpo
  
  self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newCircleShape(area)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( -self.creador )
	self.fixture:setUserData( {data="personaje",obj=self, pos=0} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  --escudo
  
  self.shape_escudo=py.newCircleShape(area*2.5)
	self.fixture_escudo=py.newFixture(self.collider,self.shape_escudo)
	self.fixture_escudo:setSensor( true )
	self.fixture_escudo:setGroupIndex( -self.creador )
	self.fixture_escudo:setUserData( {data="escudo",obj=self, pos=1}  )
	self.fixture_escudo:setDensity(0)
  
  --arma_distancia
  
  self.points={}

	for _,p in ipairs(puntos_arma) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(self.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -self.creador )
		t.fixture:setUserData( {data="postura",obj=self, pos=2}  )
		t.fixture:setDensity(0)

		table.insert(self.points,t)
	end
  
  
  self:reset_mass(mass)
end

function modelo_player:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()


	self.collider:setLinearDamping(mass/20)
end

function modelo_player:update(dt)
  local x,y=0,0
  self.estados.moviendo=false
  
  if self.direccion.a then
    x=-1
    self.estados.moviendo=true
  end
  
  if self.direccion.d then
    x=1
    self.estados.moviendo=true
  end
  
  if self.direccion.w then
    y=-1
    self.estados.moviendo=true
  end
  
  if self.direccion.s then
    y=1
    self.estados.moviendo=true
  end
  
  
  if not self.estados.congelado then
    self.radio=self:get_radio(self.rx,self.ry)
  end
  
  if self.estados.moviendo and not self.estados.atacado and not self.estados.dash then
		local mx,my=x*self.mass*self.velocidad*dt,y*self.mass*self.velocidad*dt
		local vx,vy=self.collider:getLinearVelocity()
    


		if vx<self.velocidad or vy<self.velocidad then
			self.collider:applyLinearImpulse(mx,my)
		end
	end

	self.ox,self.oy=self.collider:getX(),self.collider:getY()

  
  self.collider:setAngle(self.radio)
  
  self:update_animation(dt)
end

function modelo_player:mousepressed(x,y,button)
  self.estados.atacando=true
end

function modelo_player:mousereleased(x,y,button)
  self.estados.atacando=false
end

function modelo_player:keypressed(key)
  if key=="a" then
    self.direccion.a=true
  elseif key=="d" then
    self.direccion.d=true
  end
  
  if key=="w" then
    self.direccion.w=true
  elseif key=="s" then
    self.direccion.s=true
  end
  
  if key=="e" then
    self.estados.protegido=true
  end
end

function modelo_player:keyreleased(key)
  if key=="a" then
    self.direccion.a=false
  elseif key=="d" then
    self.direccion.d=false
  end
  
  if key=="w" then
    self.direccion.w=false
  elseif key=="s" then
    self.direccion.s=false
  end
  
  if key=="e" then
    self.estados.protegido=false
  end
end

function modelo_player:get_radio(rx,ry)
  return math.atan2( ry-self.oy, rx -self.ox)
end

return modelo_player