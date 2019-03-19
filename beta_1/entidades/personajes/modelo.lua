local Class = require "libs.hump.class"

local modelo = Class{}

function modelo:init(x,y,r)

	self.camview={x=0,y=0,w=0,h=0}

	self.movimiento={a=false,d=false,w=false,s=false}

	self.delta_velocidad=self.entidades.vector(0,0)
	self.delta=self.entidades.vector(0,0)
	
	self.radio=0
	self.z=0

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,no_moverse_atacando=false}

	self.vivo=true
	self.velocidad_media=self.velocidad/4
	self.velocidad_normal=self.velocidad

	self.timer=self.entidades.timer.new()

	self.ira=0

	self.timer:every(0.1, function() 
		self.ira=self.ira-2.5
		if self.ira<0 then
			self.ira=0
		end
	end)

	self.rx,self.ry=0,0


	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(r)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.ox,self.oy=self.collider:getWorldCenter()

	self.rad=self.shape:getRadius()

	self.radio=0


	self.shape_escudo=py.newCircleShape(r*2)
	self.fixture_escudo=py.newFixture(self.collider,self.shape_escudo)
	self.fixture_escudo:setSensor( true )


end



function modelo:drawing()

	for i, point in ipairs(self.points) do
		lg.circle("fill",point.x,point.y,5)
	end
end

function modelo:updating(dt)

	self.delta_velocidad = self.delta_velocidad * (1 - math.min(dt * self.friccion, 1))

	self.moviendo=false

	self.timer:update(dt)

	if not self.estados.congelado and not self.estados.no_moverse_atacando then
		self.radio=self:check_mouse_pos(self.entidades:getXY())
	end

	


	self.delta = self.entidades.vector(0,0)

	if self.movimiento.a then
		self.delta.x=-1
		self.moviendo=true
	end

	if self.movimiento.d then
		self.delta.x= 1
		self.moviendo=true
	end

	if self.movimiento.w then
		self.delta.y=-1
		self.moviendo=true
	end

	if self.movimiento.s then
		self.delta.y=1
		self.moviendo=true
	end


	self.delta:normalizeInplace()

	self.delta_velocidad=self.delta_velocidad+self.velocidad*self.delta

	if math.abs(self.delta_velocidad:len())<0.01 then
    	self.delta_velocidad=self.delta_velocidad*0
    end
	

	self.collider:setLinearVelocity(self.delta_velocidad:unpack())

	self.ox,self.oy=self.collider:getWorldCenter()

	self:points_shoot(self.radio)

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

function modelo:points_shoot(radio)
	local r=radio-math.pi/2
	for _,point in ipairs(self.points) do
		local qx=math.cos(r)*point.d+self.ox
		local qy=math.sin(r)*point.d+self.oy

		point.x=qx
		point.y=qy
	end
end

function modelo:shoot_down(x,y,bullet,rad)
	local bala= bullet(self.entidad,x,y,self.z,rad,self.creador)
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



function modelo:attack(daño)
	self.ira=self.ira+daño*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end

	self.hp=self.hp-(daño+daño*(self.ira/self.max_ira))
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

return modelo