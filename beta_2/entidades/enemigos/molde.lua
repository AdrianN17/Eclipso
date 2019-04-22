local Class = require "libs.hump.class"

local molde = Class{}

function molde:init(x,y,w,h,bala_enemigo,bullet_control,rad_rango)
	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newRectangleShape(w,h)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( -self.creador )
	self.fixture:setUserData( {data="enemigos",obj=self, pos=9} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.timer=self.entidades.timer.new()


	self.shape_vision=py.newCircleShape(0,80,rad_rango)
	self.fixture_vision=py.newFixture(self.collider,self.shape_vision)
	self.fixture_vision:setSensor( true )
	self.fixture_vision:setGroupIndex( -self.creador )
	self.fixture_vision:setUserData( {data="enemigo_vision",obj=self, pos=10}  )
	self.fixture_vision:setDensity(0)

	self.radio=0


	self.ira=0

	self.z=0

	self.every=self.timer:every(0.1, function() 
		self.ira=self.ira-2.5
		if self.ira<0 then
			self.ira=0
		end
	end)

	self.mover_val=false
	self.touch=false

	self.timer:every(2.5, function()

			self.radio=self.radio+math.rad(love.math.random(0,360))

	end)

	self.timer:every(0.5, function()
		if  not self.sensor_activado and not self.atacante then
			self.mover_val=not self.mover_val
		end
	end)


	self.control=bullet_control(self.stock,self.municion,"infinito","infinito",self.timer,self.tiempo_recarga)

	self.every_2=self.timer:every(self.tiempo_disparo, function() 
		if  not self.estados.protegido and self.control:check_bullet() and not self.recargando and self.estados.atacando then

			local s= self.point_fixture:getShape()
			local px,py=self.collider:getWorldPoints(s:getPoint())

			local bala= bala_enemigo(self.entidades,px,py,self.z,self.radio,self.creador)
			self.control:newbullet()
		elseif self.control:check_bullet_cantidad()==0 and not self.recargando then
			self.control:reload(self)
		end


	end)

	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	self.shape_sensor=py.newCircleShape(0,50,20)
	self.fixture_sensor=py.newFixture(self.collider,self.shape_sensor)
	self.fixture_sensor:setSensor( true )
	self.fixture_sensor:setGroupIndex( -self.creador )
	self.fixture_sensor:setUserData( {data="enemigo_sensor",obj=self, pos=11}  )
	self.fixture_sensor:setDensity(0)

	


	self.sensor_activado=false

	self.presa_id=0
	self.presas={}

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,no_moverse_atacando=false}

	self.vivo=true
	self.velocidad_media=self.velocidad/4
	self.velocidad_normal=self.velocidad

	self.atacante=false
	self.radio_atacante=0

	

	self.point_shape=py.newCircleShape(self.points_data[1].x,self.points_data[1].y,4)
	self.point_fixture=py.newFixture(self.collider,self.point_shape)
	self.point_fixture:setSensor( true )
	self.point_fixture:setGroupIndex( -self.creador )
	self.point_fixture:setUserData( {data="postura_enemigo",obj=self, pos=12}  )
	self.point_fixture:setDensity(0)

	self.melee_point={}


	if self.melee_points then

		for _,p in ipairs(self.melee_points) do
			local t={}

			t.shape=py.newCircleShape(p.x,p.y,p.r)
			t.fixture=py.newFixture(self.collider,t.shape)
			t.fixture:setSensor( true )
			t.fixture:setGroupIndex( -self.creador )
			t.fixture:setUserData( {data="melee_enemigo",obj=self, pos=13}  )
			t.fixture:setDensity(0)

			table.insert(self.melee_point,t)
		end

	end

	self.len=0

	


end

function molde:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()

	--self.fixture:setFriction(0.5 )
	self.collider:setLinearDamping(mass/20)
end

function molde:drawing()
	--lg.print(#self.presas .. " .. " .. self.len,self.ox,self.oy-100)
	lg.print(tostring(self.touch),self.ox,self.oy-150)
	--lg.print(tostring(self.sensor_activado),self.ox,self.oy-200)

	
end

function molde:updating(dt)

	self.timer:update(dt)
	self.estados.atacando=false

	--seguir
	if self.sensor_activado and #self.presas>0 then
		local x,y,len=self:cazar()

		self.len = len

		self:seguir(x,y,dt)

		self.estados.atacando=true
	--atacar
	elseif self.atacante then
		self.radio=self.radio_atacante-math.pi
		self:set_vel(self.radio,false,dt)

		self.estados.atacando=true
	else 

		--posiciones random
		if self.mover_val and not self.touch then
			self:set_vel(self.radio,false,dt)
		end
	end




	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	self.rad=self.collider:getAngle()

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

function molde:seguir(x,y,dt)

	self.radio=math.atan2(y-self.oy, x -self.ox)

	self:set_vel(self.radio,true,dt)

end

function molde:set_vel(radio,val,dt)
	local rx,ry=math.cos(radio),math.sin(radio)

	self.collider:setAngle(radio-math.pi/2)


	if self.len>self.max_distancia or not val then
		if not self.estados.atacado then
			local x,y=rx*self.mass*self.velocidad*dt,ry*self.mass*self.velocidad*dt
			local vx,vy=self.collider:getLinearVelocity()

			if vx<self.velocidad or vy<self.velocidad then
				self.collider:applyLinearImpulse(x,y)
			end
		end
	end
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

	return self.presas[it].obj.ox,self.presas[it].obj.oy, len
end

function molde:detener_caza()
	self.timer:after(self.tiempo_seguir, function() self.atacante=false  end)
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

function molde:obj_atacado()
	self.timer:after(0.5, function () self.estados.atacado=false end)
end

function molde:almacenar_enemigos(obj)
	local val=false

	for i,data in ipairs(self.presas) do
		if data.id == obj.creador then
	 		val=true
	 		break
	 	end
	end

	if not val then
		table.insert(self.presas,{obj=obj, id = obj.creador})
	end

end

function molde:olvidar_enemigos(obj)

	self.sensor_activado=false

 	for i,data in ipairs(self.presas) do
 		if data.id == obj.creador then
 			table.remove(self.presas,i)
 			break
 		end
 	end

end




return molde