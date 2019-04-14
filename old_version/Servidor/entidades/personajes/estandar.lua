local Class = require "libs.hump.class"

local estandar = Class{}

function estandar:init()
	self.camx=0
	self.camy=0
	self.camw=0
	self.camh=0

	self.movimiento={a=false,d=false,w=false,s=false}
	self.delta_velocidad=self.entidad.vector(0,0)
	
	self.radio=0
	self.z=0

	self.collision= self.entidad.collisions

	self.estados={moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,no_moverse_atacando=false}

	self.vivo=true
	self.velocidad_media=self.velocidad/4
	self.velocidad_normal=self.velocidad

	self.timer=self.entidad.timer.new()

	self.ira=0

	self.timer:every(0.1, function() 
		self.ira=self.ira-2.5
		if self.ira<0 then
			self.ira=0
		end
	end)

	self.rx,self.ry=0,0

end

function estandar:drawing()

	self.collider:draw("line")

	if self.estados.protegido then
		self.escudo:draw("line")
	end

	for _,point in ipairs(self.points) do
		local x,y=point:center()
		lg.circle("fill",x,y,2)
	end
end

function estandar:updating(dt)
	self.moviendo=false

	self.timer:update(dt)

	if not self.estados.congelado and not self.estados.no_moverse_atacando then
		self.radio=self:check_mouse_pos(self.rx,self.ry)
	end


	self.delta_velocidad = self.delta_velocidad * (1 - math.min(dt * self.friccion, 1))

	delta = self.entidad.vector(0,0)

	if self.movimiento.a then
		delta.x=-1
		self.moviendo=true
	end

	if self.movimiento.d then
		delta.x= 1
		self.moviendo=true
	end

	if self.movimiento.w then
		delta.y=-1
		self.moviendo=true
	end

	if self.movimiento.s then
		delta.y=1
		self.moviendo=true
	end

	delta:normalizeInplace()

	self.delta_velocidad=self.delta_velocidad+self.velocidad*delta*dt


	if math.abs(self.delta_velocidad:len())<0.01 then
    	self.delta_velocidad=self.delta_velocidad*0
    end

    if not self.estados.congelado and not self.estados.no_moverse_atacando then
	    self.collider:move(self.delta_velocidad:unpack())
	    self.escudo:move(self.delta_velocidad:unpack())
	end

	self.ox,self.oy=self.collider:center()

	if not self.estados.congelado and not self.estados.no_moverse_atacando then
		for _,point in ipairs(self.points) do
	    	point:move(self.delta_velocidad:unpack())
	    	point:setRotation(self.radio-math.pi/2,self.ox,self.oy)
	    end
	end

end

function estandar:keys_down(key)
	if key=="a" then
		self.movimiento.a=true
	end

	if key=="d" then
		self.movimiento.d=true
	end

	if key=="w" then
		self.movimiento.w=true
	elseif key=="s" then
		self.movimiento.s=true
	end

	if key=="e" then
		self.estados.protegido=true
		self.timer:after(self.escudo_tiempo,function() self.estados.protegido=false end)
	end


end

function estandar:keys_up(key)
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

function estandar:shoot_down(x,y,bullet,rad)
	local bala= bullet(self.entidad,x,y,self.z,rad,self.creador)

	self.collision:add_collision_object("balas",bala)
end

function estandar:shoot_up(x,y,button)

end


function estandar:attack(daño)
	self.ira=self.ira+daño*2

	if self.ira>self.max_ira then
		self.ira=self.max_ira
	end

	self.hp=self.hp-(daño+daño*(self.ira/self.max_ira))
	if self.hp<1 then
		self.vivo=false
	end
end

function estandar:efecto(tipo,rapidez)

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

function estandar:recarga(key,arma1,arma2)

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

function estandar:mover_todo(ox,oy)
	local x,y=ox-self.ox,oy-self.oy
	self.collider:move(x,y)
	self.escudo:move(x,y)

	for _,point in ipairs(self.points) do
    	point:move(x,y)
    end

    if self.melee then
    	self.melee:moves(x,y)
    end
end

function estandar:check_mouse_pos(x,y)
	return math.atan2( y-self.oy, x -self.ox)
end

function estandar:remove_player()
	self.entidad.collisions:remove_collision_object("player",self)
end

function estandar:mover_player(x,y)
	self.collider:move(x,y)
	self.escudo:move(x,y)
	for _,point in ipairs(self.points) do
    	point:move(x,y)
    end

    if self.melee then
    	self.melee:moves(x,y)
    end
end

return estandar