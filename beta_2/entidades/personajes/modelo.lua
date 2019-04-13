local Class = require "libs.hump.class"

local modelo = Class{}

function modelo:init(x,y,r)

	self.camx=0
	self.camy=0
	self.camw=0
	self.camh=0

	self.movimiento={a=false,d=false,w=false,s=false}

	self.delta=self.entidades.vector(0,0)
	
	self.radio=0
	self.z=0

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,no_moverse_atacando=false}

	self.vivo=true
	self.velocidad_media=self.velocidad/4
	self.velocidad_normal=self.velocidad

	self.timer=self.entidades.timer.new()

	self.ira=0

	self.every=self.timer:every(0.1, function() 
		self.ira=self.ira-2.5
		if self.ira<0 then
			self.ira=0
		end
	end)

	self.rx,self.ry=0,0




	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newCircleShape(r)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( -self.creador )
	self.fixture:setUserData( {data="personaje",obj=self, pos=0} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	self.rad=self.shape:getRadius()

	self.radio=0

	self.shape_escudo=py.newCircleShape(r*2.5)
	self.fixture_escudo=py.newFixture(self.collider,self.shape_escudo)
	self.fixture_escudo:setSensor( true )
	self.fixture_escudo:setGroupIndex( -self.creador )
	self.fixture_escudo:setUserData( {data="escudo",obj=self, pos=1}  )
	self.fixture_escudo:setDensity(0)


	self.points={}

	for _,p in ipairs(self.points_data) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(self.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -self.creador )
		t.fixture:setUserData( {data="postura",obj=self, pos=2}  )
		t.fixture:setDensity(0)

		table.insert(self.points,t)
	end


end

function modelo:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()

	--self.fixture:setFriction(0.5 )
	self.collider:setLinearDamping(mass/20)
end



function modelo:drawing()
	lg.print(tostring(self.estados.quemadura),self.ox,self.oy-100)
end

function modelo:updating(dt)

	self.estados.moviendo=false

	self.timer:update(dt)

	if not self.estados.congelado then
		self.radio=self:check_mouse_pos(self.rx,self.ry)
	end

	self.delta = self.entidades.vector(0,0)

	if self.movimiento.a then
		self.delta.x=-1
		self.estados.moviendo=true
	end

	if self.movimiento.d then
		self.delta.x= 1
		self.estados.moviendo=true
	end

	if self.movimiento.w then
		self.delta.y=-1
		self.estados.moviendo=true
	end

	if self.movimiento.s then
		self.delta.y=1
		self.estados.moviendo=true
	end


	self.delta:normalizeInplace()

	if self.estados.moviendo and not self.estados.atacado then
		local x,y=self.delta.x*self.mass*self.velocidad*dt,self.delta.y*self.mass*self.velocidad*dt
		local vx,vy=self.collider:getLinearVelocity()

		if vx<self.velocidad or vy<self.velocidad then
			self.collider:applyLinearImpulse(x,y)
		end
	end

	self.ox,self.oy=self.collider:getX(),self.collider:getY()


	self.collider:setAngle(self.radio)

	if not self.vivo then
	 	self:remove()
	end


end

function modelo:key_pressed(key)
	if key=="a" then
		self.movimiento.a=true
	end

	if key=="d" then
		self.movimiento.d=true
	end

	if key=="w" then
		self.movimiento.w=true
	end

	if key=="s" then
		self.movimiento.s=true
	end

	if key=="e" then
		self.estados.protegido=true
		self.timer:after(self.escudo_tiempo,function() self.estados.protegido=false end)
	end
end

function modelo:key_released(key)
	if key=="a" then
		self.movimiento.a=false
	end

	if key=="d" then
		self.movimiento.d=false
	end

	if key=="w" then
		self.movimiento.w=false
	end

	if key=="s" then
		self.movimiento.s=false
	end

	if key=="e" then
		self.estados.protegido=false
	end

end

function modelo:check_mouse_pos(x,y)
	return math.atan2( y-self.oy, x -self.ox)
end

function modelo:wheel_moved(x,y)
	self.z=self.z+y*5

	if self.z>45 then
		self.z=45
	elseif self.z<0 then
		self.z=0
	end
end

function modelo:shoot_down(x,y,bullet,rad)
	local bala= bullet(self.entidades,x,y,self.z,rad,self.creador)
end


function modelo:recarga(key,arma1,arma2)

	if key=="r" then
		if arma1 then
			self.recargando_1=true
			self[arma1]:reload(self)
		end

		if arma2 then
			self.recargando_2=true
			self[arma2]:reload(self)
		end
	end
end

function modelo:shoot_down(x,y,bullet,rad)
	local bala= bullet(self.entidades,x,y,self.z,rad,self.creador)
end

function modelo:shoot_up(x,y,button)
	
end


function modelo:attack(daño)
	
	self.hp=self.hp-(daño+daño*(self.ira/self.max_ira))

	self.ira=self.ira+daño*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end

	if self.hp<1 then
		self.vivo=false
	end
end

function modelo:efecto(tipo,rapidez)

	local len=0

	if tipo=="congelado" then
		len=12
		time=3
	elseif tipo=="quemadura" then
		len=7
		time=5
	elseif tipo=="paralisis" then
		len=5
		time=2
	elseif tipo=="plasma" then
		time=1.5
	end

	

	local seed=lm.random(1,len)
	local prob=lm.random(1,len)

	if seed==prob or rapidez then

		self.estados[tipo]=true

		if tipo=="quemadura" then
			self.timer:during(time, function(dt) self.hp=self.hp-dt*1.25 end)
		elseif tipo=="paralisis" then
			self.velocidad=self.velocidad_media
		end

		self.timer:after(time,function() 
			self.estados[tipo]=false 
			if self.estados["paralisis"]==false then
				self.velocidad=self.velocidad_normal
			end
		end)

		if tipo=="plasma" then
			self.timer:during(time, function(dt) self.hp=self.hp-dt*2.5 end)
		end
	end
end

function modelo:remove()
	self.collider:destroy()

	self.timer:cancel(self.every)
	self.timer:clear( ) 

	if not self.vivo then
		self.entidades.server:sendToAll("remover", self.creador)
	end

	self.entidades:remove_to_nill("players",self)
end

function modelo:send_data()
	local data={}
	data.personaje=self.personaje
	data.ox,data.oy=self.ox,self.oy
	data.hp=self.hp 
	data.ira=self.ira 
	data.movimiento=self.movimiento
	data.estados=self.estados

	if self.fixture_melee then
		local s= self.fixture_melee:getShape()

		local x1,y1,x2,y2,x3,y3,x4,y4=self.collider:getWorldPoints(s:getPoints())


		data.px=(x1+x2+x3+x4)/4
		data.py=(y1+y2+y3+y4)/4

		
	end

	local f=self.fixture:getShape()
	data.r=f:getRadius()

	return data
end

return modelo