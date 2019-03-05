local Class = require "libs.hump.class"

local estandar = Class{}

function estandar:init()
	self.movimiento={a=false,d=false,w=false,s=false}
	self.velocidad=self.entidad.vector(0,0)
	
	self.friction=20
end

function estandar:drawing()
	lg.print("OX,OY : " .. self.ox .. " , " .. self.oy ,self.ox,self.oy+100)
	lg.print("vx,vy : " .. self.velocidad.x .. " , " .. self.velocidad.y,self.ox,self.oy+120)
	--lg.print("dx,dy" .. self.delta.x .. " , " .. self.delta.y,self.ox,self.oy+140)
	self.collider:draw("fill")
end

function estandar:updating(dt)

	delta = self.entidad.vector(0,0)

	if self.movimiento.a then
		delta.x=-1
	elseif self.movimiento.d then
		delta.x= 1
	end

	if self.movimiento.w then
		delta.y=-1
	elseif self.movimiento.s then
		delta.y=1
	end


	delta:normalizeInplace()

	--[[delta=delta+ delta * self.velocidad *dt

	print(delta:unpack())

	]]

	self.velocidad = self.velocidad + delta * self.acc * dt

    if self.velocidad:len() > self.max_velocidad then
        self.velocidad = self.velocidad:normalized() * self.max_velocidad
    end

    self.collider:move(delta:unpack())

	self.ox,self.oy=self.collider:center()
end

function estandar:shoot()

end

function estandar:keys_down(key)
	if key=="a" then
		self.movimiento.a=true
	elseif key=="d" then
		self.movimiento.d=true
	end

	if key=="w" then
		self.movimiento.w=true
	elseif key=="s" then
		self.movimiento.s=true
	end
end

function estandar:keys_up(key)
	if key=="a" then
		self.movimiento.a=false
		self.velocidad.x=0
	elseif key=="d" then
		self.movimiento.d=false
		self.velocidad.x=0
	end

	if key=="w" then
		self.movimiento.w=false
		self.velocidad.y=0
	elseif key=="s" then
		self.movimiento.s=false
		self.velocidad.y=0
	end
end


return estandar