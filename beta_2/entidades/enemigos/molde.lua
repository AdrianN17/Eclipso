local Class = require "libs.hump.class"

local molde = Class{}

function molde:init(x,y,w,h)
	self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newRectangleShape(w,h)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( 9 )
	self.fixture:setUserData( {data="enemigos",obj=self} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )


	self.shape_vision=py.newCircleShape(120)
	self.fixture_vision=py.newFixture(self.collider,self.shape_vision)
	self.fixture_vision:setSensor( true )
	self.fixture_vision:setGroupIndex( 9 )
	self.fixture_vision:setUserData( {data="enemigo_vision",obj=self}  )
	self.fixture_vision:setDensity(0)

	self.rad=self.shape:getRadius()

	self.radio=0



	self.ox,self.oy=self.collider:getX(),self.collider:getY()

	local data={{-50,0,20,60},{50,0,20,60},{0,-50,70,20},{0,50,70,20}}

	self.fixtures_sensor={}
	self.shapes_sensor={}

	for i, d in ipairs(data) do
		self.shapes_sensor[i]=py.newRectangleShape(d[1],d[2],d[3],d[4])
		self.fixtures_sensor[i]=py.newFixture(self.collider,self.shapes_sensor[i])
		self.fixtures_sensor[i]:setSensor( true )
		self.fixtures_sensor[i]:setGroupIndex( 9 )
		self.fixtures_sensor[i]:setUserData( {data="enemigo_sensor",obj=self}  )
		self.fixtures_sensor[i]:setDensity(0)
	end


	self.sensor_activado=false


end

function molde:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()

	--self.fixture:setFriction(0.5 )
	self.collider:setLinearDamping(mass/20)
end

function molde:drawing()
	--lg.print()
end

function molde:updating(dt)
	self.ox,self.oy=self.collider:getX(),self.collider:getY()
end

function molde:seguir()

end


return molde