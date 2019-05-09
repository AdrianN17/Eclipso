local Class = require "libs.hump.class"

local modelo_balas = Class{}

function modelo_balas:init(x,y,entidades,velocidad,radio,creador)
  self.inicial_x,self.inicial_y=x,y
  self.entidades=entidades
  self.velocidad=velocidad
  self.radio=radio
  
  self.entidades:add_obj("balas",self)
  
  self.creador=creador
  
  self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.shape=py.newCircleShape(5)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setUserData( {data="bala",obj=self, pos=4} )
	
	self.fixture:setGroupIndex( -self.creador )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()

  self.z=0
  
  self:reset_mass(5)
end

function modelo_balas:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()

	self.collider:setLinearDamping(mass/20)
end

function modelo_balas:update(dt)
  
  local v = dt*self.velocidad
  local x,y=self.mass*math.cos(self.radio)*v ,self.mass*math.sin(self.radio)*v
  
  local vx,vy=self.collider:getLinearVelocity()
  
  if vx<self.velocidad or vy<self.velocidad then
    self.collider:applyLinearImpulse(x,y)
  end

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
end

function modelo_balas:remove()

	self.collider:destroy( )
	self.entidades:remove_obj("balas",self)
end

return modelo_balas