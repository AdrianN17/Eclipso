local Class = require "libs.hump.class"

local cubo_de_hielo = Class {}

function cubo_de_hielo:init(entidades,x,y)
	self.entidades=entidades
	self.entidades:add_obj("efectos",self)
	--self.collider=self.entidad.collider:polygon(x-20,y-20,x-30,y,x-20,y+20,x+20,y+20,x+30,y,x+20,y-20)


	--self.radio=love.math.random(0,360)
	--self.collider:rotate(math.rad(self.radio))

	self.collider=py.newBody(self.entidades.world,x,y,"static")
	self.collider:setMass(10)
	self.shape=py.newCircleShape(40)
	self.fixture=py.newFixture(self.collider,self.shape)

	self.fixture:setUserData( {data="cubo_de_hielo",obj=self} )

	self.hp=100


	self.time=0
	self.tipo="cubo_de_hielo"
	self.ox,self.oy=self.collider:getWorldCenter()

end

function cubo_de_hielo:draw()

end

function cubo_de_hielo:update(dt)
	self.time=self.time+dt
	if self.time>15 then
		self:remove()
	end
end

function cubo_de_hielo:resize()
	local f=self.fixture:getShape()

	local r=f:getRadius()


	if r<80 then
		f:setRadius(r+20)
		
	end

	if self.hp<200 then
		self.hp=self.hp+25
	end

	
	--self.scale=self.scale*1.25
	--self.collider:scale(self.scale)
	--se puede hacer con uno que sea 1.25 y otro 0.75, con un counter de -3 a 3 siendo 0 el punto estandar
end

function cubo_de_hielo:remove()
	self.collider:destroy()
	self.entidades:remove_obj("efectos",self)
end

function cubo_de_hielo:attack(daño)
	self.hp=self.hp-daño
	if self.hp<1 then
		self:remove()
	end
end

function cubo_de_hielo:send_data()
	local data={}
	data.tipo=self.tipo
	data.ox,data.oy=self.ox,self.oy
	data.hp=self.hp 

	local f=self.fixture:getShape()
	data.r=f:getRadius()


	return data
end

return cubo_de_hielo
