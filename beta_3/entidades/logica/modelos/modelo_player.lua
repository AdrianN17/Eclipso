local Class = require "libs.hump.class"
local daño = require "entidades.logica.modelos.modelo_daño"
local destruccion = require "entidades.logica.modelos.modelo_destruccion"

local modelo_player = Class{
  __includes = {daño, destruccion}
}

function modelo_player:init(entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2)
  
  --objetos maestros
  self.entidades=entidades
  self.creador=creador
  
  
  self.entidades:add_obj("players",self)
  
  --estados
  self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false}
  self.direccion={a=false,d=false,w=false,s=false}
  
  --inicializar
  
  daño.init(self)
  destruccion.init(self)
  
  --ejes
  
  self.radio=0
  self.z=0
  self.rx,self.ry=0,0
  
  --atributos
  
  self.hp=hp
  self.velocidad=velocidad
  self.max_ira=ira
  self.ira=0
  
  --timers
  self.tiempo_escudo=self.tiempo_escudo
  

  --cuerpo
  
  self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newCircleShape(area)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( -self.creador )
	self.fixture:setUserData( {data="personaje",obj=self, pos=1} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  --escudo
  
  self.shape_escudo=py.newCircleShape(area*2.5)
	self.fixture_escudo=py.newFixture(self.collider,self.shape_escudo)
	self.fixture_escudo:setSensor( true )
	self.fixture_escudo:setGroupIndex( -self.creador )
	self.fixture_escudo:setUserData( {data="escudo",obj=self, pos=2}  )
	self.fixture_escudo:setDensity(0)
  
  --arma_distancia
  
  self.points={}

	for _,p in ipairs(puntos_arma) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(self.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -self.creador )
		t.fixture:setUserData( {data="brazos",obj=self, pos=3}  )
		t.fixture:setDensity(0)

		table.insert(self.points,t)
	end
  
  
  self:reset_mass(mass)
  
  self.disparo_max_timer=disparo_max_timer
  self.recarga_timer=recarga_timer
  self.timer_recargando=0
  
  self.data_balas={}
  
  if balas_data_1 then
    local bala1={}
    bala1.balas=balas_data_1.bala
    bala1.timer_disparo=0
    bala1.max=balas_data_1.balas_max
    bala1.stock=bala1.max
    bala1.id=1
    
    table.insert(self.data_balas,bala1)
  end
  
  if balas_data_2 then
    local bala2={}
    bala2.balas=balas_data_2.bala
    bala2.timer_disparo=0
    bala2.max=balas_data_2.balas_max
    bala2.stock=bala2.max
    bala2.id=2
    
    table.insert(self.data_balas,bala2)
  end
  
  self.arma=0
  
  self.can_armas=#self.data_balas
  
  if self.can_armas then
    self.arma=1
  end
  
  self.tiempo_atacado=0
  
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
  
  if self.can_armas and self.estados.atacando and not self.estados.recargando then
    
      self:creacion_balas(dt,self.data_balas[self.arma])
    
  elseif self.can_armas and not self.estados.atacando and self.estados.recargando then
    self.timer_recargando=self.timer_recargando+dt
    
    if self.timer_recargando>self.recarga_timer then
      
      self.data_balas[self.arma].stock=self.data_balas[self.arma].max
      
      self.timer_recargando=0
      self.estados.recargando=false
    end
    
  end
  
  if self.estados.atacado then
  
    self.tiempo_atacado=self.tiempo_atacado+dt
    
    if self.tiempo_atacado>0.5 then
      self.estados.atacado=false
      self.tiempo_atacado=0
    end
    
  end
  
end

function modelo_player:creacion_balas(dt,data)
  data.timer_disparo=data.timer_disparo+dt
  
  if data.timer_disparo>self.disparo_max_timer then
      
      self:bala_nueva(data)
      
      data.timer_disparo=0
  end
end

function modelo_player:bala_nueva(data)
  local s= self.points[data.id].fixture:getShape()
  local px,py=self.collider:getWorldPoints(s:getPoint())
  local rad=math.atan2( self.ry-py, self.rx -px)
  
  if data.stock>0 then
    data.balas(px, py, self.entidades, rad,self.creador)
    data.stock=data.stock-1
  end
end

function modelo_player:reset_bullet_time()
  for _,b in pairs(self.data_balas) do
    b.timer_disparo=0
  end
end

function modelo_player:mousepressed(x,y,button)
  if button==1 then
    self.estados.atacando=true
    self.estados.recargando=false
    
    self:bala_nueva(self.data_balas[self.arma])
  end
end

function modelo_player:mousereleased(x,y,button)
  if button==1 then
    self.estados.atacando=false
    self.estados.recargando=false
    self:reset_bullet_time()
  end
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
    self.estados.atacando=false
    self.estados.recargando=false
    self:reset_bullet_time()
  end
  
  if key=="1" and self.data_balas[1] then
    self:reset_bullet_time()
    self.arma=1
  end
  
  if key=="2" and self.data_balas[2] then
    self:reset_bullet_time()
    self.arma=2
  end
  
  if key=="r" and self.can_armas then
    self:reset_bullet_time()
    self.estados.recargando=true
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
    self.estados.atacando=false
    self.estados.recargando=false
    self:reset_bullet_time()
  end
end

function modelo_player:get_radio(rx,ry)
  return math.atan2( ry-self.oy, rx -self.ox)
end

return modelo_player