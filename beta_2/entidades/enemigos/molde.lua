local Class = require "libs.hump.class"

local molde = Class{}

function molde:init(x,y,w,h)
	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newRectangleShape(w,h)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( self.creador )
	self.fixture:setUserData( {data="enemigos",obj=self, pos=9} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.timer=self.entidades.timer.new()


	self.shape_vision=py.newCircleShape(120)
	self.fixture_vision=py.newFixture(self.collider,self.shape_vision)
	self.fixture_vision:setSensor( true )
	self.fixture_vision:setGroupIndex( self.creador )
	self.fixture_vision:setUserData( {data="enemigo_vision",obj=self, pos=10}  )
	self.fixture_vision:setDensity(0)

	self.rad=self.shape:getRadius()

	self.radio=0

	self.ira=0

	self.z=0

	self.every=self.timer:every(0.1, function() 
		self.ira=self.ira-2.5
		if self.ira<0 then
			self.ira=0
		end
	end)

	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	local data={{-50,0,20,60},{50,0,20,60},{0,-50,70,20},{0,50,70,20}}

	self.fixtures_sensor={}
	self.shapes_sensor={}

	for i, d in ipairs(data) do
		self.shapes_sensor[i]=py.newRectangleShape(d[1],d[2],d[3],d[4])
		self.fixtures_sensor[i]=py.newFixture(self.collider,self.shapes_sensor[i])
		self.fixtures_sensor[i]:setSensor( true )
		self.fixtures_sensor[i]:setGroupIndex( self.creador )
		self.fixtures_sensor[i]:setUserData( {data="enemigo_sensor",obj=self, pos=11}  )
		self.fixtures_sensor[i]:setDensity(0)
	end


	self.sensor_activado=false

	self.presa_id=0
	self.presas={}

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,no_moverse_atacando=false}

	self.vivo=true
	self.velocidad_media=self.velocidad/4
	self.velocidad_normal=self.velocidad

	self.atacante=false
	self.radio_atacante=0


end

function molde:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()

	--self.fixture:setFriction(0.5 )
	self.collider:setLinearDamping(mass/20)
end

function molde:drawing()
	lg.print(tostring(self.atacante),self.ox,self.oy-50)
end

function molde:updating(dt)

	self.timer:update(dt)

	--seguir
	if self.sensor_activado and #self.presas>0 and not self.atacante then
		local x,y=self:cazar()


		self:seguir(x,y)

	elseif self.atacante then

		self:set_vel(self.radio_atacante-math.pi)
	end




	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	if  not self.vivo then
	 	self:remove()
	end

end

function molde:remove()
	self.collider:destroy()

	self.timer:cancel(self.every)
	self.timer:clear( ) 

	self.entidades:remove_obj("enemigos",self)
end

function molde:seguir(x,y)

	self.radio=math.atan2(y-self.oy, x -self.ox)

	self:set_vel(self.radio)

end

function molde:set_vel(radio)
	local rx,ry=math.cos(radio),math.sin(radio)

	self.collider:setAngle(radio-math.pi/2)


	self.collider:setLinearVelocity(rx*self.velocidad,ry*self.velocidad)
end

function molde:cazar()
	local it,len=0,0
	for i , data in ipairs(self.presas) do
		local dx,dy=data.obj.ox,data.obj.oy
		local rx,ry=dx-self.ox,dy-self.oy
		local l= math.sqrt(rx*rx,ry*ry)



		if l>len then
			len=l
			it=i
		end

	end

	return self.presas[it].obj.ox,self.presas[it].obj.oy
end

function molde:detener_caza()
	self.timer:after(0.5, function() self.atacante=false  end)
end

function molde:attack(daño)

	self.hp=self.hp-(daño+daño*(self.ira/self.max_ira))

	self.ira=self.ira+daño*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end


	if self.hp<1 then
		self.vivo=false
	end
end

function molde:efecto(tipo,rapidez)

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


return molde