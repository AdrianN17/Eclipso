function crear_cuerpo(obj,x,y,area)
	--cuerpo
  
  	obj.collider=py.newBody(obj.entidades.world,x,y,"dynamic")
	obj.collider:setFixedRotation(true)

	obj.shape=py.newCircleShape(area)
	obj.fixture=py.newFixture(obj.collider,obj.shape)
	obj.fixture:setGroupIndex( -obj.creador )
	obj.fixture:setUserData( {data="personaje",obj=obj, pos=1} )
	obj.fixture:setDensity(0)
	obj.collider:setInertia( 0 )

	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()
  
  	--escudo
  
  	obj.shape_escudo=py.newCircleShape(area*2.5)
	obj.fixture_escudo=py.newFixture(obj.collider,obj.shape_escudo)
	obj.fixture_escudo:setSensor( true )
	obj.fixture_escudo:setGroupIndex( -obj.creador )
	obj.fixture_escudo:setUserData( {data="escudo",obj=obj, pos=2}  )
	obj.fixture_escudo:setDensity(0)
end

function crear_brazos(obj,puntos_brazos)
	obj.points={}

	for _,p in ipairs(puntos_brazos) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(obj.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -obj.creador )
		t.fixture:setUserData( {data="brazos",obj=obj, pos=3}  )
		t.fixture:setDensity(0)

		table.insert(obj.points,t)
	end

end
  